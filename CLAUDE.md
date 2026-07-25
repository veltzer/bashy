# Working on bashy

## Never delete plugins

Do not delete a plugin from `plugins/` because it is unused, disabled in
`bashy.list`, or its upstream project looks dead. bashy is a collection meant for
other people's setups, not only this machine - a plugin that works but is not needed
here may be exactly what someone else needs.

Plugins are free at runtime anyway: the `check*` helpers in `core/check.sh`
(`checkInPath`, `checkExecutableFile`, ...) make an inapplicable plugin a silent
no-op.

To opt out of a plugin locally, comment its line out in `bashy.list`. Leave the file
in place. "Unused here" and "upstream is archived" are not reasons to prune -
`plugins/phantomjs.sh` is pinned to a 2018 release and still stays.

Fix and improve plugins. Treat the set as additive.

## Never hardcode a version

An installer must ask the project what its latest release is, never carry a version
literal. Version numbers embedded in a download url count too, and so do pinned
distro codenames in an asset name.

The exceptions are deliberate and carry a comment saying so: `_install_zoom_6` pins
a version because it exists to downgrade, and `plugins/phantomjs.sh` pins one
because the project was archived with no releases to query.

## Core module load order

`core/*.sh` is loaded in the order given by `bashy_core_order` in `bashy.sh`, not
alphabetically. The list runs from the standalone modules to the ones built on top
of them, so a module may call into anything listed before it.

Modules must not source each other. When adding a core module, put its name in that
list at a point where everything it uses is already loaded. A module missing from
the list is still loaded, after the named ones.

Tests source modules directly, so a test has to list the dependencies itself, in the
same order.

## Writing an installer

Use the core helpers rather than hand rolling. They keep every plugin reporting the
same way and put the fixes in one place. See the "writing an installer" section of
`README.md` for a worked example and the full table.

- `bashy_install_check <name> <installed> <latest>` - prints the standard
  install/upgrade/up to date line, returns 0 when there is nothing to do
- `bashy_github_release` / `bashy_github_version` / `bashy_github_asset` - the
  latest release json, its version, and the one asset matching a regex
- `bashy_download <url> [out]` - download through the revalidating cache
- `bashy_verify_sha256 <file> <url or digest>` - check against a published sha256,
  whenever the project publishes one
- `bashy_install_extract <archive> <folder> [members...]` - unpack and stamp with
  the install time, because tar and unzip both restore the archive's own mtime
- `bashy_uninstall_binary` / `bashy_uninstall_directory` - for the `_uninstall_*`
  counterpart

Never pipe a remote script into a shell when the project ships a release asset that
can be downloaded and verified instead.

## Before saying it is done

Run `make`. It runs shellcheck over every shell file and then `test_all.sh`.

Do not claim an item is complete without checking the code. Grep for what the claim
asserts rather than trusting a summary written earlier in the session.
