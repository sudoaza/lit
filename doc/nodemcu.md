# Setting up NodeMcu (ESP8266) with lua scripts

# Get the firmware

[Download a build](https://nodemcu-build.com/) or [Build your own](http://www.esp8266.com/wiki/doku.php?id=toolchain#how_to_setup_a_vm_to_host_your_toolchain)

# Flash the firmware

There are several tools for different platforms, for GNU/Linux we have [esptool](https://github.com/espressif/esptool/)

    esptool.py --port /dev/ttyUSB0 write_flash 0x00000 firmware.bin

# Connect to lua console

    picocom /dev/ttyUSB0 --b 115200 --omap crcrlf --imap crcrlf

or

    bin/tty

# Upload lua scripts

There are again several tools, [luatool](https://github.com/4refr0nt/luatool)
is simple enough.

    luatool/luatool.py -f init.lua -p /dev/ttyUSB0

or

  bin/send_lua init.lua

# Crashes and hangs

If you enter a loop or get repeated crashes you may be unable to upload a new
script and need to re-flash the firmware. To avoid this init.lua should have a
timer that waits a few seconds after booting. The command `bin/pause` will 
upload wait.lua as init.lua to pause execution of the broken script and allow
you to upload the new one.
