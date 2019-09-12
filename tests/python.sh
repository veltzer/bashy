source core/python.bashinc

function testPythonVersion() {
	python_version_short a "/usr/bin/python2.7"
	assertEquals "$a" 2.7
}

source shunit2
