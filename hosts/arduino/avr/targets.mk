# Copyright (c) 2023 Leandro José Britto de Oliveira
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

ifndef __arduino_avr_mk__
    $(error This file cannot be manually included)
endif

POST_BUILD_DEPS += $(O_BUILD_DIR)/$(ARTIFACT).hex
DIST_FILES += $(O_BUILD_DIR)/$(ARTIFACT).hex:bin/$(ARTIFACT).hex

# ==============================================================================
$(O_BUILD_DIR)/$(ARTIFACT).hex: $(O_BUILD_DIR)/$(ARTIFACT)
	@echo [HEX] $@
	$(O_VERBOSE)avr-objcopy -O ihex -R .eeprom $< $@
# ==============================================================================

# ==============================================================================
.PHONY: upload
upload: dist
    ifeq ($(PORT),)
	    $(error [PORT] Missing value)
    endif
	@echo [UPLOAD] $(O_DIST_DIR)/bin/$(ARTIFACT).hex ==> $(PORT)
	$(O_VERBOSE)avrdude -C/etc/avrdude.conf -v -p$(ARDUINO_MCU) -carduino -P$(PORT) -Uflash:w:$(O_DIST_DIR)/bin/$(ARTIFACT).hex:i
# ==============================================================================
