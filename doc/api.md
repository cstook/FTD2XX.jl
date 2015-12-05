#FTD2XX.jl API

For complete documentation see [D2XX Programer's Guide](http://www.ftdichip.com/Support/Documents/ProgramGuides/D2XX_Programmer's_Guide%28FT_000071%29.pdf)

## Functions Available On All Operating Systems
### ft_createdeviceinfolist()
Returns number of devices.

### ft_getdeviceinfolist(*numberofdevices::Integer = ft_createdeviceinfolist()*)
Returns device information list.  Device information list is an array of type FtDeviceListInfoNode.  The fields of FtDeviceListInfoNode are flags, devicetype, id, locid, serialnumber,description, handle.

Example:
```julia
deviceinformationlist = ft_getdeviceinfolist()
```

### ft_open(*deviceindex::Integer*)
Returns handle to device.  Device indexes start at zero.

### ft_openex(*locid::Unsigned*)
### ft_openex(*serialnumber::FT_SerialNumber*)
### ft_openex(*description::FT_Description*)
Returns handle to device.  ft_openex allows devices to be opened by location id, serial number or description.

Example:
```julia
ft_handle = ft_openex(0x0314)  # open by location
ft_handle = ft_openex(FT_SerialNumber("FTXRNZUJ")) # open by serial number
ft_handle = ft_openex(FT_Description("C232HM-EDHSL-0")) # open by description
```

### ft_close(*ft_handle::Culong*)
Closes device with handle ft_handle.

### ft_read!(*ft_handle::Culong, buffer::Array{UInt8,1}, bytestoread::Integer*)
Returns number of bytes returned.  Data is returned by modifying buffer. Function does not return until all bytes have been received or timeout.

### ft_write(*ft_handle::Culong, buffer::Array{UInt8,1}, bytestowrite::Integer*)
### ft_write(*ft_handle::Culong, buffer::Array{UInt8,1}*)
Returns number of bytes written.  If bytestowrite is unspecified it is assumed to be the length of the buffer.

### ft_setbaudrate(*ft_handle::Culong, baud::Integer*)
Sets the baud rate.

### ft_setdatacharacteristics(*ft_handle::Culong, wordlength::Integer, stopbits::Integer, parity::Integer*)
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

### ft_settimeouts(*ft_handle::Culong, readtimeout::Integer, writetimeout::Integer*)
Sets read and write timeouts in milliseconds.

### ft_setflowcontrol(*ft_handle::Culong, flowcontrol::Integer,xon::UInt8 = 0x11, xoff::UInt8 = 0x13*)
Sets flow control and xon and xoff characters.

The following constants are exported:
```julia
#Flow Control
const FT_FLOW_NONE = 0x0000 
const FT_FLOW_RTS_CTS = 0x0100 
const FT_FLOW_DTR_DSR = 0x0200 
const FT_FLOW_XON_XOFF = 0x0400
```

### ft_setdtr(*ft_handle::Culong*)
Sets DTR.

### ft_clrdtr(*ft_handle::Culong*)
Clears DTR.

### ft_setrts(*ft_handle::Culong*)
Sets RTS.

### ft_clrrts(*ft_handle::Culong*)
Clears RTS.

### ft_getmodemstatus(*ft_handle::Culong*)
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

### ft_getqueuestatus(*ft_handle::Culong*)
Returns number of bytes in Rx queue.

### ft_getdeviceinfo(*ft_handle::Culong*)
Returns tuple (devicetype, deviceid, serialnumber, description)

### ft_seteventnotification(*ft_handle::Culong, event_mask::Integer, event_handle::Culong*)
Sets condition for event notification.

The following constants are exported:
```julia
# Notification Events
const FT_EVENT_RXCHAR = 1 
const FT_EVENT_MODEM_STATUS = 2 
const FT_EVENT_LINE_STATUS = 4
```

### ft_getstatus(*ft_handle::Culong*)
Returns tuple (bytesinrxqueue, bytesintxqueue, eventstatus)

### ft_setchars(*ft_handle::Culong, eventch::UInt8, eventchen::Bool, errorch::UInt8, errorchen::Bool*)
Sets and enables event and error characters.

### ft_setbreakon(*ft_handle::Culong*)
Sets the break condition for the device.

### ft_setbreakoff(*ft_handle::Culong*)
Resets the break condition for the device.

### ft_purge(*ft_handle::Culong, mask::Integer*)
Purge Tx and Rx buffers.

The following constants are exported:
```julia
const FT_PURGE_RX = 1 
const FT_PURGE_TX = 2
```

### ft_resetdevice(*ft_handle::Culong*)
Sends reset command to device.

### ft_stopintask(*ft_handle::Culong*)
Puts drivers in task into a wait state.

### ft_restartintask(*ft_handle::Culong*)
Restarts the driver's in task.

### ft_setdeadmantimeout(*ft_handle::Culong, deadmantimeout::Integer = 5000*)
Sets deadman timeout in milliseconds.

### ft_readee(*ft_handle::Culong, wordoffset::Integer*)
Returns word (16bits) in EEPROM at wordoffset.

### ft_writeee(*ft_handle::Culong, wordoffset::Integer, value::UInt16*)
Writes a value to EEPROM at wordoffset.

###ft_eraseee(*ft_handle::Culong*)
Erase the device EEPROM.

