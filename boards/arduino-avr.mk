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

ifeq ($(SKIP_CORE_PRE_BUILD), )
    SKIP_CORE_PRE_BUILD := 0
endif

ifeq ($(CORE_VERSION), )
    CORE_VERSION := 1.8.3
endif
coreDirBase := $(_arduino_boards_arduino_avr_mk_dir)/cores/avr
coreLib := arduino-core$(shell echo $(CORE_VERSION) | cut -d'.' -f1)
ifeq ($(DEBUG), 1)
    __debugSuffix := _d
    coreLib       := $(coreLib)_$(__debugSuffix)
endif

ifeq ($(SKIP_CORE_PRE_BUILD), 0)
    BUILD_DEPS   += $(coreDirBase)/dist/$(BOARD)/lib/lib$(coreLib).a
    INCLUDE_DIRS += $(coreDirBase)/dist/$(BOARD)/$(defaultIncludeDir)
    LDFLAGS      += -L$(coreDirBase)/dist/$(BOARD)/lib -l$(coreLib) -lm
endif

CROSS_COMPILE := avr-
AS            := gcc

CFLAGS   += -Os -std=gnu11 -ffunction-sections -fdata-sections
CXXFLAGS += -Os -std=gnu++11 -fpermissive -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -Wno-error=narrowing
ASFLAGS  += -x assembler-with-cpp
LDFLAGS  += -Os -Wl,--gc-sections

ifeq ($(PROJ_TYPE), app)
    artifactName    := $(PROJ_NAME)$(projVersionMajor)$(__debugSuffix).bin
    hexArtifactName := $(basename $(artifactName)).hex

    CFLAGS   += -flto -fno-fat-lto-objects
    CXXFLAGS += -flto
    ASFLAGS  += -flto
    LDFLAGS  += -flto -fuse-linker-plugin -mmcu=$(_mcu)

    POST_BUILD_DEPS += $(buildDir)/$(hexArtifactName)
    POST_DIST_DEPS  += $(distDir)/bin/$(hexArtifactName)
else
    artifactName := lib$(PROJ_NAME)$(projVersionMajor)$(__debugSuffix).a
endif

CFLAGS   += -mmcu=$(_mcu) -DF_CPU=$(_fcpu) -DARDUINO=$(CORE_VERSION) -DARDUINO_$(_board) -DARDUINO_ARCH_$(_arch)
CXXFLAGS += -mmcu=$(_mcu) -DF_CPU=$(_fcpu) -DARDUINO=$(CORE_VERSION) -DARDUINO_$(_board) -DARDUINO_ARCH_$(_arch)
ASFLAGS  += -mmcu=$(_mcu) -DF_CPU=$(_fcpu) -DARDUINO=$(CORE_VERSION) -DARDUINO_$(_board) -DARDUINO_ARCH_$(_arch)

# BUILD_DEPS ===================================================================
ifeq ($(SKIP_CORE_PRE_BUILD), 0)
$(coreDirBase)/dist/$(BOARD)/lib/lib$(coreLib).a:
	@printf "$(nl)[BUILD] $@\n"
	@rm -f $(buildDir)/$(artifactName) $(distDir)/bin/$(artifactName)
	$(v)cd $(_arduino_boards_arduino_avr_mk_dir)/cores; $(MAKE) -f avr.mk CORE_VERSION=$(CORE_VERSION)
endif
# ==============================================================================

# POST_BUILD_DEPS ==============================================================
$(buildDir)/$(hexArtifactName): $(buildDir)/$(artifactName)
	@printf "$(nl)[HEX] $@\n"
	@mkdir -p $(dir $@)
	$(v)avr-objcopy -O ihex -R .eeprom $< $@
# ==============================================================================

# POST_DIST_DEPS ==============================================================
$(distDir)/bin/$(hexArtifactName): $(buildDir)/$(hexArtifactName)
	@printf "$(nl)[DIST] $@\n"
	@mkdir -p $(dir $@)
	$(v)ln -f $< $@
# ==============================================================================

# ==============================================================================
.PHONY: flash
flash: dist
    ifeq ($(PROJ_TYPE), lib)
	    $(error Flash does not apply to a library)
    endif
    ifeq ($(PORT), )
	    $(error Missing PORT)
    endif
	@printf "$(nl)[FLASH] $(distDir)/bin/$(hexArtifactName)\n"
	$(v)avrdude -C/etc/avrdude.conf -v -p$(_mcu) -carduino -P$(PORT) -Uflash:w:$(distDir)/bin/$(hexArtifactName):i
# ==============================================================================

endif # _include_arduino_boards_arduino_avr_mk

