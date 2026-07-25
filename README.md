## bashy

version: 0.0.94

description: bashy handles bash configuration for you

website: https://veltzer.github.io/bashy

## Build

![build](https://github.com/veltzer/bashy/workflows/build/badge.svg)


## Contact

chat with me at [![gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/veltzer/mark.veltzer)

Bashy is bash based system to enable you control of your bash with precision and elegance.
It is plugin based and allows for easy extension.

## Build status

![build](https://github.com/veltzer/bashy/workflows/build/badge.svg)

## Demo

![Demo](resources/session.gif)

## Installing Bashy

First clone the repository into your home directory:

```bash
git clone --branch master --depth 1 https://github.com/veltzer/bashy.git ~/.bashy && rm -rf ~/.bashy/.git
```

Then edit `~/.bashrc` and add the following line as the last line:

```bash
source ~/.bashy/bashy.sh
```

In my own setup this is the only line I have in my `~/.bashrc`

## Debugging Bashy

Just add this line before sourcing bashy:
```bash
set -o xtrace
```

To see all errors use:
```bash
bashy_errors
```

To get debug messages you can create a `~/.bashy.config` and put the following content into it:

```
readonly BASHY_DEBUG=0
```

## Working with Bashy

To check the status of the core of Bashy use:

```bash
bashy_status_core
```

To check the status of plugins of Bashy use:

```bash
bashy_status_plugins
```

To disable or enable a plugins or to change the order in which
they are applied just edit `~/.bashy.list`

```
# this file supports hash comments
by_host
meta
path_mine
-path_pycharm_add
pylogconf
```

To reread the plugins use:

```bash
bashy_load_plugins
```

To reinit Bashy when a new version is installed or pulled:

```bash
bashy_init
```

## Writing Bashy plugins

Bashy plugins may never fail a command (all commands need to return 0)

Bashy plugins need to set a variable passed by reference to either 0 or 1.

Here is the most basic plugin:

```bash
function _activate_hello_plugin() {
	local -n __var=$1
	# this means everything was ok
	__var=0
}
register _activate_hello_plugin
```

### Shell completions

Do not run a completion command directly at activation time. Every one of those is
a process spawn on every shell you open, and they added up to about a second here.
Use `bashy_completion` instead, which runs the command once and caches the result:

```bash
# instead of: source <(minikube completion bash)
bashy_completion minikube minikube completion bash
```

The first argument is the tool whose binary keys the cache, the rest is the command
to run. The cache lives under `${XDG_CACHE_HOME:-~/.cache}/bashy/completions` and is
keyed on the size and mtime of the tool, so upgrading the tool regenerates it by
itself. `bashy_completion_clean` drops the cache.

This is for completion output only. `zoxide init`, `starship init` and friends emit
shell setup that may embed per session state, so those keep running live.

### Writing an installer

Install functions are named `_install_<name>` and should never hardcode a version
number: always ask the project what its latest release is. The core modules provide
the pieces so that every plugin behaves and reports the same way.

```bash
function _install_hello() {
	local release_json
	bashy_github_release "someorg/hello" release_json || return
	latest_version=$(bashy_github_version "${release_json}")
	folder="${HOME}/install/binaries"
	executable="${folder}/hello"
	# an empty installed version means "not installed yet"
	installed_version=""
	if [ -x "${executable}" ]
	then
		installed_version=$("${executable}" --version 2>/dev/null)
	fi
	# prints one of the three standard lines and says whether there is work to do
	if bashy_install_check "hello" "${installed_version}" "${latest_version}"
	then
		return
	fi
	local download_file
	bashy_github_asset "${release_json}" "_linux_amd64\\.tar\\.gz$" download_file || return
	bashy_install_download "${download_file}"
	local tar
	bashy_download "${download_file}" tar || return
	# verify whenever the project publishes checksums
	local checksums
	bashy_github_asset "${release_json}" "checksums\\.txt$" checksums || return
	bashy_verify_sha256 "${tar}" "${checksums}" || return
	rm -f "${executable}"
	bashy_install_extract "${tar}" "${folder}" hello
}

function _uninstall_hello() {
	bashy_uninstall_binary "hello"
}
```

The helpers involved:

| function | purpose |
| --- | --- |
| `bashy_install_check <name> <installed> <latest>` | print the standard install/upgrade/up to date line, return 0 when there is nothing to do |
| `bashy_install_download <url>` | report the artifact about to be fetched |
| `bashy_github_release <owner/repo> [out]` | fetch the latest release json |
| `bashy_github_version <json> [prefix]` | tag name with the prefix (default `v`) stripped |
| `bashy_github_asset <json> <regex> [out]` | the single asset url matching a regex, fails on an ambiguous match |
| `bashy_download <url> [out]` | download through the cache, revalidating against the origin |
| `bashy_verify_sha256 <file> <url or digest>` | check a download against a published sha256 |
| `bashy_install_extract <archive> <folder> [members...]` | unpack and stamp with the install time rather than the archive mtime |
| `bashy_uninstall_binary <name> [path]` | remove a single binary from `~/install/binaries` |
| `bashy_uninstall_directory <name> <dir...>` | remove the directory tree(s) a plugin installed |

Downloads are cached under `${XDG_CACHE_HOME:-~/.cache}/bashy/downloads`, overridable
with `BASHY_DOWNLOAD_CACHE`. Cached files are revalidated with the origin, so a
rolling `latest` asset that keeps one filename forever is still refetched when it
changes upstream. Use `bashy_download_clean` to drop the cache.

Never pipe a remote script into a shell when the project ships a release asset that
can be downloaded and verified instead.

## Core module load order

The modules in `core` are loaded in the order listed by `bashy_core_order` in
`bashy.sh`, not alphabetically. The list runs from the standalone modules to the
ones built on top of them, so a module may call into anything loaded before it and
does not have to source its own dependencies.

When adding a core module, put its name in that list at a point where everything it
uses is already loaded. A module left out of the list is still loaded, after all the
named ones.

## Profiling startup

Plugin activation is not timed unless you ask for it. To see where shell startup
time goes, put this in `~/.bashy.config`:

```bash
readonly BASHY_PROFILE=0
```

then open a shell and run `bashy_status_plugins`.

## Config files

You can activate various plgins via the `~/.bashy.config` file.

Here is an example:
```bash
readonly ENCFS_ENABLED=true
readonly ENCFS_FOLDER_CLEAR="${HOME}/insync.real"
readonly ENCFS_FOLDER_ENCRYPTED="${HOME}/insync/encrypted"
readonly ENCFS_PASSWORD=XXXXXXXX
readonly PROXY_ENABLED=false
```

This is a bash file and so you can overwrite values by using conditionals so:
```bash
if [ "$HOSTNAME" = "ion" ]
then
	readonly PROXY_ENABLED=true
	readonly PROXY_HTTP="http://proxy.corp.com:8080"
	readonly PROXY_HTTPS="http://proxy.corp.com:8080"
	readonly PROXY_NO="localhost,.corp.com"
fi
```

## Similar projects

* https://github.com/Bash-it/bash-it
* https://github.com/ohmyzsh/ohmyzsh
* https://github.com/ohmybash/oh-my-bash
* https://github.com/nojhan/liquidprompt
* https://github.com/daniruiz/dotfiles
* https://github.com/Gkiokan/.pimp-my-bash
* https://github.com/brujoand/sbp

## Articles

* https://www.freecodecamp.org/news/jazz-up-your-bash-terminal-a-step-by-step-guide-with-pictures-80267554cb22/
* https://medium.com/@mandymadethis/pimp-out-your-command-line-b317cf42e953
* https://www.maketecheasier.com/customise-bash-prompt-linux/
* https://www.computerworld.com/article/2833199/3-ways-to-pimp-your-bash-console.html

Mark Veltzer, Copyright © 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024, 2025, 2026
