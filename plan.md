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

## 3. Extract the remaining installer boilerplate - TODO

The message unification in `core/install.sh` worked; the same argument applies one
level up.

- 12 plugins repeat the same "GET releases/latest, jq .tag_name, strip v" dance.
- 28 sites repeat "extract into ~/install/binaries, chmod +x, fix the timestamp".

Two helpers would remove most of it:

- `bashy_github_latest_version <repo>` - the tag_name dance in one place.
- `bashy_install_binary <archive> <member> <dest>` - extract, chmod, stamp mtime.

This matters mainly because it makes item 4 automatic rather than per plugin.

## 4. Archive timestamps - TODO

`tar` and `unzip` restore the mtime stored inside the archive, so installed files
carry the upstream build date instead of the install date.

Fixed so far: gh, terraform, packer, hugo, helm, spark.

Still inheriting archive mtimes:

- tar: eksctl, kurtosis, oc, go, lazygit, phantomjs, azurecli
- unzip: gradle, awscli

Best folded into the helper from item 3 so it cannot regress.

## 5. Test coverage - TODO

18 tests pass but they cover 7 of 20 core modules. Untested: `download.sh`,
`check.sh`, `install.sh`, `errexit.sh`, `hooks.sh`.

Item 1 is exactly the kind of bug a `download.sh` test catches. The harness in
`test_all.sh` already exists and these are pure functions, so tests are cheap.

## 6. Uninstall coverage - TODO

67 install functions, 19 uninstall functions. Most plugins can install but not
remove, which is surprising for tools that scatter files through `~/install`.

## 7. Smaller items - TODO

- `plugins/awscli.sh` writes to a fixed `/tmp/awscli-bundle.zip` and unzips into
  `/tmp`. Predictable paths in a shared directory; use `bashy_download` or `mktemp`.
- `plugins/eksctl.sh` and `plugins/nvim.sh` pipe `curl | tar` with no failure guard
  on the pipeline, so a failed download can leave a partial extract.
- `README.md` does not document `bashy_download`, `bashy_install_check` or
  `BASHY_DOWNLOAD_CACHE`. Worth a short "writing a plugin" section.
