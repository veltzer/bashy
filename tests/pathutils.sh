source core/pathutils.bashinc

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

function testPATH() {
	before_path=$PATH
	pathutils_add_head PATH "/opt"
	assertEquals "/opt:$before_path" "$PATH"
}
