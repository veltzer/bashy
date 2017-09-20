#!/bin/bash -eu

source core/assert.bashinc
source core/python.bashinc

python_version_short a "/usr/bin/python2.7"
assertEqual "$a" 2.7
