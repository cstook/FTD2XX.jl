# FTD2XX.jl

[![Build Status](https://travis-ci.org/cstook/FTD2XX.jl.svg?branch=master)](https://travis-ci.org/cstook/FTD2XX.jl)

FTD2XX.jl is a thin wrapper for [FTDI](http://www.ftdichip.com)'s [D2XX](http://www.ftdichip.com/Drivers/D2XX.htm) driver.

##Installation

FTD2XX.jl is currently unregistered.  It can be installed using ```Pkg.clone```.
```julia
Pkg.clone("https://github.com/cstook/FTD2XX.jl.git")
```
The [julia documentation](http://docs.julialang.org) section on installing unregistered [packages](http://docs.julialang.org/en/release-0.4/manual/packages/#packages) provides more information.

##OS Compatibility

FTD2XX.jl is compatible with windows, linux, and osx.  See FTDI's [installation guides](http://www.ftdichip.com/Support/Documents/InstallGuides.htm) for instructions on installing drivers for your operating system.  Drivers are assumed to be installed in the default locations.