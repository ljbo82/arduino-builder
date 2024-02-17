# Copyright (c) 2022-2024 Leandro José Britto de Oliveira
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

ifndef ab_toolchains_gcc_arduino_avr_toolchain_mk
ab_toolchains_gcc_arduino_avr_toolchain_mk := $(lastword $(MAKEFILE_LIST))

ifndef ab_builder_mk
    $(error This file cannot be manually included)
endif

CROSS_COMPILE ?= avr-
RELEASE_OPTIMIZATION_LEVEL := s

ifdef ARDUINO_ARCH
    $(error [ARDUINO_ARCH] Reserved variable)
endif

ARDUINO_ARCH := AVR

override AS = $(CC)

override CFLAGS   += -std=gnu11 -ffunction-sections -fdata-sections
override CXXFLAGS += -std=gnu++11 -fpermissive -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -Wno-error=narrowing
override ASFLAGS  += -x assembler-with-cpp
override LDFLAGS  += -Wl,--gc-sections

ifeq ($(PROJ_TYPE),app)
    override CFLAGS   += -flto -fno-fat-lto-objects
    override CXXFLAGS += -flto
    override ASFLAGS  += -flto
    override LDFLAGS  += -flto -fuse-linker-plugin -mmcu=$(ARDUINO_MCU)
endif

override CFLAGS   += -mmcu=$(ARDUINO_MCU) -DF_CPU=$(ARDUINO_F_CPU) -DARDUINO_$(ARDUINO_BOARD) -DARDUINO_ARCH_$(ARDUINO_ARCH)
override CXXFLAGS += -mmcu=$(ARDUINO_MCU) -DF_CPU=$(ARDUINO_F_CPU) -DARDUINO_$(ARDUINO_BOARD) -DARDUINO_ARCH_$(ARDUINO_ARCH)
override ASFLAGS  += -mmcu=$(ARDUINO_MCU) -DF_CPU=$(ARDUINO_F_CPU) -DARDUINO_$(ARDUINO_BOARD) -DARDUINO_ARCH_$(ARDUINO_ARCH)

ifeq ($(PROJ_TYPE),app)
    POST_INCLUDES += $(dir $(ab_toolchains_gcc_arduino_avr_toolchain_mk))targets.mk
endif

endif # ifndef ab_toolchains_gcc_arduino_avr_toolchain_mk
