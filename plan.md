# bashy improvement plan

Findings from an audit of the installer plugins and core modules.
Ordered by what is worth doing first.

Status legend: `DONE`, `TODO`.

## 1. Stale download cache for rolling release assets - DONE

`core/download.sh` keys the cache on the last path segment of the url only. That is
fine for `terraform_1.15.8_linux_amd64.zip`, where the version is part of the name,
but buck2 downloads a rolling `latest` asset whose filename never changes:

	https://github.com/facebook/buck2/releases/download/latest/buck2-x86_64-unknown-linux-gnu.zst

Once that file is cached, `bashy_download` returns it forever without touching the
network, so a buck2 upgrade reinstalls the stale binary. The version check correctly
notices a new build, then the cache hands back the old one.

Fix: revalidate cached entries with the origin instead of trusting the filename.

## 2. Downloads are never verified - DONE

Every downloading installer writes straight to disk and `chmod +x`, with no checksum
or signature check anywhere in the tree. These binaries end up on `PATH`.

`bashy_verify_sha256` added to `core/download.sh`. It accepts a literal digest, a
`sha256sum` style checksums file listing many assets, or a file holding a bare digest
with no filename column, which covers every shape these projects publish.

Verified now: audacity, bazel, eksctl, gh, gradle, helm, hugo, kurtosis, lazygit,
minikube, oc, packer, starship, terraform.

Still unverified because the project publishes nothing to check against: buck2,
drawio, freetube, lens, nvim, spark, zoom. Not applicable: awscli, azurecli, code,
dotnet, k8s install through a vendor installer or a package manager.

`plugins/starship.sh` used to pipe the vendor `install.sh` straight into a shell,
running unverified code from the network. It now installs the release tarball
directly and checks it against the published `.sha256`, like every other plugin.

Six plugins still pipe a remote script into a shell:

- `ai_claude.sh`, `ai_copilot.sh`, `rust.sh`, `google_cloud_sdk.sh` - into `sh`/`bash`
- `azurecli.sh` (two functions) - into `sudo bash`, so the script runs as root

Starship was easy to convert because it ships one self contained binary per release.
These are bootstrap installers that lay down a whole toolchain and have no single
release asset to swap in, so closing them means either vendoring the install steps
or accepting the vendor script. The `sudo bash` pair is the most worrying of them.

## 3. Extract the remaining installer boilerplate - DONE

The message unification in `core/install.sh` worked; the same argument applies one
level up.

12 plugins repeated the same "GET releases/latest, jq .tag_name, strip v" dance and
28 sites repeated the extract into `~/install/binaries` step.

Added to `core/install.sh`:

- `bashy_github_release <owner/repo> [out]` - fetch the latest release json.
- `bashy_github_version <json> [prefix]` - the tag_name dance in one place.
- `bashy_github_asset <json> <regex> [out]` - the one asset matching a regex. This
  fails loudly on an ambiguous match, which is what the hugo bug was.
- `bashy_install_extract <archive> <folder> [members...]` - unpack and stamp, so
  item 4 is handled centrally rather than per plugin.

## 4. Archive timestamps - DONE

`tar` and `unzip` restore the mtime stored inside the archive, so installed files
carry the upstream build date instead of the install date.

Extraction goes through `bashy_install_extract`, which stamps what it unpacked with
the install time: terraform, packer, hugo, spark, eksctl, kurtosis, oc, go, lazygit,
phantomjs, azurecli, gradle, awscli, nvim.

`gh` and `helm` still call `tar` directly because they need `--transform` and
`--strip-components`, which the helper does not pass through. Both already use
`-m`, so the timestamps are right; only the call site differs.

## 5. Test coverage - DONE

`tests/install.sh` and `tests/download.sh` added, taking the suite from 18 to 36
tests. They cover the reporting helpers, asset selection, checksum verification and
the cache revalidation logic, and they run without network access.

The cache test was checked against a deliberately reintroduced item 1 bug and fails
when it comes back.

`tests/check.sh`, `tests/errexit.sh` and `tests/hooks.sh` added, taking the suite to
59 tests. Writing them turned up two real bugs, see below.

