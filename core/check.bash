# various common checks that are done in bashy

function checkVariableDefined() {
	return
}

function checkDirectoryExists() {
	local directory=$1
	local -n __var2=$2
	local -n __error2=$3
	if [ ! -d "${directory}" ]
	then
		__error2="directory [${directory}] doesnt exist"
		__var2=1
		return 1
	else
		__var=0
		return 0
	fi
}
