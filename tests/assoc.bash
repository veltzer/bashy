source core/assoc.bash

function testAssoc() {
	assoc_new conf
	assoc_config_read conf "data/test.conf"
	# assoc_print conf
	local len=
	assoc_len conf len
	assertEquals "$len" 2
	a=
	assoc_get conf a "a"
	assertEquals "$a" "a_value"
	b=
	assoc_get conf b "b"
	assertEquals "$b" "b_value"
	c=
	assoc_get conf c "c"
	if ! null_var_is_null c
	then
		assertFail
	fi
}
