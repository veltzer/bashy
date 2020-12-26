# bashy

Bashy is bash based system to enable you control of your bash with precision and elegance.
It is plugin based and allows for easy extension.

## Build status

![build](https://github.com/veltzer/bashy/workflows/build/badge.svg)

## Installng bashy

First clone the repository into your home directory:

```bash
git clone --depth 1 git@github.com:veltzer/bashy.git ~/.bashy
```

Then edit ~/.bashrc and add the following line:

```bash
source ~/.bashy/bashy.bash
```

In my own setup this is the only line I have in my ~/.bashrc

## Working with bashy

To check the status of the core of bashy use:

```bash
bashy_status_core
```

To check the status of plugins of bashy use:

```bash
bashy_status_plugins
```

To disable or enable a plugins or to change the order in which
they are applied just edit ~/.bashy.list

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

To reinit bashy when a new version is installed or pulled:

```bash
bashy_init
```

## Writing bashy plugins

bashy plugins may never fail a command (all commands need to return 0)

bashy plugins need to set a variable passed by reference to either 0 or 1.

Here is the most basic plugin:

```bash
function configure_hello_bashy() {
	local -n __var=$1
	# this means everything was ok
	__var=0
}
register configure_hello_bashy
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