Untested but not worth it: `assert.sh` is the test framework itself, `version.sh` is
generated, and `color.sh`/`log.sh`/`misc.sh`/`null.sh`/`source.sh`/`git.sh` are thin
wrappers.

## 6. Uninstall coverage - DONE

`bashy_uninstall_binary` added, plus `_uninstall_*` for the single binary plugins
that lacked one: bazel, eksctl, gh, helm, kurtosis, lazygit, nvim, packer, starship,
terraform.

`bashy_uninstall_directory` added for the plugins that unpack a whole tree: fzf, go,
gradle, node, phantomjs, rust. gradle and phantomjs symlink `~/install/<name>` at a
versioned directory, so their uninstallers resolve the link and remove both.

Plugins that install through a package manager still have no uninstaller, which is
correct - removal there belongs to the package manager.

## 7. Smaller items - DONE

- `plugins/awscli.sh` now downloads through the cache and unpacks into a `mktemp`
  directory instead of predictable `/tmp` paths.
- The `curl | tar` pipelines in eksctl, oc, go and both nvim tar installers were
  replaced with a guarded `bashy_download` followed by `bashy_install_extract`, so a
  failed download can no longer leave a partial extract.
- Adding that guard immediately surfaced a dead url: neovim renamed its assets from
  `nvim-linux64` to `nvim-linux-x86_64`, so `_install_nvim_latest_tar` had been
  downloading a 404 and silently extracting nothing. Renamed throughout the plugin,
  including the `NVIM_PATH` used by the activation function.
- `_install_awscli_old` also unpacked through predictable `/tmp` paths; it now uses
  the cache and a `mktemp` directory like the main installer.
- `README.md` gained a "writing an installer" section documenting every helper and
  the download cache.

## 8. Bugs found while doing the above

Not planned work, but worth recording.

- `core/check.sh` - the success branches of `checkVariableDefined` and
  `checkDirectoryExists` assigned to `__var` rather than the `__var2` nameref bound
  to the caller's variable, so a successful check never reported its result. The
  other three functions in the file were already correct.
- `core/errexit.sh` - the function was named `errexist_save_and_start` while the
  documentation and `plugins/kurtosis.sh` both used `errexit_save_and_start`, so the
  call resolved to nothing. `kurtosis.sh` also wrote `local e=errexit_save_and_start`,
  assigning the name as a string rather than calling it, so `set -e` was never
  enabled and `errexit_restore` was handed a non numeric value. The implementation
  could not have worked either: `set -o errexit` turns errexit on rather than
  reporting the previous state, so the saved value was always the same. Rewritten to
  read `$-`, return the state through a named variable, and keep the old misspelling
  as an alias.
- `Makefile` - `check_all` referenced an undefined `ALL_BASH`, so shellcheck ran with
  no file arguments and printed its usage instead of checking anything. It is
  `SH_SRC` that holds the shell sources.
- `plugins/nvim.sh` - neovim renamed its release assets from `nvim-linux64` to
  `nvim-linux-x86_64`, so the tar installer had been fetching a 404 and silently
  extracting nothing.
- `core/download.sh` - the module calls `bashy_log` but never pulled in
  `core/log.sh`, so it only worked when something else happened to have loaded the
  logger first. Under `test_all.sh` nothing did, and the suite printed
  "bashy_log: command not found" on every cache decision. It now declares the
  dependency with `_bashy_source_relative log.sh`, the same way `core/assoc.sh`
  pulls in `null.sh`.
- `plugins/lazygit.sh` - upstream renamed assets from `_Linux_x86_64` to
  `_linux_x86_64`, so the asset filter matched nothing.
- `core/array.sh` - `_bashy_array_remove` built the filtered array correctly and
  then assigned it to an undefined `__array` instead of the `__array_remove`
  nameref, so it never removed anything. This was the SC2154 warning that `make`
  had been reporting. `tests/array.sh` had a `testRemove` that passed anyway
  because it only popped from the end; it now asserts on the length, and three
  more cases cover removing the last element, removing an absent value, and
  preserving elements containing spaces.
