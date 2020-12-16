source core/float.bash

function testGt() {
	if floatGt 3.14 3.22
	then
		assertFail
	fi
}

function testAdd() {
	d=
	floatAdd d 0.2 1.4
	assertEquals "$d" 1.6
}

function testDiv() {
	d=
	floatDiv d 1.4 0.2
	assertLt "$d" 7.1
	assertGt "$d" 6.9
}
