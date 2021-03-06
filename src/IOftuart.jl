# create IOftuart

export FT_Location, FT_DeviceIndex, purge, UARTConfiguration, setlatencytimer


type IOftuart <: IO
  ft_handle  :: Culong
  readbuffer :: Array{UInt8,1}
  writebuffer :: Array{UInt8,1}
  rxbytesreturnedbuffer :: Array{Cuint,1}
  txbytesreturnedbuffer :: Array{Cuint,1}
  IOftuart(x) = new(x,Array(UInt8,1),Array(UInt8,1), Array(Cuint,1), Array(Cuint,1))
end

function Base.show(io::IO, x::IOftuart)
  print(io,"FTD2XX.IOftuart.ft_handle(")
  if handleis32
    @printf(io,"0x%08x",x.ft_handle)
  else
    @printf(io,"0x%16x",x.ft_handle)
  end
  println(io,")")
  return nothing
end

gethandle(io::IOftuart) = io.ft_handle

immutable FT_Location
  location :: Unsigned
end

immutable FT_DeviceIndex
  deviceindex :: Unsigned
end

immutable UARTConfiguration
  baud :: Cuint
  bits :: UInt8
  stop :: UInt8
  parity :: UInt8
  readtimeout :: Cuint
  writetimeout :: Cuint
  flowcontrol  :: Cushort
  xon :: UInt8
  xoff :: UInt8
  function UARTConfiguration(baud::Integer = 9600,
                             bits_user::Integer = 8,
                             stop_user::Integer = 1,
                             parity_user = 'n';
                             readtimeout::Integer = 100,  # in milliseconds
                             writetimeout::Integer = 100, # in milliseconds
                             flowcontrol = "none",
                             xon::UInt8 = 0x11,
                             xoff::UInt8 = 0x13)
    if bits_user == 8 
      bits = FT_BITS_8
    elseif bits_user == 7
      bits = FT_BITS_7
    else
      error("ERROR: UART config bits must be 7 ot 8")
    end
    if stop_user == 1
      stop = FT_STOP_BITS_1
    elseif stop_user == 2
      stop = FT_STOP_BITS_2
    else
      error("ERROR: UART config stop bits must be 1 or 2")
    end
    upper_parity_user = uppercase(parity_user)
    if in(upper_parity_user,Set(['N',"N","NONE","FT_PARITY_NONE"]))
      parity = FT_PARITY_NONE
    elseif in(upper_parity_user,Set(['O',"O","ODD","FT_PARITY_ODD"]))
      parity = FT_PARITY_ODD
    elseif in(upper_parity_user,Set(['E',"E","EVEN","FT_PARITY_EVEN"]))
      parity = FT_PARITY_EVEN
    elseif in(upper_parity_user,Set(['M',"M","MARK","FT_PARITY_MARK"]))
      parity = FT_PARITY_MARK
    elseif in(upper_parity_user,Set(['S',"S","SPACE","FT_PARITY_SPACE"]))
      parity = FT_PARITY_SPACE
    else
      error("ERROR: UART config parity must be n, o, e, m or s")
    end
    upper_flowcontrol = uppercase(flowcontrol)
    if in(upper_flowcontrol,Set(['N',"N","NONE","FT_FLOW_NONE"]))
      flowcontrol = FT_FLOW_NONE
    elseif in(upper_flowcontrol,Set(['R',"R","RTS_CTS","FT_FLOW_RTS_CTS"]))
      flowcontrol = FT_FLOW_RTS_CTS
    elseif in(upper_flowcontrol,Set(['D',"D","DTR_DSR","FT_FLOW_DTR_DSR"]))
      flowcontrol = FT_FLOW_DTR_DSR
    elseif in(upper_flowcontrol,Set(['X',"X","XON_XOFF","FT_FLOW_XON_XOFF"]))
      flowcontrol = FT_FLOW_XON_XOFF
    else
      error("ERROR: UART config flow control must be n, r, d or x")
    end
    new(baud, bits, stop, parity, readtimeout, writetimeout, flowcontrol, xon, xoff)
  end
