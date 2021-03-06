export ft_eeprom_read, ft_eeprom_program
export Fteeprom232b, Fteeprom2232, Fteeprom232r
export Fteeprom2232h, Fteeprom4232h, Fteeprom232h
export Fteepromxseries

include("FT_DEVICE.jl")  # load constants

abstract Eeprom

function fteepromread_alleeprom{T<:Eeprom}(ft_handle::Culong, eepromdata::T)
  datasize = Cuint(sizeof(eepromdata))
  mfg = Array(UInt8,64); mfg[64] = 0
  mfgid = Array(UInt8,64); mfgid[64] = 0
  d = Array(UInt8,64); d[64] = 0
  sn = Array(UInt8,64); sn[64] = 0
  ee = Ref{T}(eepromdata)
  ft_status = ccall((:FT_EEPROM_Read, d2xx),
            Cuint,
            (Culong,Ref{T},Cuint,Ptr{UInt8},
              Ptr{UInt8},Ptr{UInt8},Ptr{UInt8}),
            ft_handle,ee,datasize,mfg,mfgid,d,sn)
  checkstatus(ft_status)
  mfg_string = bytestring(mfg[1:findfirst(mfg,0x00)-1])
  mfgid_string = bytestring(mfgid[1:findfirst(mfgid,0x00)-1])
  d_string = bytestring(d[1:findfirst(d,0x00)-1])
  sn_string = bytestring(sn[1:findfirst(sn,0x00)-1])
  return(eepromdata,mfg_string,mfgid_string,d_string,sn_string)
end

function fteepromprogram_alleeprom{T<:Eeprom}(ft_handle::Culong, eepromdata::T, 
          mfg_string::ASCIIString, mfgid_string::ASCIIString, 
          d_string::ASCIIString, sn_string::ASCIIString)
  datasize = sizeof(eepromdata)
  mfg = Array{UInt8,1}(mfg_string * "\0")
  mfgid = Array{UInt8,1}(mfgid_string * "\0")
  d = Array{UInt8,1}(d_string * "\0")
  sn = Array{UInt8,1}(sn_string * "\0")
  ee = Ref{T}(eepromdata)
  ft_status = ccall((:FT_EEPROM_Program, d2xx),
            Cuint,
            (Culong,Ref{T},Cuint,Ptr{UInt8},
              Ptr{UInt8},Ptr{UInt8},Ptr{UInt8}),
            ft_handle,ee,datasize,mfg,mfgid,d,sn)
  checkstatus(ft_status)
  return nothing
end

function showcommonelements(io::IO, eepromdata::Eeprom)
  f()=@printf(io,"deviceType = 0x%08x\n",eepromdata.deviceType);f()
  f()=@printf(io,"VendorId = 0x%04x\n",eepromdata.VendorId);f()
  f()=@printf(io,"ProductId = 0x%04x\n",eepromdata.ProductId);f()
  f()=@printf(io,"SerNumEnable = 0x%02x\n",eepromdata.SerNumEnable);f()
  f()=@printf(io,"MaxPower = 0x%04x\n",eepromdata.MaxPower);f()
end

# FT232B EEPROM structure for use with ft_eeprom_read and ft_eeprom_program
type Fteeprom232b <: Eeprom
  # Common header
  ### BEGIN common elements for all device EEPROMs ###
  deviceType :: Cuint # FT_DEVICE FTxxxx device type to be programmed
  # Device descriptor options
  VendorId :: Cshort # 0x0403
  ProductId :: Cshort # 0x6001
  SerNumEnable :: Cuchar # non-zero if serial number to be used
  # Config descriptor options
  MaxPower :: Cshort #  0 < MaxPower <= 500
  pad1::UInt8;pad2::UInt8;pad3::UInt8;pad4::UInt8  # needed to allign fields.  Why?
  ### END common elements for all device EEPROMs ###
  Fteeprom232b() = new(FT_DEVICE_232BM)
  Fteeprom232b(VendorId,ProductId,SerNumEnable,MaxPower) = 
    new(FT_DEVICE_232BM,VendorId,ProductId,SerNumEnable,MaxPower)
end

function Base.show(io::IO, eepromdata::Fteeprom232b)
  showcommonelements(io,eepromdata)
end

function ft_eeprom_read(ft_handle::Culong, eepromdata::Fteeprom232b)
  @assert eepromdata.deviceType == FT_DEVICE_232BM
  fteepromread_alleeprom(ft_handle,eepromdata)
end

function ft_eeprom_program(ft_handle::Culong, eepromdata::Fteeprom232b,
                            mfg_string::ASCIIString,
                            mfgid_string::ASCIIString,
                            d_string::ASCIIString,
                            sn_string::ASCIIString)
  @assert eepromdata.deviceType == FT_DEVICE_232BM
  fteepromprogram_alleeprom(ft_handle,eepromdata,mfg_string,
                  mfgid_string,d_string,sn_string)
end

