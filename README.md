# LCD20x4

This is LCD20x4 driver written in swift 5.

Add the line below into Package.swift:

.package(url: "https://github.com/carlhung/LCD20x4_i2c.git", .branch("master"))

and also add "LCD20x4" in dependencies.



wiring:

raspberry's pin <-> LCD's pin

SDA <-> SDA

SLC <-> SLC

5V <-> VCC

GND <-> GND


I know raspberry pi's GPIO pins run on 3.3v

But i2c's pins can run on different voltage.

I haven't tested on pi zero yet.
