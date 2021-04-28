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

ifndef _include_arduino_defs_mk
_include_arduino_defs_mk := 1

__arduino_defs_mk_dir := $(dir $(lastword $(MAKEFILE_LIST)))

ifneq ($(LIB_TYPE), )
    ifneq ($(LIB_TYPE), static)
        $(error Invalid LIB_TYPE: $(LIB_TYPE))
    endif
else
    LIB_TYPE := static
endif

ifeq ($(BUILD_DIR_NAME), )
    ifneq ($(BOARD), )
        BUILD_DIR_NAME := $(BOARD)
    else
        BUILD_DIR_NAME := unknown
        PRE_BUILD      += @echo "Missing BOARD"; exit 1;
    endif
endif

ifeq ($(DIST_DIR_NAME), )
    ifneq ($(BOARD), )
        DIST_DIR_NAME := $(BOARD)
    else
        DIST_DIR_NAME := unknown
    endif
endif

ifeq ($(BOARD), )
    HOST := arduino-unknown
else
    HOST := arduino-$(BOARD)
endif 
OS_DIR := ../boards

include $(__arduino_defs_mk_dir)gcc-project/defs.mk
undefine __arduino_defs_mk_dir

endif #_include_arduino_defs_mk

