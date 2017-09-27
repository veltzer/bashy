#!/bin/bash -eu

source core/source.bashinc
source_relative ../core/assert.bashinc
source_relative ../core/assoc.bashinc

assoc_create conf
assoc_config_read conf "tests/test.conf"
assoc_len conf len
assertEqual "$len" 2
assoc_get conf a "a"
assertEqual "$a" "a_value"
assoc_get conf b "b"
assertEqual "$b" "b_value"
