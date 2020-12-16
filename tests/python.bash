source core/python.bash

function testPythonVersion() {
	a=
	python_version_short a "/usr/bin/python2.7"
	assertEquals "$a" 2.7
}