end

function configureuart(io::IOftuart, config :: UARTConfiguration)
  ft_setbitmode(io.ft_handle, 0x00, FT_BITMODE_RESET)  #  make sure configured for UART
  ft_setbaudrate(io.ft_handle, config.baud)
  ft_setdatacharacteristics(io.ft_handle, config.bits, config.stop, config.stop)
  ft_setflowcontrol(io.ft_handle, config.flowcontrol, config.xon, config.xoff)
  ft_settimeouts(io.ft_handle, config.readtimeout, config.writetimeout)
  return nothing
end

function Base.open(device::FT_DeviceIndex, config::UARTConfiguration)
  io = IOftuart(ft_open(device.deviceindex))
  configureuart(io, config)
  finalizer(io,close)
  return io
end

function Base.open(device::FT_Location, config::UARTConfiguration)
  io = IOftuart(ft_openex(device.location))
  configureuart(io, config)
  finalizer(io,close)
  return io
end

function Base.open(device::Union{FT_SerialNumber,FT_Description}, config::UARTConfiguration)
  io = IOftuart(ft_openex(device))
  configureuart(io, config)
  finalizer(io,close)
  return io
end

function Base.open(device::Union{FT_DeviceIndex, FT_Location, FT_SerialNumber, FT_Description},
                   baud::Integer = 9600,
                   bits_user::Integer = 8,
                   stop_user::Integer = 1,
                   parity_user = 'n')
  open(device, UARTConfiguration(baud, bits_user, stop_user, parity_user))
end

function Base.close(io::IOftuart)
  if io.ft_handle != 0
    ft_close(io.ft_handle)
    io.ft_handle = 0
  end
  return nothing
end

Base.isopen(io::IOftuart) = io.ft_handle!=0
Base.isreadable(io::IOftuart) = isopen(io)
Base.iswritable(io::IOftuart) = isopen(io)

function ft_read!(io::IOftuart,
                 buffer::Array{UInt8,1},
                 bytestoread::Integer = length(buffer))
  ft_status = ccall((:FT_Read, d2xx),
                      Cuint,
                      (Culong, Ptr{UInt8}, Cuint, Ptr{Cuint}),
                      io.ft_handle, buffer, bytestoread, io.rxbytesreturnedbuffer)
  checkstatus(ft_status) 
  return (io.rxbytesreturnedbuffer[1])
end

function Base.read(s::IOftuart, ::Type{UInt8})
  ft_read!(s, s.readbuffer, 1)
  return s.readbuffer[1]
end

function Base.read!(s::IOftuart, a::Vector{UInt8})
  bytesread = ft_read!(s, a)
  return a  # IO retruns the data not bytes read?
end

function ft_write(io::IOftuart,
                  buffer::Array{UInt8,1},
                  bytestowrite::Integer = length(buffer))
  ft_status = ccall((:FT_Write, d2xx),
                     Cuint,
                     (Culong, Ptr{UInt8}, Cuint, Ptr{Cuint}),
                     io.ft_handle, buffer, bytestowrite, io.txbytesreturnedbuffer)
  checkstatus(ft_status)
  return io.txbytesreturnedbuffer[1]
end

function Base.write(s::IOftuart, x::UInt8)
  s.writebuffer[1] = x
  byteswritten = ft_write(s.ft_handle, s.writebuffer, 1)
end

function Base.write(s::IOftuart, x::Vector{UInt8})
  byteswritten = ft_write(s, x, length(x))
end

function purge(io::IOftuart)
  ft_purge(io.ft_handle, FT_PURGE_RX | FT_PURGE_TX)
end

function setlatencytimer(io::IOftuart, latencyms::Integer)
  ft_setlatencytimer(io.ft_handle, latencyms)
end

Base.eof(io::IOftuart) = false