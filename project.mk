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

ifndef _include_arduino_project_mk
_include_arduino_project_mk := 1

# ------------------------------------------------------------------------------
_arduino_project_mk_dir := $(dir $(lastword $(MAKEFILE_LIST)))
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
include $(_arduino_project_mk_dir)gcc-project/functions.mk
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
defaultBoardsDir := boards
ifeq ($(BOARDS_DIR), )
    BOARDS_DIR := $(defaultBoardsDir)
endif
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
defaultSkipBoardMk := 0
ifeq ($(SKIP_BOARD_MK), )
    SKIP_BOARD_MK := $(defaultSkipBoardMk)
else
    ifneq ($(SKIP_BOARD_MK), 0)
        ifneq ($(SKIP_BOARD_MK), 1)
            $(error Invalid value for SKIP_BOARD_MK: $(SKIP_BOARD_MK))
        endif
    endif
endif

ifeq ($(SKIP_BOARD_MK), 0)
    ifeq ($(BOARD_MK), )
        ifneq ($(wildcard $(BOARDS_DIR)/$(BOARD).mk), )
            BOARD_MK := $(BOARDS_DIR)/$(BOARD).mk
        else
            BOARD_MK :=
        endif
    else
        ifeq ($(wildcard $(BOARD_MK)), )
            $(error [BOARD_MK] No such file: $(BOARD_MK))
        endif
    endif
else
    BOARD_MK :=
endif
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
defaultSkipBuilderBoardMk := 0
ifeq ($(SKIP_BUILDER_BOARD_MK), )
    SKIP_BUILDER_BOARD_MK := $(defaultSkipBuilderBoardMk)
else
    ifneq ($(SKIP_BUILDER_BOARD_MK), 0)
        ifneq ($(SKIP_BUILDER_BOARD_MK), 1)
            $(error Invalid value for SKIP_BUILDER_BOARD_MK: $(SKIP_BUILDER_BOARD_MK))
        endif
    endif
endif

ifeq ($(SKIP_BUILDER_BOARD_MK), 0)
    ifeq ($(BUILDER_BOARD_MK), )
        ifneq ($(wildcard $(_arduino_project_mk_dir)$(defaultBoardsDir)/$(BOARD).mk), )
            BUILDER_BOARD_MK := $(_arduino_project_mk_dir)$(defaultBoardsDir)/$(BOARD).mk
        else
            BUILDER_BOARD_MK :=
        endif
    else
        ifeq ($(wildcard $(BUILDER_BOARD_MK)), )
            $(error [BUILDER_BOARD_MK] No such file: $(BUILDER_BOARD_MK))
        endif
    endif
else
    BUILDER_BOARD_MK :=
endif
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
ifeq ($(BOARD_MK), )
    ifeq ($(BUILDER_BOARD_MK), )
        $(error Unsupported BOARD: $(BOARD))
    endif
endif
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
HOSTS_DIR       := $(BOARDS_DIR)
HOST_MK         := $(BOARD_MK)
BUILDER_HOST_MK := $(BUILDER_BOARD_MK)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
include $(_arduino_project_mk_dir)gcc-project/project.mk
# ------------------------------------------------------------------------------

endif # _include_arduino_project_mk

