# This file is part of arduino-gcc-project-builder.
# Copyright (C) 2021 Leandro José Britto de Oliveira
#
# arduino-gcc-project-builder is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
#
# arduino-gcc-project-builder is distributed in the hope that it will be
# useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with arduino-gcc-project-builder.  If not,
# see <https://www.gnu.org/licenses/>

ifeq ($(CORE_REPO),)
    CORE_REPO := https://github.com/arduino/ArduinoCore-avr.git
endif

ifeq ($(CORE_VERSION),)
    CORE_VERSION := 1.8.3
endif

thisFile    := $(lastword $(MAKEFILE_LIST))
coreBaseDir := avr
coreSrcDir  := $(coreBaseDir)/src

fn_path_get_level = $(shell sh -c "echo $(1) | cut -d'/' -f$(2)-")

PROJ_NAME      := arduino-core
PROJ_TYPE      := lib
PROJ_VERSION   := $(CORE_VERSION)
O              ?= $(coreBaseDir)/output
SRC_DIRS       += $(coreSrcDir)/cores/arduino
SRC_DIRS       += $(foreach library,$(shell find $(coreSrcDir)/libraries -maxdepth 1 -type d -path '$(coreSrcDir)/libraries/*'),$(library)/src)
INCLUDE_DIRS   += $(coreSrcDir)/variants/$(_VARIANT) $(coreSrcDir)/cores
PRE_BUILD_DEPS  += src-checkout
POST_DIST_DEPS += $(foreach srcHeader,$(shell find $(coreSrcDir)/cores/arduino -type f -name '*.h' -and ! \( -name '*_private.h' \)),$(distDir)/$(defaultIncludeDir)/$(notdir $(srcHeader)))
POST_DIST_DEPS += $(distDir)/$(defaultIncludeDir)/pins_arduino.h
POST_DIST_DEPS += $(foreach libHeader,$(shell find $(coreSrcDir)/libraries -type f -name '*.h'),$(distDir)/$(defaultIncludeDir)/$(call fn_path_get_level,$(libHeader),6))

coreExists := $(wildcard $(coreSrcDir)/cores/arduino/Arduino.h)

ifeq ($(coreExists),)
    coreExists := 0
else
    coreExists := 1
    coreTag    := $(shell cd $(coreSrcDir) > /dev/null 2>&1; git describe --tags)
endif

ifeq ($(coreExists),1)
    # If core source is present, enables standard build targets
    SKIP_CORE_PRE_BUILD := 1
    LIBS += m
    include ../project.mk
else
    # If core' source is not present offers only 'src-checkout' target
    ifeq ($(V),)
        V := 0
    endif

    ifneq ($(V),0)
        ifneq ($(V),1)
            $(error ERROR: Invalid value for V: $(V))
        endif
    endif

    ifeq ($(V),0)
        v  := @
        nl :=
    else
        v  :=
        nl := \n
    endif

    .DEFAULT_GOAL := src-checkout
endif

# BUILD_DEPS ===================================================================
$(coreSrcDir)/.git/index:
	@printf "$(nl)[GIT] clone $(CORE_REPO)\n"
	@mkdir -p $(coreBaseDir)
	$(v)git clone -q $(CORE_REPO) $(coreSrcDir)

.PHONY: src-checkout
src-checkout: $(coreSrcDir)/.git/index
    ifneq ($(coreTag),$(CORE_VERSION))
	    @printf "$(nl)[GIT] checkout $(CORE_VERSION)\n"
        ifneq ($(shell cd $(coreSrcDir) > /dev/null 2>&1; git checkout $(CORE_VERSION) > /dev/null 2>&1; echo $$?),0)
	        $(v)cd $(coreSrcDir); git fetch -q
	        $(v)cd $(coreSrcDir); git checkout -q $(CORE_VERSION)
        endif
	    $(v)$(MAKE) -f $(thisFile) clean
        ifeq ($(coreExists),0)
	        $(v)$(MAKE) -f $(thisFile) CORE_VERSION=$(CORE_VERSION)
        endif
    endif
# ==============================================================================

# POST_DIST_DEPS ===============================================================
$(distDir)/$(defaultIncludeDir)/%.h : $(coreSrcDir)/cores/arduino/%.h
	@printf "$(nl)[DIST] $@\n"
	@mkdir -p $(dir $@)
	$(v)ln -f $< $@

$(distDir)/$(defaultIncludeDir)/%.h : $(coreSrcDir)/libraries/*/src/%.h
	@printf "$(nl)[DIST] $@\n"
	@mkdir -p $(dir $@)
	$(v)ln -f $< $@

$(distDir)/$(defaultIncludeDir)/pins_arduino.h : $(coreSrcDir)/variants/$(_VARIANT)/pins_arduino.h
	@printf "$(nl)[DIST] $@\n"
	@mkdir -p $(dir $@)
	$(v)ln -f $< $@
# ==============================================================================
