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

ifndef _include_arduino_boards_arduino_avr_mk
_include_arduino_boards_arduino_avr_mk := 1

# ------------------------------------------------------------------------------
ifeq ($(_arduino_project_mk_dir),)
    $(error project.mk not included yet)
endif
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
ifeq ($(BOARD),$(basename $(notdir $(lastword $(MAKEFILE_LIST)))))
    $(error Unsupported BOARD: $(BOARD))
endif
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
ifeq ($(SKIP_CORE_PRE_BUILD),)
    SKIP_CORE_PRE_BUILD := 0
endif

ifneq ($(SKIP_CORE_PRE_BUILD),0)
    ifneq ($(SKIP_CORE_PRE_BUILD),1)
        $(error Invalid value for SKIP_CORE_PRE_BUILD: $(SKIP_CORE_PRE_BUILD))
    endif
endif
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
ifeq ($(CORE_VERSION),)
    CORE_VERSION := 1.8.3
endif

include $(_arduino_project_mk_dir)$(gcc_project_builder_dir)/functions.mk

ifeq ($(call fn_version_valid,$(CORE_VERSION)),0)
    $(error Invalid CORE_VERSION: $(CORE_VERSION))
endif
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
ifeq ($(SKIP_CORE_PRE_BUILD),0)
    LIB_PROJ_DIRS +=  $(_arduino_project_mk_dir)cores:avr.mk::CORE_VERSION=$(CORE_VERSION)
endif
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
CROSS_COMPILE := avr-
AS            := gcc
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
CFLAGS   += -Os -std=gnu11 -ffunction-sections -fdata-sections
CXXFLAGS += -Os -std=gnu++11 -fpermissive -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -Wno-error=narrowing
ASFLAGS  += -x assembler-with-cpp
LDFLAGS  += -Os -Wl,--gc-sections
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
ifeq ($(PROJ_TYPE),app)
    ARTIFACT_NAME   := $(ARTIFACT_BASE_NAME).bin
    hexArtifactName := $(basename $(ARTIFACT_NAME)).hex

    CFLAGS   += -flto -fno-fat-lto-objects
    CXXFLAGS += -flto
    ASFLAGS  += -flto
    LDFLAGS  += -flto -fuse-linker-plugin -mmcu=$(mcu)

    POST_BUILD_DEPS += $(buildDir)/$(hexArtifactName)
    POST_DIST_DEPS  += $(distDir)/bin/$(hexArtifactName)
else
    ARTIFACT_NAME := lib$(ARTIFACT_BASE_NAME).a
endif
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
CFLAGS   += -mmcu=$(mcu) -DF_CPU=$(fcpu) -DARDUINO=$(CORE_VERSION) -DARDUINO_$(board) -DARDUINO_ARCH_$(arch)
CXXFLAGS += -mmcu=$(mcu) -DF_CPU=$(fcpu) -DARDUINO=$(CORE_VERSION) -DARDUINO_$(board) -DARDUINO_ARCH_$(arch)
ASFLAGS  += -mmcu=$(mcu) -DF_CPU=$(fcpu) -DARDUINO=$(CORE_VERSION) -DARDUINO_$(board) -DARDUINO_ARCH_$(arch)
# ------------------------------------------------------------------------------

# POST_BUILD_DEPS ==============================================================
ifeq ($(PROJ_TYPE),app)
$(buildDir)/$(hexArtifactName): $(buildDir)/$(ARTIFACT_NAME)
	@printf "$(nl)[HEX] $@\n"
	@mkdir -p $(dir $@)
	$(v)avr-objcopy -O ihex -R .eeprom $< $@
endif
# ==============================================================================

# POST_DIST_DEPS ===============================================================
ifeq ($(PROJ_TYPE),app)
$(distDir)/bin/$(hexArtifactName): $(buildDir)/$(hexArtifactName)
	@printf "$(nl)[DIST] $@\n"
	@mkdir -p $(dir $@)
	$(v)ln -f $< $@
endif
# ==============================================================================

# ==============================================================================
ifeq ($(PROJ_TYPE),app)
.PHONY: flash
flash: dist
    ifeq ($(PORT),)
	    $(error Missing PORT)
    endif
    ifeq ($(shell avrdude -? > /dev/null 2>&1 && echo 1 || echo 0),0)
	    $(error avrdude is not in PATH)
    endif
	@printf "$(nl)[FLASH] $(distDir)/bin/$(hexArtifactName)\n"
	$(v)avrdude -C/etc/avrdude.conf -v -p$(mcu) -carduino -P$(PORT) -Uflash:w:$(distDir)/bin/$(hexArtifactName):i
endif
# ==============================================================================

endif # _include_arduino_boards_arduino_avr_mk
