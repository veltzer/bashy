# floating point utilities
# https://stackoverflow.com/questions/8654051/how-to-compare-two-floating-point-numbers-in-bash

ASSERT_FAILED_CODE=128

function floatGt() {
	local a=$1
	local b=$2
	(( $(echo "$a > $b" |bc -l) ))
}

function floatGe() {
	local a=$1
	local b=$2
	(( $(echo "$a >= $b" |bc -l) ))
}

function floatEq() {
	local a=$1
	local b=$2
	(( $(echo "$a == $b" |bc -l) ))
}

function floatNe() {
	local a=$1
	local b=$2
	(( $(echo "$a != $b" |bc -l) ))
}

function floatLt() {
	local a=$1
	local b=$2
	(( $(echo "$a < $b" |bc -l) ))
}

function floatLe() {
	local a=$1
	local b=$2
	(( $(echo "$a <= $b" |bc -l) ))
}

function floatAdd() {
	local __user_var=$1
	local a=$2
	local b=$3
	local result
	result=$(echo "$a+$b" |bc -l)
	eval "$__user_var=$result"
}

function floatSub() {
	local __user_var=$1
	local a=$2
	local b=$3
	local result
	result=$(echo "$a-$b" |bc -l)
	eval "$__user_var=$result"
}

function floatMul() {
	local __user_var=$1
	local a=$2
	local b=$3
	local result
	result=$(echo "$a*$b" |bc -l)
	eval "$__user_var=$result"
}

function floatDiv() {
	local __user_var=$1
	local a=$2
	local b=$3
	local result
	result=$(echo "$a/$b" |bc -l)
	eval "$__user_var=$result"
}

function assertLt() {
	local a=$1
	local b=$2
	if ! floatLt "$a" "$b"
	then
		echo "assertion failed ! floatLt $a $b"
		exit $ASSERT_FAILED_CODE
	fi
}

function assertGt() {
	local a=$1
	local b=$2
	if ! floatGt "$a" "$b"
	then
		echo "assertion failed ! floatGt $a $b"
		exit $ASSERT_FAILED_CODE
	fi
}
