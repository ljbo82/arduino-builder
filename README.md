# arduino-builder

This project provides additional host layers (targeting arduino boards) to be used by a project using [cpp-project-builder](https://github.com/ljbo82/cpp-project-builder).

> **NO OFFICIAL RELEASE YET**
>
> arduino-builder is still under development and there is no official releases yet!

## License

arduino-builder is distributed under MIT License. Please see the [LICENSE](LICENSE) file for details on copying and distribution.

## Example usage

Here is an example Makefile which uses [cpp-project-builder](https://github.com/ljbo82/cpp-project-builder) with provided arduino layers.

> **Assumptions**
>
> * cpp-project-builder directory is available through `CPP_PROJECT_BUILDER` environment variable.
> * arduino-builder directory is available through `ARDUINO_BUILDER` environment variable.

```Makefile
PROJ_NAME := blink
PROJ_TYPE := app

include $(ARDUINO_BUILDER)/layers.mk
include $(CPP_PROJECT_BUILDER)/builder.mk
```
