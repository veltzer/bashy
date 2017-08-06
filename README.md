# bashy

Making bash great again

## Installng bashy

First clone the repository into your home directory:

	git clone git@github.com:veltzer/bashy.git ~/.bashy

Then edit ~/.bashrc and add:

	source ~/.bashy/bashy.sh

In my own setup this is the only line in my ~/.bashrc

## Working with bashy

To check the status of bashy use:

	bashy_status

To disable or enable a plugins or to change the order in which
they are applied just copy ~/.bashy/bashy.list
to ~/.bashy.list and edit as you like.

To install prepreqs to bashy enabled plugins use:

	bashy_install

To reread the plugins use:

	bashy_load_plugins

To reinit bashy when a new version is installed or pulled:

	bashy_init

## Writing bashy plugins

bashy plugins may never fail a command (all commands need to return 0)

bashy plugins need to set a variable 'result' to either 0 or 1.

## Similar projects

	https://github.com/Bash-it/bash-it


	Mark Veltzer <mark.veltzer@gmail.com>
