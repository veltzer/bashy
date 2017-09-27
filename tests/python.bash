#!/bin/bash -eu

source core/source.bashinc
source_relative ../core/assert.bashinc
source_relative ../core/python.bashinc

python_version_short a "/usr/bin/python2.7"
assertEqual "$a" 2.7
