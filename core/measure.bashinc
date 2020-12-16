function measure() {
	local -n __user_var=$1
	local function_name=$2
	local var_name=$3
	local start=$(date +%s.%N)
	"$function_name" "$3"
	local ret=$?
	local end=$(date +%s.%N)
	local _diff=$(echo "$end - $start" | bc -l)
	__user_var=$_diff
	return $ret
}