# FT2232 EEPROM structure for use with ft_eeprom_read and ft_eeprom_program
type Fteeprom2232 <: Eeprom
  ### BEGIN common elements for all device EEPROMs ###
  deviceType :: Cuint # FT_DEVICE FTxxxx device type to be programmed
  # Device descriptor options
  VendorId :: Cshort # 0x0403
  ProductId :: Cshort # 0x6001
  SerNumEnable :: Cuchar # non-zero if serial number to be used
  # Config descriptor options
  MaxPower :: Cshort #  0 < MaxPower <= 500
  pad1::UInt8;pad2::UInt8;pad3::UInt8;pad4::UInt8  # needed to allign fields.  Why?
  ### END common elements for all device EEPROMs ###
  # Drive options
  AIsHighCurrent :: Cuchar # non-zero if interface is high current
  BIsHighCurrent :: Cuchar # non-zero if interface is high current
  # Hardware options
  AIsFifo :: Cuchar # non-zero if interface is 245 FIFO
  AIsFifoTar :: Cuchar # non-zero if interface is 245 FIFO CPU target
  AIsFastSer :: Cuchar # non-zero if interface is Fast serial
  BIsFifo :: Cuchar # non-zero if interface is 245 FIFO
  BIsFifoTar :: Cuchar # non-zero if interface is 245 FIFO CPU target
  BIsFastSer :: Cuchar # non-zero if interface is Fast serial
  # Driver option
  ADriverType :: Cuchar 
  BDriverType  :: Cuchar
  Fteeprom2232() = new(FT_DEVICE_2232C)
end

function Base.show(io::IO, eepromdata::Fteeprom2232)
  showcommonelements(io,eepromdata)
  f()=@printf(io,"AIsHighCurrent= 0x%02x\n",eepromdata.AIsHighCurrent);f()
  f()=@printf(io,"BIsHighCurrent= 0x%02x\n",eepromdata.BIsHighCurrent);f()
  f()=@printf(io,"AIsFifo= 0x%02x\n",eepromdata.AIsFifo);f()
  f()=@printf(io,"AIsFifoTar= 0x%02x\n",eepromdata.AIsFifoTar);f()
  f()=@printf(io,"AIsFastSer= 0x%02x\n",eepromdata.AIsFastSer);f()
  f()=@printf(io,"BIsFifo= 0x%02x\n",eepromdata.BIsFifo);f()
  f()=@printf(io,"BIsFifoTar= 0x%02x\n",eepromdata.BIsFifoTar);f()
  f()=@printf(io,"BIsFastSer= 0x%02x\n",eepromdata.BIsFastSer);f()
  f()=@printf(io,"ADriverType= 0x%02x\n",eepromdata.ADriverType);f()
  f()=@printf(io,"BDriverType= 0x%02x\n",eepromdata.BDriverType);f()
end

function ft_eeprom_read(ft_handle::Culong, eepromdata::Fteeprom2232)
  @assert eepromdata.deviceType == FT_DEVICE_2232C
  fteepromread_alleeprom(ft_handle,eepromdata)
end

function ft_eeprom_program(ft_handle::Culong, eepromdata::Fteeprom2232,
                            mfg_string::ASCIIString,
                            mfgid_string::ASCIIString,
                            d_string::ASCIIString,
                            sn_string::ASCIIString)
  @assert eepromdata.deviceType == FT_DEVICE_2232C
  fteepromprogram_alleeprom(ft_handle,eepromdata,mfg_string,
                  mfgid_string,d_string,sn_string)
end

# FT232R EEPROM structure for use with ft_eeprom_read and ft_eeprom_program
type Fteeprom232r <: Eeprom
  ### BEGIN common elements for all device EEPROMs ###
  deviceType :: Cuint # FT_DEVICE FTxxxx device type to be programmed
  # Device descriptor options
  VendorId :: Cshort # 0x0403
  ProductId :: Cshort # 0x6001
  SerNumEnable :: Cuchar # non-zero if serial number to be used
  # Config descriptor options
  MaxPower :: Cshort #  0 < MaxPower <= 500
  pad1::UInt8;pad2::UInt8;pad3::UInt8;pad4::UInt8  # needed to allign fields.  Why?
  ### END common elements for all device EEPROMs ###
  # Drive options
  IsHighCurrent :: Cuchar # non-zero if interface is high current
  # Hardware options
  UseExtOsc :: Cuchar # Use External Oscillator
  InvertTXD :: Cuchar # non-zero if invert TXD
  InvertRXD :: Cuchar # non-zero if invert RXD
  InvertRTS :: Cuchar # non-zero if invert RTS
  InvertCTS :: Cuchar # non-zero if invert CTS
  InvertDTR :: Cuchar # non-zero if invert DTR
  InvertDSR :: Cuchar # non-zero if invert DSR
  InvertDCD :: Cuchar # non-zero if invert DCD
  InvertRI :: Cuchar # non-zero if invert RI
  Cbus0 :: Cuchar # Cbus Mux control
  Cbus1 :: Cuchar # Cbus Mux control
  Cbus2 :: Cuchar # Cbus Mux control
  Cbus3 :: Cuchar # Cbus Mux control
  Cbus4 :: Cuchar # Cbus Mux control
