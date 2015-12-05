# FTD2XX.jl

[![Build Status](https://travis-ci.org/cstook/FTD2XX.jl.svg?branch=master)](https://travis-ci.org/cstook/FTD2XX.jl)

FTD2XX.jl is a thin wrapper for [FTDI](http://www.ftdichip.com)'s [D2XX](http://www.ftdichip.com/Drivers/D2XX.htm) driver.

##Installation

FTD2XX.jl is currently unregistered.  It can be installed using ```Pkg.clone```.
```julia
Pkg.clone("https://github.com/cstook/FTD2XX.jl.git")
```
The [julia documentation](http://docs.julialang.org) section on installing unregistered [packages](http://docs.julialang.org/en/release-0.4/manual/packages/#packages) provides more information.

## UART quick start

The UART may be accessed as a type IOftuart <: IO

get information about devices

```julia
device_infomation_list = ft_getdeviceinfolist()
```

open a device.
```julia
io = open(FT_SerialNumber("FTXRNZUJ"),9600,8,1,"n") # open by serial number
```
or
```julia
io = open(FT_Description("C232HM-EDHSL-0"),9600,8,1,"n") # open by description
```
or
```julia
io = open(FT_Location(0x000001a2),9600,8,1,"n") # open by location
```
or
```julia
io = open(FT_DeviceIndex(0),9600,8,1,"n") # open by device index
```
use all the normal IO functions
```julia
write(io, 0x55)
byteread = read(io, UInt8)
```
close the device
```julia
close(io)
```

## Documentation
[API for this wrapper](https://github.com/cstook/FTD2XX.jl/blob/master/doc/api.md)

[FTDI website](http://www.ftdichip.com)

[D2XX Programmer's Guide (from FTDI)](http://www.ftdichip.com/Support/Documents/ProgramGuides/D2XX_Programmer's_Guide%28FT_000071%29.pdf)


##OS Compatibility

FTD2XX.jl is compatible with windows, linux, and osx.  See FTDI's [installation guides](http://www.ftdichip.com/Support/Documents/InstallGuides.htm) for instructions on installing drivers for your operating system.  Drivers are assumed to be installed in the default locations.

[Additional Information for Linux](https://github.com/cstook/FTD2XX.jl/blob/master/doc/AdditionalInformationforLinux.md)

## To Do

I2C as an array.

SPI, JTAG as readdata = writeread(datatowrite)