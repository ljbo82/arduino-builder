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

ifndef _include_arduino_avr_core_mk
_include_arduino_avr_core_mk := 1

coreSrcDir := avr-core

PROJ_NAME    := arduino-core
PROJ_TYPE    := lib
PROJ_VERSION := $(shell cd $(coreSrcDir) && git describe --tags)

SKIP_CORE_PRE_BUILD := 1
include defs.mk

SRC_DIRS       += $(coreSrcDir)/cores/arduino
INCLUDE_DIRS   += $(coreSrcDir)/variants/$(_variant) $(coreSrcDir)/cores
POST_DIST_DEPS += $(foreach srcHeader, $(shell find $(coreSrcDir)/cores/arduino -type f -name *.h -or -name *.hpp), $(distDir)/$(defaultIncludeDir)/arduino/$(notdir $(srcHeader)))
POST_DIST_DEPS += $(distDir)/$(defaultIncludeDir)/arduino/pins_arduino.h

# POST_DIST_DEPS ===============================================================
$(distDir)/$(defaultIncludeDir)/arduino/%.h : $(coreSrcDir)/cores/arduino/%.h
	@printf "$(nl)[DIST] $@\n"
	@mkdir -p $(dir $@)
	$(v)ln $< $@

$(distDir)/$(defaultIncludeDir)/arduino/pins_arduino.h : $(coreSrcDir)/variants/$(_variant)/pins_arduino.h
	@printf "$(nl)[DIST] $@\n"
	@mkdir -p $(dir $@)
	$(v)ln $< $@
# ==============================================================================

include project.mk

endif # _include_arduino_avr_core_mk
