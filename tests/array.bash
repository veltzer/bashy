source core/array.bash

function testSetLen() {
	array_new my_array
	array_set my_array 2 4
	len=
	array_length my_array len
	_bashy_assert_equal "${len}" 1
}

function testSetPop() {
	array_new arr2
	array_set arr2 0 a
	array_set arr2 1 b
	array_set arr2 2 c
	d=5
	array_pop arr2 d
	_bashy_assert_equal "${d}" c
	array_pop arr2 d
	_bashy_assert_equal "${d}" b
	array_pop arr2 d
	_bashy_assert_equal "${d}" a
}

function testPushPop() {
	array_new arr
	array_push arr a
	array_push arr b
	array_push arr c
	elem=5
	array_pop arr elem
	_bashy_assert_equal "${elem}" c
	array_pop arr elem
	_bashy_assert_equal "${elem}" b
	array_pop arr elem
	_bashy_assert_equal "${elem}" a
}

function testRemove() {
	array_new arr
	array_push arr a
	array_push arr b
	array_push arr c
	array_remove arr b
	array_pop arr elem
	_bashy_assert_equal "${elem}" c
	array_pop arr elem
	_bashy_assert_equal "${elem}" a
}

function testFind() {
	array_new arr
	array_push arr a
	array_push arr b
	array_push arr c
	location=0
	array_find arr b location
	_bashy_assert_equal "${location}" 1
}
