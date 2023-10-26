# floating point utilities
# https://stackoverflow.com/questions/8654051/how-to-compare-two-floating-point-numbers-in-bash

ASSERT_FAILED_CODE=128

function float_gt() {
	local a=$1
	local b=$2
	(( $(echo "${a} > ${b}" |bc -l) ))
}

function float_ge() {
	local a=$1
	local b=$2
	(( $(echo "${a} >= ${b}" |bc -l) ))
}

function float_eq() {
	local a=$1
	local b=$2
	(( $(echo "${a} == ${b}" |bc -l) ))
}

function float_ne() {
	local a=$1
	local b=$2
	(( $(echo "${a} != ${b}" |bc -l) ))
}

function float_lt() {
	local a=$1
	local b=$2
	(( $(echo "${a} < ${b}" |bc -l) ))
}

function float_le() {
	local a=$1
	local b=$2
	(( $(echo "${a} <= ${b}" |bc -l) ))
}

function float_add() {
	local __user_var=$1
	local a=$2
	local b=$3
	local result
	result=$(echo "${a}+${b}" |bc -l)
	eval "${__user_var}=${result}"
}

function float_sub() {
	local __user_var=$1
	local a=$2
	local b=$3
	local result
	result=$(echo "${a}-${b}" |bc -l)
	eval "${__user_var}=${result}"
}

function float_mul() {
	local __user_var=$1
	local a=$2
	local b=$3
	local result
	result=$(echo "${a}*${b}" |bc -l)
	eval "${__user_var}=${result}"
}

function float_div() {
	local __user_var=$1
	local a=$2
	local b=$3
	local result
	result=$(echo "${a}/${b}" |bc -l)
	eval "${__user_var}=${result}"
}

function assert_lt() {
	local a=$1
	local b=$2
	if ! float_lt "${a}" "${b}"
	then
		echo "assertion failed ! float_lt ${a} ${b}"
		exit "${ASSERT_FAILED_CODE}"
	fi
}

function assert_gt() {
	local a=$1
	local b=$2
	if ! float_gt "${a}" "${b}"
	then
		echo "assertion failed ! float_gt ${a} ${b}"
		exit "${ASSERT_FAILED_CODE}"
	fi
}
