function measure() {
	local -n __user_var=$1
	local function_name=$2
	local -n __var_name=$3
	local -n __var_name2=$4
	local _start
	local _end
	_start=$(date +%s.%N)
	"$function_name" __var_name __var_name2
	#__var_name=$?
	_end=$(date +%s.%N)
	local _diff
	_diff=$(echo "$_end - $_start" | bc -l)
	__user_var=$_diff
}
