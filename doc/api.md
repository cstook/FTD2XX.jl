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
### FT_OpenEx(*serialnumber::FT_SerialNumber*)
### FT_OpenEx(*description::FT_Description*)
Returns handle to device.  FT_OpenEx allows devices to be opened by location id, serial number or description.

for example:
```julia
ft_handle = FT_OpenEx(0x0314)  # open by location
ft_handle = FT_OpenEx(FT_SerialNumber("FTXRNZUJ")) # open by serial number
ft_handle = FT_OpenEx(FT_Description("C232HM-EDHSL-0")) # open by description
```

### FT_Close(*ft_handle::Culong*)
Closes device with handle ft_handle.

### FT_Read!(*ft_handle::Culong, buffer::Array{UInt8,1}, bytestoread::Integer*)
Returns number of bytes returned.  Data is returned by modifying buffer. Function does not return until bytes have beed received or timeout.

### FT_Write(*ft_handle::Culong, buffer::Array{UInt8,1}, bytestowrite::Integer*)
### FT_Write(*ft_handle::Culong, buffer::Array{UInt8,1}*)
Returns number of bytes written.  If bytestowrite is unspecified it is assumed to be the length of the buffer.

### FT_SetBaudRate(*ft_handle::Culong, baud::Integer*)
Sets the baud rate.

### FT_SetDataCharacteristics(*ft_handle::Culong, wordlength::Integer, stopbits::Integer, parity::Integer*)
Sets word length, stop bits and parity.

the following constants are exported for use with this function:
```julia
#Word Length
const FT_BITS_8 = 8 
const FT_BITS_7 = 7

#Stop Bits
const FT_STOP_BITS_1 = 0 
const FT_STOP_BITS_2 = 2

#Parity
const FT_PARITY_NONE = 0 
const FT_PARITY_ODD = 1 
const FT_PARITY_EVEN = 2 
const FT_PARITY_MARK = 3 
const FT_PARITY_SPACE = 4
```

### FT_SetTimeouts(*ft_handle::Culong, readtimeout::Integer, writetimeout::Integer*)
Sets read and write timeouts in milliseconds.

### FT_SetFlowControl(*ft_handle::Culong, flowcontrol::Integer,xon::UInt8 = 0x11, xoff::UInt8 = 0x13*)
Sets flow control and xon and xoff characters.

The following constants are exported:
```julia
#Flow Control
const FT_FLOW_NONE = 0x0000 
const FT_FLOW_RTS_CTS = 0x0100 
const FT_FLOW_DTR_DSR = 0x0200 
const FT_FLOW_XON_XOFF = 0x0400
```

### FT_SetDtr(*ft_handle::Culong*)
Sets DTR.

### FT_ClrDtr(*ft_handle::Culong*)
Clears DTR.

### FT_SetRts(*ft_handle::Culong*)
Sets RTS.

### FT_ClrRts(*ft_handle::Culong*)
Clears RTS.

### FT_GetModemStatus(*ft_handle::Culong*)
Returns modem status.

The following constants are exported:
```julia
#Modem Status (least significant byte)
const CTS = 0x10 
const DSR = 0x20 
const RI = 0x40 
const DCD = 0x80

#Line Status (second least significant byte) 
const OE = 0x02 
const PE = 0x04 
const FE = 0x08 
const BI = 0x10
```

### FT_GetQueueStatus(*ft_handle::Culong*)
Returns number of bytes in Rx queue.

### FT_GetDeviceInfo(*ft_handle::Culong*)
Returns tuple (devicetype, deviceid, serialnumber, description)

### FT_SetEventNotification(*ft_handle::Culong, event_mask::Integer, event_handle::Culong*)
Sets condition for event notification.

The following constants are exported:
```julia
# Notification Events
const FT_EVENT_RXCHAR = 1 
const FT_EVENT_MODEM_STATUS = 2 
const FT_EVENT_LINE_STATUS = 4
```

### FT_GetStatus(*ft_handle::Culong*)
Returns tuple (bytesinrxqueue, bytesintxqueue, eventstatus)

### FT_SetChars(*ft_handle::Culong, eventch::UInt8, eventchen::Bool, errorch::UInt8, errorchen::Bool*)
Sets and enables event and error characters.

### FT_SetBreakOn(*ft_handle::Culong*)
Sets the break condition for the device.

### FT_SetBreakOff(*ft_handle::Culong*)
Resets the break condition for the device.

### FT_Purge(*ft_handle::Culong, mask::Integer*)
Purge Tx and Rx buffers.

The following constants are exported:
```julia
const FT_PURGE_RX = 1 
const FT_PURGE_TX = 2
```

### FT_ResetDevice(*ft_handle::Culong*)
Sends reset command to device.

### FT_StopInTask(*ft_handle::Culong*)
Puts drivers in task into a wait state.

### FT_RestartInTask(*ft_handle::Culong*)
Restarts the driver's in task.

### FT_SetDeadmanTimeout(*ft_handle::Culong, deadmantimeout::Integer = 5000*)
Sets deadman timeout in milliseconds.

### FT_ReadEE(*ft_handle::Culong, wordoffset::Integer*)
Returns word (16bits) in EEPROM at wordoffset.

### FT_WriteEE(*ft_handle::Culong, wordoffset::Integer, value::UInt16*)
Writes a value to EEPROM at wordoffset.

### FT_EraseEE(*ft_handle::Culong*)
Erase the device EEPROM.

### FT_EE_Read(*ft_handle::Culong, version::Integer = 5*)
Returns type FtProgramData.

### FT_EE_Program(*ft_handle::Culong, pd::FtProgramData*)
Programs device EEPROM with FtProgramData.

For Example:
```julia
# assumes device with ft_handle has been opened.
programdata = FT_EE_Read(ft_handle)  		# read the program data
programdata.Description = "NewDescription"  # change a value
FT_EE_Program(programdata)					# write back to device
```
FtProgramData mirrors FTD2XX's FT_PROGRAM_DATA_STRUCTURE converting pointers to julia strings. See [FTDI's documentation](http://www.ftdichip.com/Support/Documents/ProgramGuides/D2XX_Programmer's_Guide%28FT_000071%29.pdf) for a complete description of FT_PROGRAM_DATA_STRUCTURE and associated constants.

