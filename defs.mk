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

# ------------------------------------------------------------------------------
ifeq ($(_arduino_project_mk_dir), )
    $(error project.mk not included yet)
endif
include $(_arduino_project_mk_dir)gcc-project/functions.mk
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
ifneq ($(LIB_TYPE), )
    ifneq ($(LIB_TYPE), static)
        $(error Invalid LIB_TYPE: $(LIB_TYPE))
    endif
else
    LIB_TYPE := static
endif
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
ifneq ($(HOST), )
    ifeq ($(call fn_host_valid, $(HOST)), 0)
        $(error Invalid HOST: $(HOST))
    endif
    hostOS := $(call fn_host_os, $(HOST))
    ifneq ($(hostOS), arduino)
        $(error Invalid HOST OS: $(hostOS))
    endif
    hostArch := $(call fn_host_arch, $(HOST))
    BOARD := $(hostArch)
else
    hostOS := arduino
    ifeq ($(BOARD), )
        hostArch := uno
        PRE_BUILD += @echo "Missing BOARD"; exit 1;
    else
        hostArch := $(BOARD)
    endif
    BOARD := $(hostArch)
    HOST  := arduino-$(BOARD)
endif
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
HOSTS_DIR := ../boards
# ------------------------------------------------------------------------------

include $(_arduino_project_mk_dir)gcc-project/project.mk

endif #_include_arduino_defs_mk

