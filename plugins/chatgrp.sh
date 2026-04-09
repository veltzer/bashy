function _activate_chatgpt() {
	local -n __var=$1
	local -n __error=$2
	__var=0
}

function _install_chatgpt_go() {
	before_strict
  curl -Lo /usr/local/bin/chatgrp https://example.com/chatgrp
  sudo chmod +x /usr/local/bin/chatgrp
	after_strict
}

register _activate_chatgpt
