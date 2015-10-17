#FTD2XX.jl API

For complete documentation see [D2XX Programer's Guide](http://www.ftdichip.com/Support/Documents/ProgramGuides/D2XX_Programmer's_Guide%28FT_000071%29.pdf)

## Functions Available On All Operating Systems
### FT_CreateDeviceInfoList()
Returns number of devices.

### FT_GetDeviceInfoList(*numberofdevices::Integer*)
Returns device information list.  Device information list is an array of type InfoNode.  The fields of InfoNode are flags, devicetype, id, locid, serialnumber,description, handle.

### FT_Open(*deviceindex::Integer*)
Returns handle to device.  Device indexes start at zero.

### FT_OpenEx(*locid::Unsigned*)
### FT_OpenEx(*serialnumber::FT_SerialNumber)
### FT_OpenEx(*description::FT_Description)
Returns handle to device.  FT_OpenEx allows devices to be opened by location id, serial number or description.

for example:
```julia
handle = FT_OpenEx(0x0314)  # open by location
handle = FT_OpenEx(FT_SerialNumber("FTXRNZUJ")) # open by serial number
handle = FT_OpenEx(FT_Description("C232HM-EDHSL-0"))
```
