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

Several upstreams already publish what is needed: lazygit and gh ship a
`checksums.txt`, helm ships a `.sha256`, hugo ships checksums. A small
`bashy_verify_sha256` helper in core, used wherever a checksum is published, closes
this cheaply.

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

All extraction sites now go through `bashy_install_extract`, which stamps what it
unpacked with the install time. Covered: gh, terraform, packer, hugo, helm, spark,
eksctl, kurtosis, oc, go, lazygit, phantomjs, azurecli, gradle, awscli.

## 5. Test coverage - DONE

`tests/install.sh` and `tests/download.sh` added, taking the suite from 18 to 36
tests. They cover the reporting helpers, asset selection, checksum verification and
the cache revalidation logic, and they run without network access.

The cache test was checked against a deliberately reintroduced item 1 bug and fails
when it comes back.

Still untested: `check.sh`, `errexit.sh`, `hooks.sh`.

## 6. Uninstall coverage - DONE

`bashy_uninstall_binary` added, plus `_uninstall_*` functions for the single binary
plugins that lacked one: bazel, eksctl, gh, helm, kurtosis, lazygit, nvim, packer,
starship, terraform.

Plugins installing through a package manager or into a directory tree still have no
uninstaller.

## 7. Smaller items - DONE

- `plugins/awscli.sh` now downloads through the cache and unpacks into a `mktemp`
  directory instead of predictable `/tmp` paths.
- The `curl | tar` pipelines in eksctl, oc and go were replaced with a guarded
  `bashy_download` followed by `bashy_install_extract`, so a failed download can no
  longer leave a partial extract.
- `README.md` gained a "writing an installer" section documenting every helper and
  the download cache.
