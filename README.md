# arduino-builder

[This repository](https://github.com/ljbo82/arduino-builder) project provides an additional toolchain layer based on [avr-gcc](https://gcc.gnu.org/wiki/avr-gcc) to build [arduino](https://www.arduino.cc/)-based projects using [cpp-project-builder](tbd).

> **NO OFFICIAL RELEASE YET**
>
> arduino-builder is still under development and there is no official releases yet!

## Supported boards

Currently, only [Arduino UNO](https://docs.arduino.cc/hardware/uno-rev3/) is supported.

## License

arduino-builder is distributed under MIT License. Please see the [LICENSE](LICENSE) file for details on copying and distribution.

## Example usage

Here is an minimal `Makefile` using the aurduino-builder.

> **Assumptions**
>
> * cpp-project-builder-core directory is available through `CPB_DIR` environment variable.
> * arduino-builder directory is available through `ARDUINO_BUILDER` environment variable.

```Makefile
PROJ_NAME := blink
PROJ_TYPE := app

include $(ARDUINO_BUILDER)/builder.mk
include $(CPB_DIR)/project.mk
```
