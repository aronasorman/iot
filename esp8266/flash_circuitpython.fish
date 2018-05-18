#!/usr/bin/env fish

set version 2.2.4
set url https://github.com/adafruit/circuitpython/releases/download/$version/adafruit-circuitpython-feather_huzzah-$version.bin
set bindest /tmp/circuitpython-feather-huzzah-$version.bin
set port /dev/tty.SLAB_USBtoUART

function ensure_esptool -d "make sure the esptool.py tool is installed"
    if which esptool.py > /dev/null
        echo esptool already installed!
    else
        echo esptool not found, installing...
        pip install esptool
    end
end

function download_firmware
    echo Downloading $url.
    curl $url -L -o $bindest
    echo Downloaded circuitpython bin to $bindest.
end

function erase_flash
    echo Erasing flash.
    esptool.py --port $port erase_flash
end

function flash_firmware
    echo Flashing firmware.
    esptool.py --port $port --baud 115200 write_flash --flash_size=detect 0 $bindest
    echo Done! Connect to the REPL by running
    echo screen $port 115200
end

ensure_esptool
download_firmware
erase_flash
flash_firmware