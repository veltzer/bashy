source core/assert.sh
source core/profile.sh

# These two decide whether the profiling path in _bashy_run_plugins runs at all.
# is_profile used to be hardcoded to "return 0", which cost about a second of every
# shell start, so the default mattering is the point of these tests.

function testProfileOffByDefault() {
	unset BASHY_PROFILE
	is_profile && _bashy_assert_fail
	return 0
}

function testProfileOnWhenSetToZero() {
	# the convention in this codebase is 0 means on, like a shell exit status
	BASHY_PROFILE=0
	is_profile || { unset BASHY_PROFILE; _bashy_assert_fail; }
	unset BASHY_PROFILE
}

function testProfileOffWhenSetToOne() {
	BASHY_PROFILE=1
	is_profile && { unset BASHY_PROFILE; _bashy_assert_fail; }
	unset BASHY_PROFILE
	return 0
}

function testStepOffByDefault() {
	unset BASHY_STEP
	is_step && _bashy_assert_fail
	return 0
}

function testStepOnWhenSetToZero() {
	BASHY_STEP=0
	is_step || { unset BASHY_STEP; _bashy_assert_fail; }
	unset BASHY_STEP
}

function testStepOffWhenSetToOne() {
	BASHY_STEP=1
	is_step && { unset BASHY_STEP; _bashy_assert_fail; }
	unset BASHY_STEP
	return 0
}
