# Bashy

Bashy is bash based system to enable you control of your bash with precision and elegance.
It is plugin based and allows for easy extension.

## Build status

![build](https://github.com/veltzer/bashy/workflows/build/badge.svg)

## Installng Bashy

First clone the repository into your home directory:

```bash
$ git clone --branch master --depth 1 git@github.com:veltzer/bashy.git ~/.bashy && rm -rf ~/.bashy/.git
```

Then edit `~/.bashrc` and add the following line as the last line:

```bash
source ~/.bashy/bashy.bash
```

In my own setup this is the only line I have in my `~/.bashrc`

## Working with Bashy

To check the status of the core of Bashy use:

```bash
$ bashy_status_core
```

To check the status of plugins of Bashy use:

```bash
$ bashy_status_plugins
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
$ bashy_load_plugins
```

To reinit Bashy when a new version is installed or pulled:

```bash
$ bashy_init
```

## Writing Bashy plugins

Bashy plugins may never fail a command (all commands need to return 0)

Bashy plugins need to set a variable passed by reference to either 0 or 1.

Here is the most basic plugin:

```bash
function configure_hello_plugin() {
	local -n __var=$1
	# this means everything was ok
	__var=0
}
register configure_hello_plugin
```

## Config files

You can configure various plgins via the `~/.bashy.config` file.

Here is an example:
```bash
ENCFS_ENABLED=true
ENCFS_FOLDER_CLEAR="$HOME/insync.real"
ENCFS_FOLDER_ENCRYPTED="$HOME/insync/encrypted"
ENCFS_PASSWORD=XXXXXXXX
PROXY_ENABLED=false
```

This is a bash file and so you can overwrite values by using bash so:
```bash
if [ "$HOSTNAME" = "ion" ]
then
	PROXY_ENABLED=true
	PROXY_HTTP="http://gproxy.corp.amdocs.com:8080"
	PROXY_HTTPS="http://gproxy.corp.amdocs.com:8080"
	PROXY_NO="localhost,.corp.amdocs.com"
fi
```

## Similar projects

* https://github.com/Bash-it/bash-it
* https://github.com/ohmyzsh/ohmyzsh
* https://github.com/ohmybash/oh-my-bash
* https://github.com/nojhan/liquidprompt
* https://github.com/daniruiz/dotfiles
* https://github.com/Gkiokan/.pimp-my-bash

## Articles

* https://www.freecodecamp.org/news/jazz-up-your-bash-terminal-a-step-by-step-guide-with-pictures-80267554cb22/
* https://medium.com/@mandymadethis/pimp-out-your-command-line-b317cf42e953
* https://www.maketecheasier.com/customise-bash-prompt-linux/
* https://www.computerworld.com/article/2833199/3-ways-to-pimp-your-bash-console.html

Mark Veltzer <mark.veltzer@gmail.com>
