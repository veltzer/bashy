#!/bin/bash -eu

# a test suite for assoc.bashinc

source ../core/assoc.bashinc

assoc_create conf
assoc_config_read conf $HOME/.myenv
assoc_print conf
assoc_get conf git_activate git_activate
echo $git_activate
