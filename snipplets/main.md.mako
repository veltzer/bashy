Bashy is bash based system to enable you control of your bash with precision and elegance.
It is plugin based and allows for easy extension.

<%text>## Build status</%text>

![build](https://github.com/veltzer/bashy/workflows/build/badge.svg)

<%text>## Demo</%text>

![Demo](resources/session.gif)

<%text>## Installing Bashy</%text>

First clone the repository into your home directory:

```bash
git clone --branch master --depth 1 https://github.com/veltzer/bashy.git ~/.bashy && rm -rf ~/.bashy/.git
```

Then edit `~/.bashrc` and add the following line as the last line:

```bash
source ~/.bashy/bashy.sh
```

In my own setup this is the only line I have in my `~/.bashrc`

<%text>## Debugging Bashy</%text>

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

<%text>## Working with Bashy</%text>

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

<%text>## Writing Bashy plugins</%text>

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

<%text>## Config files</%text>

You can activate various plgins via the `~/.bashy.config` file.

Here is an example:
```bash
readonly ENCFS_ENABLED=true
readonly ENCFS_FOLDER_CLEAR="${"${HOME}"}/insync.real"
readonly ENCFS_FOLDER_ENCRYPTED="${"${HOME}"}/insync/encrypted"
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

<%text>## Similar projects</%text>

* https://github.com/Bash-it/bash-it
* https://github.com/ohmyzsh/ohmyzsh
* https://github.com/ohmybash/oh-my-bash
* https://github.com/nojhan/liquidprompt
* https://github.com/daniruiz/dotfiles
* https://github.com/Gkiokan/.pimp-my-bash
* https://github.com/brujoand/sbp

<%text>## Articles</%text>

* https://www.freecodecamp.org/news/jazz-up-your-bash-terminal-a-step-by-step-guide-with-pictures-80267554cb22/
* https://medium.com/@mandymadethis/pimp-out-your-command-line-b317cf42e953
* https://www.maketecheasier.com/customise-bash-prompt-linux/
* https://www.computerworld.com/article/2833199/3-ways-to-pimp-your-bash-console.html
