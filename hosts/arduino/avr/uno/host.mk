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

# arduino-avr-uno host definitions

ifndef __arduino_avr_uno_mk__
__arduino_avr_uno_mk__ := 1

ifndef __arduino_avr_mk__
    $(error This file cannot be manually included)
endif

ARDUINO_MCU     := atmega328p
ARDUINO_F_CPU   := 16000000L
ARDUINO_BOARD   := UNO
ARDUINO_VARIANT := standard

ifeq ($(DEBUG),1)
    CFLAGS   += -Os -s
    CXXFLAGS += -Os -s
endif

endif # ifndef __arduino_avr_uno_mk__