# Driver option
  DriverType :: Cuchar #
  Fteeprom232r() = new(FT_DEVICE_232R)
end

function Base.show(io::IO, eepromdata::Fteeprom232r)
  showcommonelements(io,eepromdata)
  f()=@printf(io,"IsHighCurrent= 0x%02x\n",eepromdata.IsHighCurrent);f()
  f()=@printf(io,"UseExtOsc= 0x%02x\n",eepromdata.UseExtOsc);f()
  f()=@printf(io,"InvertTXD= 0x%02x\n",eepromdata.InvertTXD);f()
  f()=@printf(io,"InvertRXD= 0x%02x\n",eepromdata.InvertRXD);f()
  f()=@printf(io,"InvertRTS= 0x%02x\n",eepromdata.InvertRTS);f()
  f()=@printf(io,"InvertCTS= 0x%02x\n",eepromdata.InvertCTS);f()
  f()=@printf(io,"InvertDTR= 0x%02x\n",eepromdata.InvertDTR);f()
  f()=@printf(io,"InvertDSR= 0x%02x\n",eepromdata.InvertDSR);f()
  f()=@printf(io,"InvertDCD= 0x%02x\n",eepromdata.InvertDCD);f()
  f()=@printf(io,"InvertRI= 0x%02x\n",eepromdata.InvertRI);f()
  f()=@printf(io,"Cbus0= 0x%02x\n",eepromdata.Cbus0);f()
  f()=@printf(io,"Cbus1= 0x%02x\n",eepromdata.Cbus1);f()
  f()=@printf(io,"Cbus2= 0x%02x\n",eepromdata.Cbus2);f()
  f()=@printf(io,"Cbus3= 0x%02x\n",eepromdata.Cbus3);f()
  f()=@printf(io,"Cbus4= 0x%02x\n",eepromdata.Cbus4);f()
  f()=@printf(io,"DriverType= 0x%02x\n",eepromdata.DriverType);f()
end

function ft_eeprom_read(ft_handle::Culong, eepromdata::Fteeprom232r)
  @assert eepromdata.deviceType == FT_DEVICE_232R
  fteepromread_alleeprom(ft_handle,eepromdata)
end

function ft_eeprom_program(ft_handle::Culong, eepromdata::Fteeprom232r,
                            mfg_string::ASCIIString,
                            mfgid_string::ASCIIString,
                            d_string::ASCIIString,
                            sn_string::ASCIIString)
  @assert eepromdata.deviceType == FT_DEVICE_232R
  fteepromprogram_alleeprom(ft_handle,eepromdata,mfg_string,
                  mfgid_string,d_string,sn_string)
end

# FT2232H EEPROM structure for use with ft_eeprom_read and ft_eeprom_program
type Fteeprom2232h <: Eeprom
  ### BEGIN common elements for all device EEPROMs ###
  deviceType :: Cuint # FT_DEVICE FTxxxx device type to be programmed
  # Device descriptor options
  VendorId :: Cshort # 0x0403
  ProductId :: Cshort # 0x6001
  SerNumEnable :: Cuchar # non-zero if serial number to be used
  # Config descriptor options
  MaxPower :: Cshort #  0 < MaxPower <= 500
  pad1::UInt8;pad2::UInt8;pad3::UInt8;pad4::UInt8  # needed to allign fields.  Why?
  ### END common elements for all device EEPROMs ###
  # Drive options
  ALSlowSlew :: Cuchar # non-zero if AL pins have slow slew
  ALSchmittInput :: Cuchar # non-zero if AL pins are Schmitt input
  ALDriveCurrent :: Cuchar # valid values are 4mA, 8mA, 12mA, 16mA
  AHSlowSlew :: Cuchar # non-zero if AH pins have slow slew
  AHSchmittInput :: Cuchar # non-zero if AH pins are Schmitt input
  AHDriveCurrent :: Cuchar # valid values are 4mA, 8mA, 12mA, 16mA
  BLSlowSlew :: Cuchar # non-zero if BL pins have slow slew
  BLSchmittInput :: Cuchar # non-zero if BL pins are Schmitt input
  BLDriveCurrent :: Cuchar # valid values are 4mA, 8mA, 12mA, 16mA
  BHSlowSlew :: Cuchar # non-zero if BH pins have slow slew
  BHSchmittInput :: Cuchar # non-zero if BH pins are Schmitt input
  BHDriveCurrent :: Cuchar # valid values are 4mA, 8mA, 12mA, 16mA
  # Hardware options
  AIsFifo :: Cuchar # non-zero if interface is 245 FIFO
  AIsFifoTar :: Cuchar # non-zero if interface is 245 FIFO CPU target
  AIsFastSer :: Cuchar # non-zero if interface is Fast serial
  BIsFifo :: Cuchar # non-zero if interface is 245 FIFO
  BIsFifoTar :: Cuchar # non-zero if interface is 245 FIFO CPU target
  BIsFastSer :: Cuchar # non-zero if interface is Fast serial
  PowerSaveEnable :: Cuchar # non-zero if using BCBUS7 to save power for
  # self-powered designs
  # Driver option
  ADriverType :: Cuchar #   
  BDriverType :: Cuchar #
  Fteeprom2232h() = new(FT_DEVICE_2232H)
