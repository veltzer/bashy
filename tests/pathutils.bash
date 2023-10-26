source core/pathutils.bash

function testRemove() {
	local P="/usr/games:/usr/bin:/bin"
	local R="/usr/games"
	pathutils_remove P "${R}"
	_bashy_assert_equal "${P}" "/usr/bin:/bin"
}

function testAddHead() {
	local P="/usr/games:/usr/bin:/bin"
	local R="/usr/games"
	pathutils_add_head R "/bin"
	_bashy_assert_equal "${R}" "/bin:/usr/games"
}

function testReduce() {
	local P="/usr/bin/games:/usr/bin:/bin:/usr/bin/games"
	pathutils_reduce P
	_bashy_assert_equal "${P}" "/usr/bin/games:/usr/bin:/bin"
}

function testPATH() {
	pathutils_reduce PATH
	local before_path="${PATH}"
	pathutils_add_head PATH "/fubar"
	_bashy_assert_equal "/fubar:${before_path}" "${PATH}"
}
