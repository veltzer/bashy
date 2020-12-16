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

OUT_DIR:=out
ALL:=
ALL_SH:=$(shell find -type f -and -name "*.sh" -printf "%P\n")
ALL_SH_BASE:=$(basename $(ALL_SH))
ALL_SH_STAMP:=$(addsuffix .stamp,$(addprefix $(OUT_DIR)/,$(ALL_SH_BASE)))

ALL_BASH:=$(shell find -type f -and -name "*.bash" -printf "%P\n")
ALL_BASH_BASE:=$(basename $(ALL_BASH))
ALL_BASH_STAMP:=$(addsuffix .stamp,$(addprefix $(OUT_DIR)/,$(ALL_BASH_BASE)))

ifeq ($(DO_CHECK_SYNTAX),1)
	ALL+=$(ALL_SH_STAMP)
	ALL+=$(ALL_BASH_STAMP)
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
	$(info ALL_BASH is $(ALL_BASH))
	$(info ALL_SH_STAMP is $(ALL_SH_STAMP))
	$(info ALL_BASH_STAMP is $(ALL_BASH_STAMP))

.PHONY: first_line_stats
first_line_stats:
	$(Q)head -1 -q $(ALL_SH) | sort -u

.PHONY: clean
clean:
	$(Q)rm -f $(ALL)

.PHONY: check_all
check_all:
	pymakehelper no_err git grep "\ \ "
	pymakehelper no_err git grep " \$$"
	$(Q)shellcheck --shell=bash */*.sh */*.bashinc */*.bash

############
# patterns #
############
$(ALL_SH_STAMP): out/%.stamp: %.sh $(ALL_DEP)
	$(info doing [$@])
	$(Q)/usr/bin/shellcheck --shell=bash --external-sources $<
	$(Q)pymakehelper touch_mkdir $@
$(ALL_BASH_STAMP): out/%.stamp: %.bash $(ALL_DEP)
	$(info doing [$@])
	$(Q)/usr/bin/shellcheck --shell=bash --external-sources $<
	$(Q)pymakehelper touch_mkdir $@
