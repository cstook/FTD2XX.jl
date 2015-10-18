# Additional Information for Linux

As per [FTDI Drivers Installation Guide for Linux](http://www.ftdichip.com/Support/Documents/AppNotes/AN_220_FTDI_Drivers_Installation_Guide_for_Linux%20.pdf) the VCP driver must be unloaded.
```
sudo rmmod ftdi_sio
sudo rmmod usbserial
```

You may find it nessessary to run julia as root.
```
sudo julia
```

The following links may also be helpfull.

https://www.ikalogic.com/ftdi-d2xx-linux-overcoming-big-problem/

http://www.linuxforums.org/forum/programming-scripting/112331-usb-ftdi-d2xx-drivers.html

https://kenai.com/projects/javaftd2xx/pages/Home

