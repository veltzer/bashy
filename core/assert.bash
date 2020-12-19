ASSERT_FAILED_CODE=128

function assertEquals() {
	local a=$1
	local b=$2
	if ! [ "$a" = "$b" ]
	then
		echo "assertion failed [ $a = $b ]"
		exit $ASSERT_FAILED_CODE
	fi
}

function assertNotEqual() {
	local a=$1
	local b=$2
	if ! [ "$a" != "$b" ]
	then
		echo "assertion failed [ $a != $b ]"
		exit $ASSERT_FAILED_CODE
	fi
}

function assertOK() {
	:
}

function assertFail() {
	echo "assertion failed"
	exit $ASSERT_FAILED_CODE
}
