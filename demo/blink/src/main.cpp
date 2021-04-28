/*
    This file is part of arduino-gcc-project-builder.
    Copyright (C) 2021 Leandro José Britto de Oliveira

    arduino-gcc-project-builder is free software: you can redistribute it
    and/or modify it under the terms of the GNU General Public License as
    published by the Free Software Foundation, either version 2 of the
    License, or (at your option) any later version.

    arduino-gcc-project-builder is distributed in the hope that it will be
    useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with arduino-gcc-project-builder.  If not, 
    see <https://www.gnu.org/licenses/>
*/
#include <arduino/Arduino.h>

void setup() {
	pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
	static bool state = false;
	digitalWrite(LED_BUILTIN, state ? LOW : HIGH);
	state = !state;
	delay(100);
}

