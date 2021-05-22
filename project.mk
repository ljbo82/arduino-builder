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
gcc_project_builder_dir := gcc-builder
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
include $(_arduino_project_mk_dir)$(gcc_project_builder_dir)/functions.mk
ifneq ($(HOST), )
    ifeq ($(call fn_host_valid, $(HOST)), 0)
        $(error Invalid HOST: $(HOST))
    endif

    hostOS := $(call fn_host_os, $(HOST))
    hostArch := $(call fn_host_arch, $(HOST))

    ifeq ($(hostOS), arduino)
        ifneq ($(BOARD), )
            # [Example] HOST=arduino-uno BOARD=leonardo
            ifneq ($(BOARD), $(hostArch))
                $(error HOST ($(HOST)) is not compatible with BOARD ($(BOARD)))
            endif
        else
            BOARD := $(hostArch)
        endif
    else
        # [Example] HOST=linux-x86 BOARD=uno
        ifneq ($(BOARD), )
            $(error HOST ($(HOST)) is not compatible with BOARD ($(BOARD)))
        endif
    endif
else
    ifneq ($(BOARD), )
        hostOS   := arduino
        hostArch := $(BOARD)
        HOST     := $(hostOS)-$(hostArch)
    endif
endif
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
defaultEnforceArduinoOnly := 0
ifeq ($(ENFORCE_ARDUINO_ONLY), )
    ENFORCE_ARDUINO_ONLY := $(defaultEnforceArduinoOnly)
endif

ifneq ($(ENFORCE_ARDUINO_ONLY), 0)
    ifneq ($(ENFORCE_ARDUINO_ONLY), 1)
        $(error Invalid value for ENFORCE_ARDUINO_ONLY: $(ENFORCE_ARDUINO_ONLY))
    endif
endif

ifeq ($(ENFORCE_ARDUINO_ONLY), 1)
    ifeq ($(BOARD), )
        PRE_BUILD_DEPS += arduino-missing-board
    endif
endif
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
ifeq ($(hostOS), arduino)
    ifneq ($(LIB_TYPE), )
        ifneq ($(LIB_TYPE), static)
            $(error Invalid LIB_TYPE: $(LIB_TYPE))
        endif
    else
        LIB_TYPE := static
    endif

    defaultBoardsDir := boards
    ifeq ($(BOARDS_DIR), )
        BOARDS_DIR := $(defaultBoardsDir)
    endif

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

    ifeq ($(BOARD_MK), )
        ifeq ($(BUILDER_BOARD_MK), )
            $(error Unsupported BOARD: $(BOARD))
        endif
    endif

    HOSTS_DIR       := $(BOARDS_DIR)
    HOST_MK         := $(BOARD_MK)
    BUILDER_HOST_MK := $(BUILDER_BOARD_MK)
endif
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
include $(_arduino_project_mk_dir)$(gcc_project_builder_dir)/project.mk
# ------------------------------------------------------------------------------

# ==============================================================================
ifeq ($(ENFORCE_ARDUINO_ONLY), 1)
ifeq ($(BOARD), )
.PHONY: arduino-missing-board
arduino-missing-board:
	$(error "Missing BOARD")
endif
endif
# ==============================================================================

endif # _include_arduino_project_mk

