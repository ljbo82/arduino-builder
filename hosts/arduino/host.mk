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

# Arduino host definitions

ifndef hosts_arduino_host_mk
hosts_arduino_host_mk := 1

ifndef project_mk
    $(error This file cannot be manually included)
endif

ifeq ($(PROJ_TYPE),app)
    ifndef ARTIFACT
        ARTIFACT := $(PROJ_NAME)
    endif
else ifeq ($(PROJ_TYPE),lib)
    ifdef LIB_TYPE
        $(call FN_CHECK_WORDS,LIB_TYPE,static,Unsupported value: $(LIB_TYPE))
    else
        LIB_TYPE := static
    endif
    ifndef ARTIFACT
        ARTIFACT := lib$(LIB_NAME).a
    endif
endif

endif # ifndef hosts_arduino_host_mk
