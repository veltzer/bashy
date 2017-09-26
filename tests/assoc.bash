#!/bin/bash -eu

source core/assert.bashinc
source core/null.bashinc
source core/assoc.bashinc

assoc_create conf
assoc_config_read conf "tests/test.conf"
assoc_len conf len
assertEqual "$len" 2
assoc_get conf a "a"
assertEqual "$a" "a_value"
assoc_get conf b "b"
assertEqual "$b" "b_value"