end

function Base.show(io::IO, eepromdata::Fteeprom2232h)
  showcommonelements(io,eepromdata)
  f()=@printf(io,"ALSlowSlew= 0x%02x\n",eepromdata.ALSlowSlew);f()
  f()=@printf(io,"ALSchmittInput= 0x%02x\n",eepromdata.ALSchmittInput);f()
  f()=@printf(io,"ALDriveCurrent= 0x%02x\n",eepromdata.ALDriveCurrent);f()
  f()=@printf(io,"AHSlowSlew= 0x%02x\n",eepromdata.AHSlowSlew);f()
  f()=@printf(io,"AHSchmittInput= 0x%02x\n",eepromdata.AHSchmittInput);f()
  f()=@printf(io,"AHDriveCurrent= 0x%02x\n",eepromdata.AHDriveCurrent);f()
  f()=@printf(io,"BLSlowSlew= 0x%02x\n",eepromdata.BLSlowSlew);f()
  f()=@printf(io,"BLSchmittInput= 0x%02x\n",eepromdata.BLSchmittInput);f()
  f()=@printf(io,"BLDriveCurrent= 0x%02x\n",eepromdata.BLDriveCurrent);f()
  f()=@printf(io,"BHSlowSlew= 0x%02x\n",eepromdata.BHSlowSlew);f()
  f()=@printf(io,"BHSchmittInput= 0x%02x\n",eepromdata.BHSchmittInput);f()
  f()=@printf(io,"BHDriveCurrent= 0x%02x\n",eepromdata.BHDriveCurrent);f()
  f()=@printf(io,"AIsFifo= 0x%02x\n",eepromdata.AIsFifo);f()
  f()=@printf(io,"AIsFifoTar= 0x%02x\n",eepromdata.AIsFifoTar);f()
  f()=@printf(io,"AIsFastSer= 0x%02x\n",eepromdata.AIsFastSer);f()
  f()=@printf(io,"BIsFifo= 0x%02x\n",eepromdata.BIsFifo);f()
  f()=@printf(io,"BIsFifoTar= 0x%02x\n",eepromdata.BIsFifoTar);f()
  f()=@printf(io,"BIsFastSer= 0x%02x\n",eepromdata.BIsFastSer);f()
  f()=@printf(io,"BIsFastSer= 0x%02x\n",eepromdata.BIsFastSer);f()
  f()=@printf(io,"PowerSaveEnable= 0x%02x\n",eepromdata.PowerSaveEnable);f()
  f()=@printf(io,"ADriverType= 0x%02x\n",eepromdata.ADriverType);f()
  f()=@printf(io,"BDriverType= 0x%02x\n",eepromdata.BDriverType);f()
end

function ft_eeprom_read(ft_handle::Culong, eepromdata::Fteeprom2232h)
  @assert eepromdata.deviceType == FT_DEVICE_2232H
  fteepromread_alleeprom(ft_handle,eepromdata)
end

function ft_eeprom_program(ft_handle::Culong, eepromdata::Fteeprom2232h,
                            mfg_string::ASCIIString,
                            mfgid_string::ASCIIString,
                            d_string::ASCIIString,
                            sn_string::ASCIIString)
  @assert eepromdata.deviceType == FT_DEVICE_2232H
  fteepromprogram_alleeprom(ft_handle,eepromdata,mfg_string,
                  mfgid_string,d_string,sn_string)
end

