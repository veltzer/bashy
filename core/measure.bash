function measure() {
	local -n __user_var=$1
	local function_name=$2
	local -n __var_name=$3
	local -n __var_name2=$4
	local _start
	local _end
	local _m_diff
	_start=$(date +%s.%N)
	"${function_name}" __var_name __var_name2
	_end=$(date +%s.%N)
	_m_diff=$(echo "${_end} - ${_start}" | bc -l)
	__user_var="${_m_diff}"
}
