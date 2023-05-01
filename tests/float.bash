source core/float.bash

function testGt() {
	if floatGt 3.14 3.22
	then
		assertFail
	fi
}

function testAdd() {
	f=
	floatAdd f 0.2 1.4
	assertEquals "${f}" 1.6
}

function testDiv() {
	f=
	floatDiv f 1.4 0.2
	assertLt "${f}" 7.1
	assertGt "${f}" 6.9
}