### ft_ee_read(*ft_handle::Culong, version::Integer = 5*)
Returns type FtProgramData.

### ft_ee_program(*ft_handle::Culong, pd::FtProgramData*)
Programs device EEPROM with FtProgramData.

Example:
```julia
# assumes device with ft_handle has been opened.
programdata = ft_ee_read(ft_handle)  		# read the program data
programdata.Description = "NewDescription"  # change a value
ft_ee_program(ft_handle, programdata)		# write back to device
```
Type FtProgramData mirrors FTD2XX's FT_PROGRAM_DATA_STRUCTURE converting pointers to julia strings. See [FTDI's documentation](http://www.ftdichip.com/Support/Documents/ProgramGuides/D2XX_Programmer's_Guide%28FT_000071%29.pdf) for a complete description of FT_PROGRAM_DATA_STRUCTURE and associated constants.

### ft_ee_uasize(*ft_handle::Culong*)
Returns the size of the user EEPROM area in bytes.

### ft_ee_uaread!(*ft_handle::Culong, buffer::Array{UInt8,1}*)
Reads length(buffer) bytes of the user EEPROM into buffer.  Returns number of bytes read.

### ft_ee_uawrite(*ft_handle::Culong, buffer::Array{UInt8,1}*)
Writes buffer to user EEPROM.  length(buffer) must be less than or equal to the size of the EEPROM user area.

### ft_setlatencytimer(*ft_handle::Culong, timer::Integer*)
Sets time in milliseconds to wait before flushing the receive buffer.

### ft_getlatencytimer(*ft_handle::Culong*)
Returns the value of the latency timer in milliseconds.

### ft_setbitmode(*ft_handle::Culong, mask::UInt8, mode::UInt8*)
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
### ft_getbitmode(*ft_handle::Culong*)
Returns the bit mode.

### ft_setusbparameters(*ft_handle::Culong, intransfersize::Integer = 4096, outtransfersize::Integer = 4096*)
Sets the USB input and output transfer size.  Must be a multiple of 64 between 64 and 64k.

## Functions Only Defined for OSX and Linux 
### ft_getvidpid()
Return tuple (vid,pid) of vendor id and product id.

### ft_setvidpid(*vid,pid*)
Adds the vendor id and product id to the table of vid's and pid's the driver will work with.

## Functions Only Defined for Windows
### ft_getdriverversion(*ft_handle::Culong*)
Returns driver version as a julia VersionNumber.

### ft_getlibraryversion()
Returns the version of the dll as a julia VersionNumber.

### ft_getcomportnumber(*ft_handle::Culong*)
Returns com port number where device is attached.

### ft_resetport(*ft_handle::Culong*)

### ft_cycleport(*ft_handle::Culong*)

### ft_resetdevice(*ft_handle::Culong*)

### ft_reload(*vid::Integer, pid::Integer*)

### ft_setresetpiperetrycount(ft_handle::Culong, count::Integer)

### ft_eeprom_read(*ft_handle::Culong, eepromdata::eeprom*)
### ft_eeprom_read(*ft_handle::Culong*)
Read data from EEPROM into a device specific type.  Returns tuple (eepromdata, mfg, mfgid, description, serialnumber).  The second form, passing only ft_handle is perfered.  Note if passed as a parameter, eepromdata is overwritten.  

### ft_eeprom_program(*ft_handle::Culong, eepromdata::eeprom, mfg::ASCIIString,mfgid::ASCIIString, description::ASCIIString, serialnumber::ASCIIString*)
Write data in a device specific type to EEPROM.

The device specific types are Fteeprom232b, Fteeprom2232, Fteeprom232r, Fteeprom2232h, Fteeprom4232h, Fteeprom232h, Fteepromxseries.  Constructors for these types set the deviceType field to the appropriate constant, leaving the rest of the structure uninitialized.

The deviceType constants are:
```julia
  const FT_DEVICE_232BM = 0 	# for type Fteeprom232b <: Eeprom
  const FT_DEVICE_232AM = 1 	# discontinued device
  const FT_DEVICE_100AX = 2 	# discontinued device
  const FT_DEVICE_UNKNOWN = 3
  const FT_DEVICE_2232C = 4 	# for type Fteeprom2232 <: Eeprom
  const FT_DEVICE_232R = 5 		# for type Fteeprom232r <: Eeprom
  const FT_DEVICE_2232H = 6 	# for type Fteeprom2232h <: Eeprom
  const FT_DEVICE_4232H = 7 	# for type Fteeprom4232h <: Eeprom
  const FT_DEVICE_232H = 8 		# for type Fteeprom232h <: Eeprom
  const FT_DEVICE_X_SERIES = 9 	# for type Fteepromxseries <: Eeprom
```

Example:
```julia
# assumes device with handle h is open and is device type FT_DEVICE_232H
(eepromdata,mfg,mfgid,d,sn) = ft_eeprom_read(h) # read EEPROM, autodetect type
eepromdata.PowerSaveEnable = 0x00  # change a parameter 
ft_eeprom_program(h,eepromdata,mfg,mfgid,d,sn) # write back to device

# you can specify the device type.  It will autodetect if not incuded.
(eepromdata,mfg,mfgid,d,sn) = ft_eeprom_read(h,Fteeprom232h()) # read EEPROM
```
