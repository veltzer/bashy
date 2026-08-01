# measure <out_var> <function> <var> <error>
# Call <function> <var> <error> and put the seconds it took into <out_var>.
#
# This used to shell out to "date" twice and "bc" once per call. At seventy plugins
# that was over two hundred processes and close to a second of every shell start,
# so the timing is now done with EPOCHREALTIME, which bash expands itself without
# forking anything.
#
# EPOCHREALTIME looks like "1785012015.681490", so dropping the dot turns it into
# whole microseconds that plain shell arithmetic can subtract.
function measure() {
	local -n __user_var=$1
	local function_name=$2
	local -n __var_name=$3
	local -n __var_name2=$4
	local _start="${EPOCHREALTIME/./}"
	"${function_name}" __var_name __var_name2
	local _end="${EPOCHREALTIME/./}"
	local _usec=$(( _end - _start ))
	# back to seconds, keeping the six decimals the old "date +%s.%N" style produced
	printf -v __user_var '%d.%06d' "$(( _usec / 1000000 ))" "$(( _usec % 1000000 ))"
}
