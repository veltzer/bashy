source src/core/assert.sh
source src/core/errexit.sh

function testErrexitSaveReportsOff() {
	set +e
	local e=""
	errexit_save_and_start e
	_bashy_assert_equal "${e}" "off"
	# and it must actually have turned errexit on
	if [[ $- != *e* ]]
	then
		_bashy_assert_fail
	fi
	errexit_restore "${e}"
}

function testErrexitSaveReportsOn() {
	set -e
	local e=""
	errexit_save_and_start e
	_bashy_assert_equal "${e}" "on"
	errexit_restore "${e}"
	set +e
}

function testErrexitRestoreToOff() {
	set +e
	local e=""
	errexit_save_and_start e
	errexit_restore "${e}"
	# it was off before, so it has to be off again
	if [[ $- == *e* ]]
	then
		set +e
		_bashy_assert_fail
	fi
}

function testErrexitRestoreToOn() {
	set -e
	local e=""
	errexit_save_and_start e
	errexit_restore "${e}"
	local restored="off"
	if [[ $- == *e* ]]
	then
		restored="on"
	fi
	set +e
	_bashy_assert_equal "${restored}" "on"
}

function testErrexitSaveEchoesWhenNoOutVar() {
	set +e
	local out
	out=$(errexit_save_and_start)
	_bashy_assert_equal "${out}" "off"
	set +e
}

function testErrexitMisspelledAliasStillWorks() {
	# the function used to be named errexist_save_and_start
	set +e
	local e=""
	errexist_save_and_start e
	_bashy_assert_equal "${e}" "off"
	errexit_restore "${e}"
	set +e
}
