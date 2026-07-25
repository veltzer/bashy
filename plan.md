# bashy improvement plan, round two

The first round (`doc/plan_done.md`) was all about the installer path. That is in
good shape now, so this round looks at what actually runs on every shell you open,
plus the things that got lost or left behind along the way.

Ordered by what is worth doing first. Item 4 is included for completeness but is
probably not worth acting on.

Status legend: `DONE`, `TODO`.

## 1. Shell startup takes three seconds - TODO

This is the big one. Measured on this machine, repeatably:

- `bash -ic exit` - **3.0 s**
- sourcing `~/.bashy/bashy.sh` alone - **1.2 s**

Every interactive shell, every terminal tab, every `bash -c` in a script pays this.

`strace -c` counts **236 execve and 279 clone** calls for a single startup. The
plugin activations sum to 1.44 s across 74 plugins, and the worst offenders are all
subprocess spawns for shell completions:

| plugin | cost |
| --- | --- |
| python | 156 ms |
| minikube | 108 ms |
| complete | 108 ms |
| ai_claude | 90 ms |
| uv | 88 ms |
| buck2 | 83 ms |
| k8s | 82 ms |
| ai_agy | 81 ms |
| gh | 60 ms |

`minikube completion bash` alone takes 117 ms to run.

Sixteen plugins shell out for completions this way. The output is deterministic -
running `minikube completion bash` twice gives a byte identical result - so it can
be generated once and cached on disk, keyed by the tool's version or mtime, and
sourced from the cache afterwards. A `bashy_completion_cached <name> <command>`
helper in core would let all sixteen share it.

That alone should take the bulk of a second off every shell.

## 2. Profiling always runs, and it is not free - TODO

`is_profile` in `core/log.sh` is hardcoded to `return 0` and carries a comment
saying it does not belong there. So the profiling branch in `_bashy_run_plugins`
runs unconditionally, and `measure` forks `date` twice and `bc` once per plugin.

At 70 plugins that is roughly 210 processes spent purely on measuring, on every
shell, whether or not anyone will ever look at `bashy_assoc_diff`.

Make it a real setting that defaults to off, and compute the elapsed time with
bash arithmetic on `EPOCHREALTIME` instead of forking `date` and `bc`.

## 3. The installer documentation was lost - TODO

`README.md` was reverted at some point and the "writing an installer" section went
with it, so nothing user facing documents the helpers that round one added:
`bashy_install_check`, `bashy_github_release`, `bashy_github_version`,
`bashy_github_asset`, `bashy_download`, `bashy_verify_sha256`,
`bashy_install_extract`, `bashy_uninstall_binary`, `bashy_uninstall_directory`.

The "core module load order" section documenting `bashy_core_order` is gone too.

`CLAUDE.md` still summarises both, but that file is guidance for an assistant, not
documentation for a person writing a plugin. Restore both README sections.

## 4. Plugins piping a remote script into a shell - PARTLY DONE

Carried over from round one.

The two that piped into a **root** shell are done. `_install_azurecli_deb` now does
by hand what Microsoft's script does - add their signing key, add their apt
repository, `apt-get install azure-cli` - so nothing fetched over the network is
executed as root, and afterwards apt owns the package, including signature checking
and updates. This is not a fragile reimplementation: the upstream script only ever
did those three things, and it is apt that does the real work.

The keyring written is byte identical to Microsoft's published key, fingerprint
`BC528686B50D79E339D3721CEB3E94ADBE1229CF`, "Microsoft (Release signing)". The dist
fallback matches upstream too: an Ubuntu release with no repository of its own falls
back to jammy, which is what this machine (resolute) needs.

`_install_azurecli_standalone` has no packaged equivalent, so it now downloads the
script through the cache and runs that file, rather than piping it into root
unseen. There is at least something on disk to inspect.

Still piping, all into a **non root** shell:

- `ai_claude.sh`, `ai_copilot.sh`, `rust.sh`, `google_cloud_sdk.sh`

To be clear about what this is and is not: every one of these is the install method
the vendor documents. `plugins/azurecli.sh` even links Microsoft's install page and
marks the deb function "recommended", which is Microsoft's own recommendation.
Following upstream's instructions is the correct default, and these are not
mistakes.

The only thing `curl | sh` costs is a point of inspection - the bytes go from the
network into an interpreter with no file in between that could be checksummed or
read first. That matters more when the interpreter is root, which is the azurecli
pair.

But the fix has a real cost of its own. Vendoring install steps means this repo now
owns them, and they rot silently when upstream changes - exactly the failure mode
that made `_install_nvim_latest_tar` download a 404 for however long. Starship was
worth converting because it ships one self contained binary and a published sha256.
These do not, and a hand maintained reimplementation of the gcloud or rustup
bootstrap would be worse than the thing it replaced.

Leave these alone unless a vendor starts publishing a verifiable artifact. If
anything is done here, the cheapest version is to fetch the script to a file, then
run that file, so there is at least something on disk to look at afterwards.

## 5. The install location is hardcoded in 19 plugins - TODO

`${HOME}/install/binaries` appears literally in 19 plugins, and
`bashy_uninstall_binary` defaults to it as well. Nothing lets a user put binaries
somewhere else, and nothing documents that the directory is expected to exist -
`_install_bazel` and friends will simply fail if it does not.

Introduce `BASHY_INSTALL_DIR`, defaulting to the current path, have the core
helpers create it when missing, and move the plugins onto it.

## 6. Completion boilerplate is copy pasted - TODO

Sixteen plugins repeat some variant of

	source <(tool completion bash)

with slightly different error handling, some checking the result and some not.
Alongside item 1 this is the obvious place for one `bashy_completion` helper: it
would fix the caching, the error handling and the duplication in one move.

## 7. Test coverage of the runtime path - TODO

Round one covered the installer helpers well. The code that runs on every shell is
still untested: `_bashy_read_plugins`, `_bashy_load_plugins`, `_bashy_run_plugins`
and the enable/disable/order logic driven by `bashy.list`, including the `-plugin`
syntax for disabling.

That is the code most likely to break a user's shell, and it currently has no test
at all.

## 8. Smaller items - TODO

- `is_profile` and `is_step` live in `core/log.sh` with a comment saying they do not
  belong there. Move them.
- `core/version.sh` is generated and holds only `BASHY_VERSION_STR`, but nothing
  checks it. A deployed `~/.bashy` that has drifted from the repo is invisible;
  `bashy_status_core` could report it.
- `README.md` says to install by cloning straight into `~/.bashy`, but
  `scripts/install_in_home.bash` rsyncs from a working copy using `.includes`. Two
  different install stories, only one of them documented.
