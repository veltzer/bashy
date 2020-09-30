##############
# PARAMETERS #
##############
# do you want to see the commands executed ?
DO_MKDBG:=0
# do you want to check python syntax?
DO_CHECK_SYNTAX:=1

########
# CODE #
########
# silent stuff
ifeq ($(DO_MKDBG),1)
Q:=
# we are not silent in this branch
else # DO_MKDBG
Q:=@
#.SILENT:
endif # DO_MKDBG

ALL:=
ALL_SH:=$(shell find . -type f -and -name "*.sh")
ALL_BASH:=$(shell find . -type f -and -name "*.bash")
ALL_STAMP:=$(addsuffix .stamp, $(basename $(ALL_SH)))

ifeq ($(DO_CHECK_SYNTAX),1)
	ALL+=$(ALL_STAMP)
endif # DO_CHECK_SYNTAX

#########
# RULES #
#########
.DEFAULT_GOAL=all
.PHONY: all
all: $(ALL)

.PHONY: install
install:
	$(Q)pymakehelper symlink_install --source_folder src --target_folder ~/install/bin

.PHONY: debug
debug:
	$(info ALL_SH is $(ALL_SH))
	$(info ALL_STAMP is $(ALL_STAMP))

.PHONY: first_line_stats
first_line_stats:
	$(Q)head -1 -q $(ALL_SH) | sort -u

.PHONY: clean
clean:
	$(Q)rm -f $(ALL_STAMP)

.PHONY: check_all
check_all:
	$(Q)shellcheck --shell=bash */*.sh */*.bashinc */*.bash

############
# patterns #
############
$(ALL_STAMP): %.stamp: %.sh $(ALL_DEP)
	$(info doing [$@])
	$(Q)/usr/bin/shellcheck --shell=bash --external-sources $<
	$(Q)touch $@
