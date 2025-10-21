# This plugin sets up core dumping features
# why would you need it?
# default ubuntu does not come with a sane configuration for core files for
# development or instruction.
# Note that since I plug in a non absolute path for cores the kernel will complain
# on unsecure configuration.

function _activate_core() {
	local -n __var=$1
	local -n __error=$2
	ulimit -c unlimited
	# this one gives warnings
	# echo core | sudo tee /proc/sys/kernel/core_pattern > /dev/null
	echo "core.%e.%p.%t" | sudo tee /proc/sys/kernel/core_pattern > /dev/null
	__var=0
}

register _activate_core
