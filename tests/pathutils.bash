source core/pathutils.bash

function testRemove() {
	local P="/usr/games:/usr/bin:/bin"
	local R="/usr/games"
	pathutils_remove P $R
	assertEquals "$P" "/usr/bin:/bin"
}

function testAddHead() {
	local P="/usr/games:/usr/bin:/bin"
	local R="/usr/games"
	pathutils_add_head R "/bin"
	assertEquals "$R" "/bin:/usr/games"
}

function testReduce() {
	local P="/usr/bin/games:/usr/bin:/bin:/usr/bin/games"
	pathutils_reduce P
	assertEquals "$P" "/usr/bin/games:/usr/bin:/bin"
}

function testPATH() {
	local before_path=$PATH
	pathutils_reduce PATH
	pathutils_add_head PATH "/fubar"
	assertEquals "/fubar:$before_path" "$PATH"
}
