source core/python.bash

function test_python_version() {
	a=
	python_version_short a "$(command -v python3)"
	ubuntu_ver=$(lsb_release -r -s)
	if [ "${ubuntu_ver}" = "23.04" ]
	then
		assert_equal "${a}" 3.11
	fi
	if [ "${ubuntu_ver}" = "22.10" ]
	then
		assert_equal "${a}" 3.10
	fi
}