# FT4232H EEPROM structure for use with ft_eeprom_read and ft_eeprom_program
type Fteeprom4232h <: Eeprom
  ### BEGIN common elements for all device EEPROMs ###
  deviceType :: Cuint # FT_DEVICE FTxxxx device type to be programmed
  # Device descriptor options
  VendorId :: Cshort # 0x0403
  ProductId :: Cshort # 0x6001
  SerNumEnable :: Cuchar # non-zero if serial number to be used
  # Config descriptor options
  MaxPower :: Cshort #  0 < MaxPower <= 500
  pad1::UInt8;pad2::UInt8;pad3::UInt8;pad4::UInt8  # needed to allign fields.  Why?
  ### END common elements for all device EEPROMs ###
  # Drive options
  ASlowSlew :: Cuchar # non-zero if A pins have slow slew
  ASchmittInput :: Cuchar # non-zero if A pins are Schmitt input
  ADriveCurrent :: Cuchar # valid values are 4mA, 8mA, 12mA, 16mA
  BSlowSlew :: Cuchar # non-zero if B pins have slow slew
  BSchmittInput :: Cuchar # non-zero if B pins are Schmitt input
  BDriveCurrent :: Cuchar # valid values are 4mA, 8mA, 12mA, 16mA
  CSlowSlew :: Cuchar # non-zero if C pins have slow slew
  CSchmittInput :: Cuchar # non-zero if C pins are Schmitt input
  CDriveCurrent :: Cuchar # valid values are 4mA, 8mA, 12mA, 16mA
  DSlowSlew :: Cuchar # non-zero if D pins have slow slew
  DSchmittInput :: Cuchar # non-zero if D pins are Schmitt input
  DDriveCurrent :: Cuchar # valid values are 4mA, 8mA, 12mA, 16mA
  # Hardware options
  ARIIsTXDEN :: Cuchar # non-zero if port A uses RI as RS485 TXDEN
  BRIIsTXDEN :: Cuchar # non-zero if port B uses RI as RS485 TXDEN
  CRIIsTXDEN :: Cuchar # non-zero if port C uses RI as RS485 TXDEN
  DRIIsTXDEN :: Cuchar # non-zero if port D uses RI as RS485 TXDEN
  # Driver option
  ADriverType :: Cuchar #
  BDriverType :: Cuchar #
  CDriverType :: Cuchar #
  DDriverType :: Cuchar #
  Fteeprom4232h() = new(FT_DEVICE_4232H)
end

function Base.show(io::IO, eepromdata::Fteeprom4232h)
  showcommonelements(io,eepromdata)
  f()=@printf(io,"ASlowSlew= 0x%02x\n",eepromdata.ASlowSlew);f()
  f()=@printf(io,"ASchmittInput= 0x%02x\n",eepromdata.ASchmittInput);f()
  f()=@printf(io,"ADriveCurrent= 0x%02x\n",eepromdata.ADriveCurrent);f()
  f()=@printf(io,"BSlowSlew= 0x%02x\n",eepromdata.BSlowSlew);f()
  f()=@printf(io,"BSchmittInput= 0x%02x\n",eepromdata.BSchmittInput);f()
  f()=@printf(io,"BDriveCurrent= 0x%02x\n",eepromdata.BDriveCurrent);f()
  f()=@printf(io,"CSlowSlew= 0x%02x\n",eepromdata.CSlowSlew);f()
  f()=@printf(io,"CSchmittInput= 0x%02x\n",eepromdata.CSchmittInput);f()
  f()=@printf(io,"CDriveCurrent= 0x%02x\n",eepromdata.CDriveCurrent);f()
  f()=@printf(io,"DSlowSlew= 0x%02x\n",eepromdata.DSlowSlew);f()
  f()=@printf(io,"DSchmittInput= 0x%02x\n",eepromdata.DSchmittInput);f()
  f()=@printf(io,"DDriveCurrent= 0x%02x\n",eepromdata.DDriveCurrent);f()
  f()=@printf(io,"ARIIsTXDEN= 0x%02x\n",eepromdata.ARIIsTXDEN);f()
  f()=@printf(io,"BRIIsTXDEN= 0x%02x\n",eepromdata.BRIIsTXDEN);f()
  f()=@printf(io,"CRIIsTXDEN= 0x%02x\n",eepromdata.CRIIsTXDEN);f()
  f()=@printf(io,"DRIIsTXDEN= 0x%02x\n",eepromdata.DRIIsTXDEN);f()
  f()=@printf(io,"ADriverType= 0x%02x\n",eepromdata.ADriverType);f()
  f()=@printf(io,"BDriverType= 0x%02x\n",eepromdata.BDriverType);f()
  f()=@printf(io,"CDriverType= 0x%02x\n",eepromdata.CDriverType);f()
  f()=@printf(io,"DDriverType= 0x%02x\n",eepromdata.DDriverType);f()
end

function ft_eeprom_read(ft_handle::Culong, eepromdata::Fteeprom4232h)
  @assert eepromdata.deviceType == FT_DEVICE_4232H
  fteepromread_alleeprom(ft_handle,eepromdata)
end

function ft_eeprom_program(ft_handle::Culong, eepromdata::Fteeprom4232h,
                            mfg_string::ASCIIString,
                            mfgid_string::ASCIIString,
                            d_string::ASCIIString,
                            sn_string::ASCIIString)
  @assert eepromdata.deviceType == FT_DEVICE_4232H
  fteepromprogram_alleeprom(ft_handle,eepromdata,mfg_string,
                  mfgid_string,d_string,sn_string)
end

