source core/python.bash

function testPythonVersion() {
	a=
	python_version_short a "$(command -v python3.11)"
	assertEquals "$a" 3.11
}
