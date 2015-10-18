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
Returns number of bytes returned.  Data is returned by modifying buffer. Function does not return until all bytes have been received or timeout.

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
FT_EE_Program(ft_handle, programdata)		# write back to device
```
Type FtProgramData mirrors FTD2XX's FT_PROGRAM_DATA_STRUCTURE converting pointers to julia strings. See [FTDI's documentation](http://www.ftdichip.com/Support/Documents/ProgramGuides/D2XX_Programmer's_Guide%28FT_000071%29.pdf) for a complete description of FT_PROGRAM_DATA_STRUCTURE and associated constants.

### FT_EE_UASize(*ft_handle::Culong*)
Returns the size of the user EEPROM area in bytes.

### FT_EE_UARead!(*ft_handle::Culong, buffer::Array{UInt8,1}*)
Reads length(buffer) bytes of the user EEPROM into buffer.  Returns number of bytes read.

### FT_EE_UAWrite(*ft_handle::Culong, buffer::Array{UInt8,1}*)
Writes buffer to user EEPROM.  length(buffer) must be less than or equal to the size of the EEPROM user area.

### FT_SetLatencyTimer(*ft_handle::Culong, timer::Integer*)
Sets time in milliseconds to wait before flushing the receive buffer.

### FT_GetLatencyTimer(*ft_handle::Culong*)
Returns the value of the latency timer in milliseconds.

### FT_SetBitMode(*ft_handle::Culong, mask::UInt8, mode::UInt8*)
Sets bit mode and bit mask.  Bit mask determines which bits are inputs and outputs.

The following constants are exported:
```julia
const FT_BITMODE_RESET = 0x00 
const FT_BITMODE_ASYNC_BITBANG = 0x01 
const FT_BITMODE_MPSSE = 0x02 
const FT_BITMODE_SYNC_BITBANG = 0x04 
const FT_BITMODE_MCU_HOST = 0x08 
const FT_BITMODE_FAST_SERIAL = 0x10
const FT_BITMODE_CBUS_BITBANG = 0x20 
const FT_BITMODE_SYNC_FIFO = 0x40
```
### FT_GetBitMode(*ft_handle::Culong*)
Returns the bit mode.

### FT_SetUSBParameters(*ft_handle::Culong, intransfersize::Integer = 4096, outtransfersize::Integer = 4096*)
Sets the USB input and output transfer size.  Must be a multiple of 64 between 64 and 64k.

## Functions Only Defined for OSX and Linux 
### FT_GetVIDPID()
Return tuple (vid,pid) of vendor id and product id.

### FT_SetVIDPID(*vid,pid*)
Adds the vendor id and product id to the table of vid's and pid's the driver will work with.

## Functions Only Defined for Windows
### FT_GetDriverVersion(*ft_handle::Culong*)
Returns driver version as a julia VersionNumber.

### FT_GetLibraryVersion()
Returns the version of the dll as a julia VersionNumber.

### FT_GetComPortNumber(*ft_handle::Culong*)
Returns com port number where device is attached.

### FT_ResetPort(*ft_handle::Culong*)

### FT_CyclePort(*ft_handle::Culong*)

### FT_ResetDevice(*ft_handle::Culong*)

### FT_Reload(*vid::Integer, pid::Integer*)

### FT_SetResetPipeRetryCount(ft_handle::Culong, count::Integer)

### FT_EEPROM_Read(*ft_handle::Culong, eepromdata::eeprom*)
Read data from EEPROM into a device specific type.  Returns tuple (eepromdata, mfg, mfgid, description, serialnumber).  Note this function also overwrites the eepromdata passed as a parameter.  

### FT_EEPROM_Program(*ft_handle::Culong, eepromdata::eeprom, mfg::ASCIIString,mfgid::ASCIIString, description::ASCIIString, serialnumber::ASCIIString*)
Write data in a device specific type to EEPROM.

The device specific types are ft_eeprom_232b, ft_eeprom_2232, ft_eeprom_232r, ft_eeprom_2232h, ft_eeprom_4232h, ft_eeprom_232h, ft_eeprom_x_series.  Constructors for these types set the deviceType field to the appropriate constant, leaving the rest of the structure uninitialized.

The constants are:
```julia
  const FT_DEVICE_232BM = 0 	# for type ft_eeprom_232b
  const FT_DEVICE_232AM = 1 	# discontinued device
  const FT_DEVICE_100AX = 2 	# discontinued device
  const FT_DEVICE_UNKNOWN = 3
  const FT_DEVICE_2232C = 4 	# for type ft_eeprom_2232
  const FT_DEVICE_232R = 5 		# for type ft_eeprom_232r
  const FT_DEVICE_2232H = 6 	# for type ft_eeprom_2232h
  const FT_DEVICE_4232H = 7 	# for type ft_eeprom_4232h
  const FT_DEVICE_232H = 8 		# for type ft_eeprom_232h
  const FT_DEVICE_X_SERIES = 9 	# for type ft_eeprom_x_series
```

Example usage:
```julia
# assumes device with handle h is open
(eepromdata,mfg,mfgid,d,sn) = FT_EEPROM_Read(h,ft_eeprom_232h()) # read EEPROM
eepromdata.PowerSaveEnable = 0x00  # change a parameter 
FT_EEPROM_Program(h,eepromdata,mfg,mfgid,d,sn) # write back to device
```





