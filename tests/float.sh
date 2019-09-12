source core/float.bashinc

function testGt() {
	if floatGt 3.14 3.22
	then
		assertFail
	fi
}

function testAdd() {
	floatAdd d 0.2 1.4
	assertEquals $d 1.6
}

function testDiv() {
	floatDiv d 1.4 0.2
	assertLt $d 7.1
	assertGt $d 6.9
}
