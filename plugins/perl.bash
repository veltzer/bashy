function configure_perl() {
	local -n __var=$1
	PERL_LOCAL="$HOME/install/perl"
	if [ -d "$PERL_LOCAL" ]
	then
		export PERL5LIB
		pathutils_add_tail PERL5LIB "$PERL_LOCAL"
		# local perl installation with perl -MCPAN
		# the absense of double quotes in the next line is important
		export PERL_LOCAL_LIB_ROOT="$HOME/install/perl5"
		export PERL_MB_OPT="--install_base $PERL_LOCAL_LIB_ROOT"
		export PERL_MM_OPT="INSTALL_BASE=$PERL_LOCAL_LIB_ROOT"
		pathutils_add_tail PERL5LIB "$PERL_LOCAL_LIB_ROOT/lib/perl5/i686-linux-gnu-thread-multi-64int"
		pathutils_add_tail PERL5LIB "$PERL_LOCAL_LIB_ROOT/lib/perl5"
		pathutils_add_tail PATH "$PERL_LOCAL_LIB_ROOT/bin"
		__var=0
		return
	fi
	__var=1
}

register configure_perl
