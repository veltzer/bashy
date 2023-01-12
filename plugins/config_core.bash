# This plugin configures core features because
# default ubuntu does not come with a sane configuration for
# instruction
# note that since I plug in a non absolute path for cores the kernel will complain
# on unsecure configuration.

function _activate_core() {
	local -n __var=$1
	local -n __error=$2
	ulimit -c unlimited
	echo core | sudo tee /proc/sys/kernel/core_pattern > /dev/null
	__var=0
}

register _activate_core
