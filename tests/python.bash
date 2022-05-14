source core/python.bash

function testPythonVersion() {
	a=
	python_version_short a "$(which python3.10)"
	assertEquals "$a" 3.10
}
