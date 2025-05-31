##############
# parameters #
##############
# do you want to see the commands executed ?
DO_MKDBG:=0
# do you want to check bash syntax?
DO_SH_SYNTAX:=1
# do you want to run shell tests?
DO_TEST:=1
# use the ALLDEP features (to depend on the Makefile itself)
DO_ALLDEP:=1

########
# code #
########
ALL:=

# silent stuff
ifeq ($(DO_MKDBG),1)
Q:=
# we are not silent in this branch
else # DO_MKDBG
Q:=@
#.SILENT:
endif # DO_MKDBG

OUT_DIR:=out
ALL_TEST_STAMP=out/test_all.test

SH_SRC:=$(shell find . -type f -name "*.sh" -and -not -path "./.venv/*" -and -not -path "./node_modules/*" -printf "%P\n")
SH_CHECK:=$(addprefix out/, $(addsuffix .check, $(SH_SRC)))

ifeq ($(DO_SH_SYNTAX),1)
ALL+=$(SH_CHECK)
endif # DO_SH_SYNTAX

ifeq ($(DO_TEST),1)
ALL+=$(ALL_TEST_STAMP)
endif # DO_TEST

#########
# rules #
#########
.PHONY: all
all: $(ALL)
	@true

.PHONY: install
install:
	$(Q)pymakehelper symlink_install --source_folder src --target_folder ~/install/bin

.PHONY: debug
debug:
	$(info ALL is $(ALL))
	$(info SH_SRC is $(SH_SRC))
	$(info SH_CHECK is $(SH_CHECK))

.PHONY: first_line_stats
first_line_stats:
	$(Q)head -1 -q $(ALL_SH) | sort -u

.PHONY: clean
clean:
	$(Q)rm -f $(ALL)

.PHONY: clean_hard
clean_hard:
	$(info doing [$@])
	$(Q)git clean -qffxd

.PHONY: check_all
check_all:
	$(Q)pymakehelper no_err git grep "\ \ " -- "*.sh"
	$(Q)pymakehelper no_err git grep " \$$" -- "*.sh"
	$(Q)shellcheck --shell=bash $(ALL_BASH)
	$(Q)git grep "$$[^\"'{(123 ]" -- "*.sh"

############
# patterns #
############
$(SH_CHECK): out/%.check: % .shellcheckrc
	$(info doing [$@])
	$(Q)shellcheck --shell=bash --external-sources --source-path="$${HOME}" $<
	$(Q)pymakehelper touch_mkdir $@
$(ALL_TEST_STAMP): $(ALL_BASH)
	$(info doing [$@])
	$(Q)./test_all.sh
	$(Q)pymakehelper touch_mkdir $@

##########
# alldep #
##########
ifeq ($(DO_ALLDEP),1)
.EXTRA_PREREQS+=$(foreach mk, ${MAKEFILE_LIST},$(abspath ${mk}))
endif # DO_ALLDEP