# FT232H EEPROM structure for use with ft_eeprom_read and ft_eeprom_program
type Fteeprom232h <: Eeprom
  ### BEGIN common elements for all device EEPROMs ###
  deviceType :: Cuint # FT_DEVICE FTxxxx device type to be programmed
  # Device descriptor options
  VendorId :: Cshort # 0x0403
  ProductId :: Cshort # 0x6001
  SerNumEnable :: Cuchar # non-zero if serial number to be used
  # Config descriptor options
  MaxPower :: Cshort #  0 < MaxPower <= 500
  pad1::UInt8;pad2::UInt8;pad3::UInt8;pad4::UInt8  # needed to allign fields.  Why?
  ### END common elements for all device EEPROMs ###
  # Drive options
  ACSlowSlew :: Cuchar # non-zero if AC bus pins have slow slew
  ACSchmittInput :: Cuchar # non-zero if AC bus pins are Schmitt input
  ACDriveCurrent :: Cuchar # valid values are 4mA, 8mA, 12mA, 16mA
  ADSlowSlew :: Cuchar # non-zero if AD bus pins have slow slew
  ADSchmittInput :: Cuchar # non-zero if AD bus pins are Schmitt input
  ADDriveCurrent :: Cuchar # valid values are 4mA, 8mA, 12mA, 16mA
  # CBUS options
  Cbus0 :: Cuchar # Cbus Mux control
  Cbus1 :: Cuchar # Cbus Mux control
  Cbus2 :: Cuchar # Cbus Mux control
  Cbus3 :: Cuchar # Cbus Mux control
  Cbus4 :: Cuchar # Cbus Mux control
  Cbus5 :: Cuchar # Cbus Mux control
  Cbus6 :: Cuchar # Cbus Mux control
  Cbus7 :: Cuchar # Cbus Mux control
  Cbus8 :: Cuchar # Cbus Mux control
  Cbus9 :: Cuchar # Cbus Mux control
  # FT1248 options
  FT1248Cpol :: Cuchar # FT1248 clock polarity - clock idle high (1) or clock idle  :: Cuchar #(0)
  FT1248Lsb :: Cuchar # FT1248 data is LSB (1) or MSB (0)
  FT1248FlowControl :: Cuchar # FT1248 flow control enable
  # Hardware options
  IsFifo :: Cuchar # non-zero if interface is 245 FIFO
  IsFifoTar :: Cuchar # non-zero if interface is 245 FIFO CPU target
  IsFastSer :: Cuchar # non-zero if interface is Fast serial
  IsFT1248 :: Cuchar # non-zero if interface is FT1248
  PowerSaveEnable :: Cuchar ## Driver option
  DriverType :: Cuchar #  :: Cuchar #FT X Series EEPROM structure for use with ft_eeprom_read and ft_eeprom_program
  Fteeprom232h() = new(FT_DEVICE_232H)
end

function Base.show(io::IO, eepromdata::Fteeprom232h)
  showcommonelements(io,eepromdata)
  f()=@printf(io,"ACSlowSlew = 0x%02x\n",eepromdata.ACSlowSlew);f()
  f()=@printf(io,"ACSchmittInput = 0x%02x\n",eepromdata.ACSchmittInput);f()
  f()=@printf(io,"ACDriveCurrent = 0x%02x\n",eepromdata.ACDriveCurrent);f()
  f()=@printf(io,"ADSlowSlew = 0x%02x\n",eepromdata.ADSlowSlew);f()
  f()=@printf(io,"ADSchmittInput = 0x%02x\n",eepromdata.ADSchmittInput);f()
  f()=@printf(io,"ADDriveCurrent = 0x%02x\n",eepromdata.ADDriveCurrent);f()
  f()=@printf(io,"Cbus0 = 0x%02x\n",eepromdata.Cbus0);f()
  f()=@printf(io,"Cbus1 = 0x%02x\n",eepromdata.Cbus1);f()
  f()=@printf(io,"Cbus2 = 0x%02x\n",eepromdata.Cbus2);f()
  f()=@printf(io,"Cbus3 = 0x%02x\n",eepromdata.Cbus3);f()
  f()=@printf(io,"Cbus4 = 0x%02x\n",eepromdata.Cbus4);f()
  f()=@printf(io,"Cbus5 = 0x%02x\n",eepromdata.Cbus5);f()
  f()=@printf(io,"Cbus6 = 0x%02x\n",eepromdata.Cbus6);f()
  f()=@printf(io,"Cbus7 = 0x%02x\n",eepromdata.Cbus7);f()
  f()=@printf(io,"Cbus8 = 0x%02x\n",eepromdata.Cbus8);f()
  f()=@printf(io,"Cbus9 = 0x%02x\n",eepromdata.Cbus9);f()
  f()=@printf(io,"FT1248Cpol = 0x%02x\n",eepromdata.FT1248Cpol);f()
  f()=@printf(io,"FT1248Lsb = 0x%02x\n",eepromdata.FT1248Lsb);f()
  f()=@printf(io,"FT1248FlowControl = 0x%02x\n",eepromdata.FT1248FlowControl);f()
  f()=@printf(io,"IsFifo = 0x%02x\n",eepromdata.IsFifo);f()
  f()=@printf(io,"IsFifoTar = 0x%02x\n",eepromdata.IsFifoTar);f()
  f()=@printf(io,"IsFastSer = 0x%02x\n",eepromdata.IsFastSer);f()
  f()=@printf(io,"IsFT1248 = 0x%02x\n",eepromdata.IsFT1248);f()
  f()=@printf(io,"PowerSaveEnable = 0x%02x\n",eepromdata.PowerSaveEnable);f()
  f()=@printf(io,"DriverType = 0x%02x\n",eepromdata.DriverType);f()
