# bashy

Bashy is bash baset system to enable you to control your shell with precision and elegance.
It is plugin based and allow for easy extension.

## Installng bashy

First clone the repository into your home directory:

```bash
git clone git@github.com:veltzer/bashy.git ~/.bashy
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

	https://github.com/Bash-it/bash-it


	Mark Veltzer <mark.veltzer@gmail.com>
