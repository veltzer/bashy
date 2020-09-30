source core/assoc.bashinc

function testAssoc() {
	assoc_create conf
	assoc_config_read conf "data/test.conf"
	assoc_len conf len
	assertEquals "$len" 2
	a=
	assoc_get conf a "a"
	assertEquals "$a" "a_value"
	b=
	assoc_get conf b "b"
	assertEquals "$b" "b_value"
}
