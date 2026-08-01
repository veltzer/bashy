source src/core/assert.sh
source src/core/array.sh
source src/core/assoc.sh
source src/core/misc.sh
source src/core/hooks.sh

# hooks registers into these two globals, so each test starts from a clean pair
function _test_hooks_reset() {
	unset _bashy_array_function
	unset _bashy_assoc_function
	declare -g -a _bashy_array_function=()
	declare -g -A _bashy_assoc_function=()
}

function testRegisterCoreRecordsFunction() {
	_test_hooks_reset
	register_core "_activate_thing" "thing"
	_bashy_assert_equal "${#_bashy_array_function[@]}" 1
	_bashy_assert_equal "${_bashy_array_function[0]}" "_activate_thing"
	_bashy_assert_equal "${_bashy_assoc_function[_activate_thing]}" "thing"
}

function testRegisterCoreKeepsOrder() {
	_test_hooks_reset
	register_core "_activate_a" "a"
	register_core "_activate_b" "b"
	register_core "_activate_c" "c"
	_bashy_assert_equal "${#_bashy_array_function[@]}" 3
	# plugins run in registration order, so the array has to preserve it
	_bashy_assert_equal "${_bashy_array_function[0]}" "_activate_a"
	_bashy_assert_equal "${_bashy_array_function[2]}" "_activate_c"
}

function testRegisterCoreRejectsDuplicate() {
	_test_hooks_reset
	register_core "_activate_dup" "dup"
	# registering the same function twice would run it twice
	( register_core "_activate_dup" "dup" ) > /dev/null 2>&1 && _bashy_assert_fail
	return 0
}

function testRegisterUsesSourceName() {
	_test_hooks_reset
	register "_activate_from_test"
	# the name is derived from the file that called register, which is this test
	_bashy_assert_equal "${_bashy_assoc_function[_activate_from_test]}" "hooks"
}

function testRegisterInstallIsANoop() {
	_test_hooks_reset
	register_install "_install_thing"
	# install functions are not hooks, they are only called on demand
	_bashy_assert_equal "${#_bashy_array_function[@]}" 0
}

function testRegisterInteractiveSkipsWhenNotInteractive() {
	_test_hooks_reset
	# the test suite runs non interactively, so this must register nothing
	if is_interactive
	then
		return 0
	fi
	register_interactive "_activate_interactive_thing"
	_bashy_assert_equal "${#_bashy_array_function[@]}" 0
}
