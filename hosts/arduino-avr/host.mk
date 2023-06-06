# Copyright (c) 2022 Leandro José Britto de Oliveira
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# arduino-avr host definitions

ifndef __arduino_avr_mk__
__arduino_avr_mk__ := 1

CROSS_COMPILE ?= avr-
LIB_TYPE := static
RELEASE_OPTIMIZATION_LEVEL := s

ifdef ARDUINO_ARCH
    $(error [ARDUINO_ARCH] Reserved variable)
endif
ARDUINO_ARCH := AVR

AS = $(CC)

CFLAGS   += -std=gnu11 -ffunction-sections -fdata-sections
CXXFLAGS += -std=gnu++11 -fpermissive -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -Wno-error=narrowing
ASFLAGS  += -x assembler-with-cpp
LDFLAGS  += -Wl,--gc-sections

ifeq ($(PROJ_TYPE),app)
    CFLAGS   += -flto -fno-fat-lto-objects
    CXXFLAGS += -flto
    ASFLAGS  += -flto
    LDFLAGS  += -flto -fuse-linker-plugin -mmcu=$(ARDUINO_MCU)
endif

CFLAGS   += -mmcu=$(ARDUINO_MCU) -DF_CPU=$(ARDUINO_F_CPU) -DARDUINO_$(ARDUINO_BOARD) -DARDUINO_ARCH_$(ARDUINO_ARCH)
CXXFLAGS += -mmcu=$(ARDUINO_MCU) -DF_CPU=$(ARDUINO_F_CPU) -DARDUINO_$(ARDUINO_BOARD) -DARDUINO_ARCH_$(ARDUINO_ARCH)
ASFLAGS  += -mmcu=$(ARDUINO_MCU) -DF_CPU=$(ARDUINO_F_CPU) -DARDUINO_$(ARDUINO_BOARD) -DARDUINO_ARCH_$(ARDUINO_ARCH)

ifeq ($(PROJ_TYPE),app)
    POST_BUILD_DEPS += $(O_BUILD_DIR)/$(ARTIFACT).hex
    DIST_FILES += $(O_BUILD_DIR)/$(ARTIFACT).hex:bin/$(ARTIFACT).hex

    # NOTE: ARTIFACT is defined later
    define LAZY +=
    # =============================================================================
        $$(O_BUILD_DIR)/$$(ARTIFACT).hex: $$(O_BUILD_DIR)/$$(ARTIFACT)
	    @echo [HEX] $$@
	    $$(O_VERBOSE)avr-objcopy -O ihex -R .eeprom $$< $$@
    # =============================================================================

    # =============================================================================
    .PHONY: upload
    upload: dist
        ifeq ($$(PORT),)
	        $$(error [PORT] Missing value)
        endif
	    @echo [UPLOAD] $$(O_DIST_DIR)/bin/$$(ARTIFACT).hex ==> $$(PORT)
	    $$(O_VERBOSE)avrdude -C/etc/avrdude.conf -v -p$$(ARDUINO_MCU) -carduino -P$$(PORT) -Uflash:w:$$(O_DIST_DIR)/bin/$$(ARTIFACT).hex:i
    # =============================================================================
    endef
endif

endif # ifndef __arduino_avr_mk__
