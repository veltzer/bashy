# bashy improvement plan, round two

The first round (`doc/plan_done.md`) was all about the installer path. That is in
good shape now, so this round looks at what actually runs on every shell you open,
plus the things that got lost or left behind along the way.

Ordered by what is worth doing first. Item 4 is included for completeness but is
probably not worth acting on.

Status legend: `DONE`, `TODO`.

## 1. Shell startup takes three seconds - DONE

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

`core/completion.sh` added. `bashy_completion <tool> <command...>` runs the
completion command once, caches the output, and sources the cache afterwards. The
cache is keyed on the size and mtime of the tool's binary, so upgrading the tool
regenerates it. Fifteen plugins now use it.

The stamp uses `stat %.Y`, nanoseconds, not `%Y`. Whole seconds turned out to be too
coarse: a tool replaced within the same second as the previous stamp kept serving
the old completion, which a test caught.

Two other things came out of the profiling:

- `plugins/ai_claude.sh` and `plugins/ai_agy.sh` each called `pass show` twice, once
  to test and once to read. Each call is a gpg decryption costing about 35 ms. Now
  one call, captured and tested.
- `plugins/python.sh` was running `python -m keyring --print-completion`, the single
  most expensive plugin at 156 ms. Cached too.

`eval "$(zoxide init bash)"`, `starship init`, `pyenv init` and `thefuck --alias`
are deliberately **not** cached. That output is shell setup rather than a
completion and can legitimately embed per session state, and none of those tools
are installed here to verify against.

Measured, same machine, same method:

| | before | after |
| --- | --- | --- |
| interactive shell | 2.95 s | **2.21 s** |
| plugin activations, summed | 1.44 s | 0.97 s |
| execve per startup | 236 | 214 |

A 25% cut on its own. The rest of the cost turned out not to be in the plugins at
all but in the profiling wrapped around them, which is item 2. Together the two
items take startup from **2.95 s to 1.01 s**.

## 2. Profiling always runs, and it is not free - DONE

`is_profile` in `core/log.sh` is hardcoded to `return 0` and carries a comment
saying it does not belong there. So the profiling branch in `_bashy_run_plugins`
runs unconditionally, and `measure` forks `date` twice and `bc` once per plugin.

At 70 plugins that is roughly 210 processes spent purely on measuring, on every
shell, whether or not anyone will ever look at `bashy_assoc_diff`.

Measured directly after finishing item 1: those forks cost **about 995 ms**. The
whole startup is now 2.21 s and the plugins themselves only account for 0.97 s of
it, so profiling is close to half of what is left. This is now the single biggest
remaining item, bigger than everything item 1 recovered.

Both done. `core/profile.sh` added, holding `is_profile` and `is_step`, which were
in `core/log.sh` with a comment saying they did not belong there. Profiling is now
off unless `~/.bashy.config` sets `readonly BASHY_PROFILE=0`, and `measure` times
with `EPOCHREALTIME` string arithmetic instead of forking `date` twice and `bc`.

| | before | after |
| --- | --- | --- |
| interactive shell | 2.21 s | **1.01 s** |

Together with item 1 that is **2.95 s down to 1.01 s**, a 66% cut. `test_measure`
still passes against the new implementation, and turning profiling back on still
produces real numbers.

## 3. The installer documentation was lost - DONE

`README.md` was reverted at some point and the "writing an installer" section went
with it, so nothing user facing documents the helpers that round one added:
`bashy_install_check`, `bashy_github_release`, `bashy_github_version`,
`bashy_github_asset`, `bashy_download`, `bashy_verify_sha256`,
`bashy_install_extract`, `bashy_uninstall_binary`, `bashy_uninstall_directory`.

The "core module load order" section documenting `bashy_core_order` is gone too.

`CLAUDE.md` still summarises both, but that file is guidance for an assistant, not
documentation for a person writing a plugin.

Restored, and extended. `README.md` now has "writing an installer" with a worked
example and the full helper table, "core module load order", a new "shell
completions" section covering `bashy_completion`, and "profiling startup"
documenting `BASHY_PROFILE`. The worked example was run verbatim against a real
project to confirm it still works.

The first attempt at this was wasted: the sections were written into `README.md`,
which is generated by `pydmt build` from `templates/README.md.mako` and
`snipplets/main.md.mako`. They vanished at the next build. They now live in the
snipplet, with shell examples wrapped in `<%text>` so mako does not try to expand
`${HOME}` and friends. Noted in `CLAUDE.md` so it does not happen again.

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

## 5. The install location is hardcoded in 19 plugins - DONE

`${HOME}/install/binaries` appears literally in 19 plugins, and
`bashy_uninstall_binary` defaults to it as well. Nothing lets a user put binaries
somewhere else, and nothing documents that the directory is expected to exist -
`_install_bazel` and friends will simply fail if it does not.

`BASHY_INSTALL_DIR` added to `core/install.sh`, defaulting to the old path so
nothing moves unless asked. `bashy_install_dir` echoes it and creates it when
missing, which is what the plugins now call, so a fresh machine no longer fails
obscurely. All 19 plugins and `bashy_uninstall_binary` moved onto it.

Verified by installing into a directory that did not exist yet: it was created, the
binary landed there, and the uninstaller found it again.

## 6. Completion boilerplate is copy pasted - DONE

Sixteen plugins repeat some variant of

	source <(tool completion bash)

with slightly different error handling, some checking the result and some not.
Done as part of item 1. `bashy_completion` in `core/completion.sh` is now the one
place that runs a completion command, so the caching, the error handling and the
duplication were all fixed in one move. Fifteen plugins use it.

## 7. Test coverage of the runtime path - DONE

Round one covered the installer helpers well. The code that runs on every shell is
still untested: `_bashy_read_plugins`, `_bashy_load_plugins`, `_bashy_run_plugins`
and the enable/disable/order logic driven by `bashy.list`, including the `-plugin`
syntax for disabling.

`tests/runtime.sh` added, eleven tests, taking the suite to 73. It pulls
`_bashy_read_plugins_filename` out of `bashy.sh` and drives it directly, covering
order, the `-plugin` disable syntax, comments, blank lines, later entries winning
over earlier ones, and an empty file. One test walks the shipped `bashy.list` and
checks every named plugin actually has a file.

That immediately found a real bug: a list whose last line had **no trailing
newline** silently lost its last plugin, because `read` returns false on an
unterminated final line. A hand edited `~/.bashy.list` would hit this. Fixed by
appending a newline to the stream.

## 8. Smaller items - DONE

- `is_profile` and `is_step` moved out of `core/log.sh` into the new
  `core/profile.sh`, as part of item 2.
- `bashy_check_deployment` added. It compares the running `~/.bashy` against a
  checkout and lists what differs, so a drifted deployment is no longer invisible.
- `README.md` now documents both install routes: cloning straight into `~/.bashy`
  for users, and `scripts/install_in_home.bash` for working from a checkout.
