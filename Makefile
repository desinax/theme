#!/usr/bin/env make
#
# A Desinax theme.
# See organisation on GitHub: https://github.com/desinax

# ------------------------------------------------------------------------
#
# General stuff, reusable for all Makefiles.
#

# Detect OS
OS = $(shell uname -s)

# Defaults
ECHO = echo

# Make adjustments based on OS
ifneq (, $(findstring CYGWIN, $(OS)))
	ECHO = /bin/echo -e
endif

# Colors and helptext
NO_COLOR	= \033[0m
ACTION		= \033[32;01m
OK_COLOR	= \033[32;01m
ERROR_COLOR	= \033[31;01m
WARN_COLOR	= \033[33;01m

# Print out colored action message
ACTION_MESSAGE = $(ECHO) "$(ACTION)---> $(1)$(NO_COLOR)"

# Which makefile am I in?
WHERE-AM-I = "$(CURDIR)/$(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST))"
THIS_MAKEFILE := $(call WHERE-AM-I)

# Echo some nice helptext based on the target comment
HELPTEXT = $(call ACTION_MESSAGE, $(shell egrep "^\# target: $(1) " $(THIS_MAKEFILE) | sed "s/\# target: $(1)[ ]*-[ ]* / /g"))

# Check version  and path to command and display on one line
CHECK_VERSION = printf "%-15s %-10s %s\n" "$(shell basename $(1))" "`$(1) --version $(2)`" "`which $(1)`"

# Get current working directory, it may not exist as environment variable.
PWD = $(shell pwd)



# target: help                    - Displays help.
.PHONY:  help
help:
	@$(call HELPTEXT,$@)
	@sed '/^$$/q' $(THIS_MAKEFILE) | tail +3 | sed 's/#\s*//g'
	@$(ECHO) "Usage:"
	@$(ECHO) " make [target] ..."
	@$(ECHO) "target:"
	@egrep "^# target:" $(THIS_MAKEFILE) | sed 's/# target: / /g'



# target: tag-prepare             - Prepare to tag new version.
.PHONY: tag-prepare
tag-prepare:
	@$(call HELPTEXT,$@)
	grep "^v." REVISION.md | head -1
	[ ! -f package.json ] || grep version package.json
	git tag
	git status
	#gps && gps --tags
	#npm publish



# ------------------------------------------------------------------------
#
# Specifics for this project.
#

# Add local bin path for test tools
LESSC   = node_modules/.bin/lessc
ESLINT  = node_modules/.bin/eslint

LESS_SOURCE       = style.less
LESS_INCLUDE_PATH = less

DESINAX_MODULES = \
	@desinax/figure \
	@desinax/responsive-menu \
	@desinax/typographic-grid \
	@desinax/vertical-grid \



# ------------------------------------------------------------------------
#
# Basic rules.
#
# target: prepare                 - Empty and prepare the build directory.
.PHONY: prepare
prepare: 
	@$(call HELPTEXT,$@)
	rm -rf build/*
	install -d build/css build/lint



# target: build                   - Build the stylesheets.
.PHONY: build
build: 
	@$(call HELPTEXT,$@)



# target: clean                   - Clean from generated build files.
.PHONY: clean
clean: 
	@$(call HELPTEXT,$@)
	rm -rf build



# target: clean-all               - Clean all installed utilities.
.PHONY: clean-all
clean-all: clean
	@$(call HELPTEXT,$@)
	rm -rf node_modules



# target: install                 - Install modules and dev environment.
.PHONY: install
install: npm-install modules-install
	@$(call HELPTEXT,$@)



# target: check                   - Check versions of tools.
.PHONY: check
check:
	@$(call HELPTEXT,$@)
	@$(call CHECK_VERSION, $(LESSC))
	@$(call CHECK_VERSION, $(ESLINT))
	npm list --depth=0



# target: update                  - Update codebase.
.PHONY: update
update: npm-update modules-install
	@$(call HELPTEXT,$@)



# target: upgrade                 - Upgrade codebase.
.PHONY: upgrade
upgrade: npm-upgrade modules-install styleguide-install
	@$(call HELPTEXT,$@)



# target: test                    - Execute all tests.
.PHONY: test
test: lint
	@$(call HELPTEXT,$@)



# ------------------------------------------------------------------------
#
# Desinax modules.
#
# target: modules-install         - Install Desinax modules into less/sass/js-dir.
.PHONY: modules-install
modules-install:
	@$(call HELPTEXT,$@)
	@cd node_modules;                         \
	for module in $(DESINAX_MODULES) ; do     \
		$(call ACTION_MESSAGE, $$module);     \
		[ ! -d $$module ]                     \
			&& $(ECHO) "Module not installed, skipping it." \
			&& continue;                      \
		install -d ../src/$$module;           \
		rsync -av $$module/src/ ../src/$$module/; \
	done



# target: modules-clean           - Remove Desinax modules from less/sass/js-dirs
.PHONY: modules-clean
modules-clean:
	@$(call HELPTEXT,$@)
	for module in $(DESINAX_MODULES) ; do     \
		$(call ACTION_MESSAGE, $$module);     \
		rm -rf src/less/$$module src/sass/$$module src/js/$$module;  \
	done



# ------------------------------------------------------------------------
#
# Validation according to CSS-styleguide.
#
# target: styleguide-install      - Install styleguide validation files.
.PHONY: styleguide-install
styleguide-install:
	@$(call HELPTEXT,$@)
	rsync -av node_modules/css-styleguide/.stylelintrc.json .




# ------------------------------------------------------------------------
#
# LESS.
#
# target: less                    - Compile the LESS stylesheet(s).
.PHONY: less
less: build
	@$(call HELPTEXT,$@)
	$(LESSC) --include-path=$(LESS_INCLUDE_PATH) $(LESS_SOURCE) build/css/style.css
	$(LESSC) --include-path=$(LESS_INCLUDE_PATH) --clean-css $(LESS_SOURCE) build/css/style.min.css



# ------------------------------------------------------------------------
#
# CSS.
#
# target: lint                    - Lint the stylesheet(s).
.PHONY: lint
lint: less
	@$(call HELPTEXT,$@)
	$(LESSC) --include-path=$(LESS_INCLUDE_PATH) --lint $(LESS_SOURCE) > build/lint/style.less
	     - $(ESLINT) build/css/style.css > build/lint/style.css
	ls -l build/lint/



# ------------------------------------------------------------------------
#
# NPM.
#
# target: npm-install             - Install npm from package.json.
.PHONY: npm-install
npm-install: 
	@$(call HELPTEXT,$@)
	npm install



# target: npm-update              - Update npm using package.json.
.PHONY: npm-update
npm-update: 
	@$(call HELPTEXT,$@)
	npm update



# target: npm-upgrade             - Upgrade npm using package.json.
.PHONY: npm-upgrade
npm-upgrade: 
	@$(call HELPTEXT,$@)
	npm upgrade



# target: npm-outdated            - Check for outdated packages.
.PHONY: npm-outdated
npm-outdated: 
	@$(call HELPTEXT,$@)
	npm outdated --depth=0
