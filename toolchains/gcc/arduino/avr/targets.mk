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

ifndef ab_toolchains_gcc_arduino_avr_targets_mk
ab_toolchains_gcc_arduino_avr_targets_mk := $(lastword $(MAKEFILE_LIST))

ifndef ab_builder_mk
    $(error This file cannot be manually included)
endif

POST_BUILD_DEPS += $(O_BUILD_DIR)/$(ARTIFACT).hex
DIST_FILES += $(O_BUILD_DIR)/$(ARTIFACT).hex->bin/$(ARTIFACT).hex

# ==============================================================================
$(O_BUILD_DIR)/$(ARTIFACT).hex: $(O_BUILD_DIR)/$(ARTIFACT)
	@echo [HEX] $@
	$(VERBOSE)avr-objcopy -O ihex -R .eeprom $< $@
# ==============================================================================

# ==============================================================================
.PHONY: upload
upload: dist
	$(call FN_CHECK_NON_EMPTY,PORT)
	@echo [UPLOAD] $(O_DIST_DIR)/bin/$(ARTIFACT).hex ==> $(PORT)
	$(VERBOSE)avrdude -C/etc/avrdude.conf -v -p$(ARDUINO_MCU) -carduino -P$(PORT) -Uflash:w:$(O_DIST_DIR)/bin/$(ARTIFACT).hex:i
# ==============================================================================

endif # ifndef ab_toolchains_gcc_arduino_avr_targets_mk