end

function ft_eeprom_read(ft_handle::Culong, eepromdata::Fteeprom232h)
  @assert eepromdata.deviceType == FT_DEVICE_232H
  fteepromread_alleeprom(ft_handle,eepromdata)
end

function ft_eeprom_program(ft_handle::Culong, eepromdata::Fteeprom232h,
                            mfg_string::ASCIIString,
                            mfgid_string::ASCIIString,
                            d_string::ASCIIString,
                            sn_string::ASCIIString)
  @assert eepromdata.deviceType == FT_DEVICE_232H
  fteepromprogram_alleeprom(ft_handle,eepromdata,mfg_string,
                  mfgid_string,d_string,sn_string)
end

type Fteepromxseries <: Eeprom
  ### BEGIN common elements for all device EEPROMs ###
  deviceType :: Cuint # FT_DEVICE FTxxxx device type to be programmed
  # Device descriptor options
  VendorId :: Cshort # 0x0403
  ProductId :: Cshort # 0x6001
  SerNumEnable :: Cuchar # non-zero if serial number to be used
  # Config descriptor options
  MaxPower :: Cshort #  0 < MaxPower <= 500
  pad1::UInt8;pad2::UInt8;pad3::UInt8;pad4::UInt8  # needed to allign fields.  Why?
  ### END common elements for all device EEPROMs ###
  # Drive options
  ACSlowSlew :: Cuchar # non-zero if AC bus pins have slow slew
  ACSchmittInput :: Cuchar # non-zero if AC bus pins are Schmitt input
  ACDriveCurrent :: Cuchar # valid values are 4mA, 8mA, 12mA, 16mA
  ADSlowSlew :: Cuchar # non-zero if AD bus pins have slow slew
  ADSchmittInput :: Cuchar # non-zero if AD bus pins are Schmitt input
  ADDriveCurrent :: Cuchar # valid values are 4mA, 8mA, 12mA, 16mA
  # CBUS options
  Cbus0 :: Cuchar # Cbus Mux control
  Cbus1 :: Cuchar # Cbus Mux control
  Cbus2 :: Cuchar # Cbus Mux control
  Cbus3 :: Cuchar # Cbus Mux control
  Cbus4 :: Cuchar # Cbus Mux control
  Cbus5 :: Cuchar # Cbus Mux control
  Cbus6 :: Cuchar # Cbus Mux control
  # UART signal options
  InvertTXD :: Cuchar # non-zero if invert TXD
  InvertRXD :: Cuchar # non-zero if invert RXD
  InvertRTS :: Cuchar # non-zero if invert RTS
  InvertCTS :: Cuchar # non-zero if invert CTS
  InvertDTR :: Cuchar # non-zero if invert DTR
  InvertDSR :: Cuchar # non-zero if invert DSR
  InvertDCD :: Cuchar # non-zero if invert DCD
  InvertRI :: Cuchar # non-zero if invert RI
  # Battery Charge Detect options
  BCDEnable :: Cuchar # Enable Battery Charger Detection
  BCDForceCbusPWREN :: Cuchar # asserts the power enable signal on CBUS when charging port detected
  BCDDisableSleep :: Cuchar # forces the device never to go into sleep mode
  # I2C options
  I2CSlaveAddress :: Cushort # I2C slave device address
  I2CDeviceId :: Cuint # I2C device ID
  I2CDisableSchmitt :: Cuchar # Disable I2C Schmitt trigger
  # FT1248 options
  FT1248Cpol :: Cuchar # FT1248 clock polarity - clock idle high (1) orclock idle low (0)
  FT1248Lsb :: Cuchar # FT1248 data is LSB (1) or MSB (0)
  FT1248FlowControl :: Cuchar # FT1248 flow control enable
  # Hardware options
  RS485EchoSuppress :: Cuchar 
  PowerSaveEnable :: Cuchar ## Driver option
  DriverType :: Cuchar
  Fteepromxseries() = new(FT_DEVICE_X_SERIES)
end

