# This is a plugin for dotnet

function _activate_dotnet() {
	local -n __var=$1
	local -n __error=$2
	if ! checkInPath "dotnet" __var __error; then return; fi
	complete -f -F _dotnet_bash_complete dotnet
	__var=0
}

# https://learn.microsoft.com/en-us/dotnet/core/tools/enable-tab-autocomplete
function _dotnet_bash_complete() {
	local cur="${COMP_WORDS[COMP_CWORD]}" IFS=$'\n' # On Windows you may need to use use IFS=$'\r\n'
	local candidates
	read -d '' -ra candidates < <(dotnet complete --position "${COMP_POINT}" "${COMP_LINE}" 2>/dev/null)
	read -d '' -ra COMPREPLY < <(compgen -W "${candidates[*]:-}" -- "${cur}")
}

register_interactive _activate_dotnet
