source core/array.bash

function testSetLen() {
	array_new my_array
	array_set my_array 2 4
	len=
	array_length my_array len
	assertEquals "$len" 1
}

function testSetPop() {
	array_new arr2
	array_set arr2 0 a
	array_set arr2 1 b
	array_set arr2 2 c
	d=5
	array_pop arr2 d
	assertEquals "$d" c
	array_pop arr2 d
	assertEquals "$d" b
	array_pop arr2 d
	assertEquals "$d" a
}

function testPushPop() {
	array_new arr
	array_push arr a
	array_push arr b
	array_push arr c
	elem=5
	array_pop arr elem
	assertEquals "$elem" c
	array_pop arr elem
	assertEquals "$elem" b
	array_pop arr elem
	assertEquals "$elem" a
}

function testRemove() {
	array_new arr
	array_push arr a
	array_push arr b
	array_push arr c
	array_remove arr b
	array_pop arr elem
	assertEquals "$elem" c
	array_pop arr elem
	assertEquals "$elem" a
}

function testFind() {
	array_new arr
	array_push arr a
	array_push arr b
	array_push arr c
	location=0
	array_find arr b location
	assertEquals "$location" 1
}