function Base.show(io::IO, eepromdata::Fteepromxseries)
  showcommonelements(io,eepromdata)
  f()=@printf(io,"ACSlowSlew= 0x%02x\n",eepromdata.ACSlowSlew);f()
  f()=@printf(io,"ACSchmittInput= 0x%02x\n",eepromdata.ACSchmittInput);f()
  f()=@printf(io,"ACDriveCurrent= 0x%02x\n",eepromdata.ACDriveCurrent);f()
  f()=@printf(io,"ADSlowSlew= 0x%02x\n",eepromdata.ADSlowSlew);f()
  f()=@printf(io,"ADSchmittInput= 0x%02x\n",eepromdata.ADSchmittInput);f()
  f()=@printf(io,"ADDriveCurrent= 0x%02x\n",eepromdata.ADDriveCurrent);f()
  f()=@printf(io,"Cbus0= 0x%02x\n",eepromdata.Cbus0);f()
  f()=@printf(io,"Cbus1= 0x%02x\n",eepromdata.Cbus1);f()
  f()=@printf(io,"Cbus2= 0x%02x\n",eepromdata.Cbus2);f()
  f()=@printf(io,"Cbus3= 0x%02x\n",eepromdata.Cbus3);f()
  f()=@printf(io,"Cbus4= 0x%02x\n",eepromdata.Cbus4);f()
  f()=@printf(io,"Cbus5= 0x%02x\n",eepromdata.Cbus5);f()
  f()=@printf(io,"Cbus6= 0x%02x\n",eepromdata.Cbus6);f()
  f()=@printf(io,"InvertTXD= 0x%02x\n",eepromdata.InvertTXD);f()
  f()=@printf(io,"InvertRXD= 0x%02x\n",eepromdata.InvertRXD);f()
  f()=@printf(io,"InvertRTS= 0x%02x\n",eepromdata.InvertRTS);f()
  f()=@printf(io,"InvertCTS= 0x%02x\n",eepromdata.InvertCTS);f()
  f()=@printf(io,"InvertDTR= 0x%02x\n",eepromdata.InvertDTR);f()
  f()=@printf(io,"InvertDSR= 0x%02x\n",eepromdata.InvertDSR);f()
  f()=@printf(io,"InvertDCD= 0x%02x\n",eepromdata.InvertDCD);f()
  f()=@printf(io,"InvertRI= 0x%02x\n",eepromdata.InvertRI);f()
  f()=@printf(io,"BCDEnable= 0x%02x\n",eepromdata.BCDEnable);f()
  f()=@printf(io,"BCDForceCbusPWREN= 0x%02x\n",eepromdata.BCDForceCbusPWREN);f()
  f()=@printf(io,"BCDDisableSleep= 0x%02x\n",eepromdata.BCDDisableSleep);f()
  f()=@printf(io,"I2CSlaveAddress= 0x%02x\n",eepromdata.I2CSlaveAddress);f()
  f()=@printf(io,"I2CDeviceId= 0x%02x\n",eepromdata.I2CDeviceId);f()
  f()=@printf(io,"I2CDisableSchmitt= 0x%02x\n",eepromdata.I2CDisableSchmitt);f()
  f()=@printf(io,"FT1248Cpol= 0x%02x\n",eepromdata.FT1248Cpol);f()
  f()=@printf(io,"FT1248Lsb= 0x%02x\n",eepromdata.FT1248Lsb);f()
  f()=@printf(io,"FT1248FlowControl= 0x%02x\n",eepromdata.FT1248FlowControl);f()
  f()=@printf(io,"RS485EchoSuppress= 0x%02x\n",eepromdata.RS485EchoSuppress);f()
  f()=@printf(io,"PowerSaveEnable= 0x%02x\n",eepromdata.PowerSaveEnable);f()
  f()=@printf(io,"DriverType= 0x%02x\n",eepromdata.DriverType);f()
end

function ft_eeprom_read(ft_handle::Culong, eepromdata::Fteepromxseries)
  @assert eepromdata.deviceType == FT_DEVICE_X_SERIES
  fteepromread_alleeprom(ft_handle,eepromdata)
end

function ft_eeprom_program(ft_handle::Culong, eepromdata::Fteepromxseries,
                            mfg_string::ASCIIString,
                            mfgid_string::ASCIIString,
                            d_string::ASCIIString,
                            sn_string::ASCIIString)
  @assert eepromdata.deviceType == FT_DEVICE_X_SERIES
  fteepromprogram_alleeprom(ft_handle,eepromdata,mfg_string,
                  mfgid_string,d_string,sn_string)
end

function ft_eeprom_read(ft_handle::Culong)
  (devicetype,id,sn,d) = ft_getdeviceinfo(ft_handle)
  if devicetype == FT_DEVICE_232BM
    return ft_eeprom_read(ft_handle,Fteeprom232b())
  elseif devicetype == FT_DEVICE_2232C
    return ft_eeprom_read(ft_handle,Fteeprom2232())
  elseif devicetype == FT_DEVICE_232R
    return ft_eeprom_read(ft_handle,Fteeprom232r())
  elseif devicetype == FT_DEVICE_2232H
    return ft_eeprom_read(ft_handle,Fteeprom2232h())
  elseif devicetype == FT_DEVICE_4232H
    return ft_eeprom_read(ft_handle,Fteeprom4232h())
  elseif devicetype == FT_DEVICE_232H
    return ft_eeprom_read(ft_handle,Fteeprom232h())
  elseif devicetype == FT_DEVICE_X_SERIES
    return ft_eeprom_read(ft_handle,Fteepromxseries())
  else
    error("Device type ",devicetype," unknown")
  end
end
