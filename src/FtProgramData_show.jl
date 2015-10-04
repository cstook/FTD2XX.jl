function Base.show(io::IO, pd::FtProgramData)
  @printf(io,"Signature1 = 0x%08x \n",pd.Signature1) # Header - must be 0x0000000
  @printf(io,"Signature2 = 0x%08x \n",pd.Signature2) # Header - must be 0xffffffff
  @printf(io,"Version = 0x%08x \n",pd.Version) # Header - FT_PROGRAM_DATA version 
                   # 0 = original (FT232B) 
                   # 1 = FT2232 extensions 
                   # 2 = FT232R extensions
                   # 3 = FT2232H extensions
                   # 4 = FT4232H extensions
                   # 5 = FT232H extensions
  @printf(io,"VendorId = 0x%04x \n",pd.VendorId) # 0x0403 
  @printf(io,"ProductId = 0x%04x \n",pd.ProductId) # 0x6001 
  println(io,"Manufacture = $(pd.Manufacture)")  # "FTDI"
  println(io,"ManufacturerId = $(pd.ManufacturerId)") # "FT" 
  println(io,"Description = $(pd.Description)")     # "USB HS Serial Converter" 
  println(io,"SerialNumber = $(pd.SerialNumber)")    # "FT000001" if fixed, or NULL
  @printf(io,"MaxPower = 0x%04x \n",pd.MaxPower) # 0 < MaxPower <= 500
  @printf(io,"PnP = 0x%04x \n",pd.PnP) # 0 = disabled, 1 = enabled 
  @printf(io,"SelfPowered = 0x%04x \n",pd.SelfPowered) # 0 = bus powered, 1 = self powered
  @printf(io,"RemoteWakeup = 0x%04x \n",pd.RemoteWakeup) # 0 = not capable, 1 = capable
  if pd.Version >= 0
    println(io)
    println(io,"Rev4 (FT232B) extensions")
    @printf(io,"Rev4 = 0x%02x \n",pd.Rev4)
    @printf(io,"IsoIn = 0x%02x \n",pd.IsoIn)
    @printf(io,"PullDownEnable = 0x%02x \n",pd.PullDownEnable)
    @printf(io,"SerNumEnable = 0x%02x \n",pd.SerNumEnable)
    @printf(io,"USBVersionEnable = 0x%02x \n",pd.USBVersionEnable)
    @printf(io,"USBVersion = 0x%04x \n",pd.USBVersion)
  end
  if pd.Version >= 1
    println(io)
    println(io,"Rev 5 (FT2232) extensions")
    @printf(io,"Rev5 = 0x%02x \n",pd.Rev5)
    @printf(io,"IsoInA = 0x%02x \n",pd.IsoInA)
    @printf(io,"IsoInB = 0x%02x \n",pd.IsoInB)
    @printf(io,"IsoOutA = 0x%02x \n",pd.IsoOutA)
    @printf(io,"PullDownEnable5 = 0x%02x \n",pd.PullDownEnable5)
    @printf(io,"SerNumEnable5 = 0x%02x \n",pd.SerNumEnable5)
    @printf(io,"USBVersionEnable5 = 0x%02x \n",pd.USBVersionEnable5)
    @printf(io,"USBVersion5 = 0x%04x \n",pd.USBVersion5)
    @printf(io,"AIsHighCurrent = 0x%02x \n",pd.AIsHighCurrent)
    @printf(io,"BIsHighCurrent = 0x%02x \n",pd.BIsHighCurrent)
    @printf(io,"IFAIsFifo = 0x%02x \n",pd.IFAIsFifo)
    @printf(io,"IFAIsFifoTar = 0x%02x \n",pd.IFAIsFifoTar)
    @printf(io,"IFAIsFastSer = 0x%02x \n",pd.IFAIsFastSer)
    @printf(io,"AIsVCP = 0x%02x \n",pd.AIsVCP)
    @printf(io,"IFBIsFifo = 0x%02x \n",pd.IFBIsFifo)
    @printf(io,"IFBIsFifoTar = 0x%02x \n",pd.IFBIsFifoTar)
    @printf(io,"IFBIsFastSer = 0x%02x \n",pd.IFBIsFastSer)
    @printf(io,"BIsVCP = 0x%02x \n",pd.BIsVCP)
  end
  if pd.Version >=2
    println(io)
    println(io,"Rev 6 (FT232R) extensions")
    @printf(io,"UseExtOsc = 0x%02x \n",pd.UseExtOsc)
    @printf(io,"HighDriveIOs = 0x%02x \n",pd.HighDriveIOs)
    @printf(io,"EndpointSize = 0x%02x \n",pd.EndpointSize)
    @printf(io,"PullDownEnableR = 0x%02x \n",pd.PullDownEnableR)
    @printf(io,"SerNumEnableR = 0x%02x \n",pd.SerNumEnableR)
    @printf(io,"InvertTXD = 0x%02x \n",pd.InvertTXD)
    @printf(io,"InvertRXD = 0x%02x \n",pd.InvertRXD)
    @printf(io,"InvertRTS = 0x%02x \n",pd.InvertRTS)
    @printf(io,"InvertCTS = 0x%02x \n",pd.InvertCTS)
    @printf(io,"InvertDTR = 0x%02x \n",pd.InvertDTR)
    @printf(io,"InvertDSR = 0x%02x \n",pd.InvertDSR)
    @printf(io,"InvertDCD = 0x%02x \n",pd.InvertDCD)
    @printf(io,"InvertRI = 0x%02x \n",pd.InvertRI)
    @printf(io,"Cbus0 = 0x%02x \n",pd.Cbus0)
    @printf(io,"Cbus1 = 0x%02x \n",pd.Cbus1)
    @printf(io,"Cbus2 = 0x%02x \n",pd.Cbus2)
    @printf(io,"Cbus3 = 0x%02x \n",pd.Cbus3)
    @printf(io,"Cbus4 = 0x%02x \n",pd.Cbus4)
    @printf(io,"RIsD2XX = 0x%02x \n",pd.RIsD2XX)
  end
  if pd.Version >=3
    println(io)
    println(io,"Rev 7 (FT2232H) Extensions")
    @printf(io,"PullDownEnable7 = 0x%02x \n",pd.PullDownEnable7)
    @printf(io,"SerNumEnable7 = 0x%02x \n",pd.SerNumEnable7)
    @printf(io,"ALSlowSlew = 0x%02x \n",pd.ALSlowSlew)
    @printf(io,"ALSchmittInput = 0x%02x \n",pd.ALSchmittInput)
    @printf(io,"ALDriveCurrent = 0x%02x \n",pd.ALDriveCurrent)
    @printf(io,"AHSlowSlew = 0x%02x \n",pd.AHSlowSlew)
    @printf(io,"AHSchmittInput = 0x%02x \n",pd.AHSchmittInput)
    @printf(io,"AHDriveCurrent = 0x%02x \n",pd.AHDriveCurrent)
    @printf(io,"BLSlowSlew = 0x%02x \n",pd.BLSlowSlew)
    @printf(io,"BLSchmittInput = 0x%02x \n",pd.BLSchmittInput)
    @printf(io,"BLDriveCurrent = 0x%02x \n",pd.BLDriveCurrent)
    @printf(io,"BHSlowSlew = 0x%02x \n",pd.BHSlowSlew)
    @printf(io,"BHSchmittInput = 0x%02x \n",pd.BHSchmittInput)
    @printf(io,"BHDriveCurrent = 0x%02x \n",pd.BHDriveCurrent)
    @printf(io,"IFAIsFifo7 = 0x%02x \n",pd.IFAIsFifo7)
    @printf(io,"IFAIsFifoTar7 = 0x%02x \n",pd.IFAIsFifoTar7)
    @printf(io,"IFAIsFastSer7 = 0x%02x \n",pd.IFAIsFastSer7)
    @printf(io,"AIsVCP7 = 0x%02x \n",pd.AIsVCP7)
    @printf(io,"IFBIsFifo7 = 0x%02x \n",pd.IFBIsFifo7)
    @printf(io,"IFBIsFifoTar7 = 0x%02x \n",pd.IFBIsFifoTar7)
    @printf(io,"IFBIsFastSer7 = 0x%02x \n",pd.IFBIsFastSer7)
    @printf(io,"BIsVCP7 = 0x%02x \n",pd.BIsVCP7)
    @printf(io,"PowerSaveEnable = 0x%02x \n",pd.PowerSaveEnable)
  end
  if pd.Version >=4
    println(io)
    println(io,"Rev 8 (FT4232H) Extensions ")
    @printf(io,"PullDownEnable8 = 0x%02x \n",pd.PullDownEnable8)
    @printf(io,"SerNumEnable8 = 0x%02x \n",pd.SerNumEnable8)
    @printf(io,"ASlowSlew = 0x%02x \n",pd.ASlowSlew)
    @printf(io,"ASchmittInput = 0x%02x \n",pd.ASchmittInput)
    @printf(io,"ADriveCurrent = 0x%02x \n",pd.ADriveCurrent)
    @printf(io,"BSlowSlew = 0x%02x \n",pd.BSlowSlew)
    @printf(io,"BSchmittInput = 0x%02x \n",pd.BSchmittInput)
    @printf(io,"BDriveCurrent = 0x%02x \n",pd.BDriveCurrent)
    @printf(io,"CSlowSlew = 0x%02x \n",pd.CSlowSlew)
    @printf(io,"CSchmittInput = 0x%02x \n",pd.CSchmittInput)
    @printf(io,"CDriveCurrent = 0x%02x \n",pd.CDriveCurrent)
    @printf(io,"DSlowSlew = 0x%02x \n",pd.DSlowSlew)
    @printf(io,"DSchmittInput = 0x%02x \n",pd.DSchmittInput)
    @printf(io,"DDriveCurrent = 0x%02x \n",pd.DDriveCurrent)
    @printf(io,"ARIIsTXDEN = 0x%02x \n",pd.ARIIsTXDEN)
    @printf(io,"BRIIsTXDEN = 0x%02x \n",pd.BRIIsTXDEN)
    @printf(io,"CRIIsTXDEN = 0x%02x \n",pd.CRIIsTXDEN)
    @printf(io,"DRIIsTXDEN = 0x%02x \n",pd.DRIIsTXDEN)
    @printf(io,"AIsVCP8 = 0x%02x \n",pd.AIsVCP8)
    @printf(io,"BIsVCP8 = 0x%02x \n",pd.BIsVCP8)
    @printf(io,"CIsVCP8 = 0x%02x \n",pd.CIsVCP8)
    @printf(io,"DIsVCP8 = 0x%02x \n",pd.DIsVCP8)
  end
  if pd.Version >=5
    println(io)
    println(io,"Rev 9 (FT232H) Extensions")
    @printf(io,"PullDownEnableH = 0x%02x \n",pd.PullDownEnableH)
    @printf(io,"SerNumEnableH = 0x%02x \n",pd.SerNumEnableH)
    @printf(io,"ACSlowSlewH = 0x%02x \n",pd.ACSlowSlewH)
    @printf(io,"ACSchmittInputH = 0x%02x \n",pd.ACSchmittInputH)
    @printf(io,"ACDriveCurrentH = 0x%02x \n",pd.ACDriveCurrentH)
    @printf(io,"ADSlowSlewH = 0x%02x \n",pd.ADSlowSlewH)
    @printf(io,"ADSchmittInputH = 0x%02x \n",pd.ADSchmittInputH)
    @printf(io,"ADDriveCurrentH = 0x%02x \n",pd.ADDriveCurrentH)
    @printf(io,"Cbus0H = 0x%02x \n",pd.Cbus0H)
    @printf(io,"Cbus1H = 0x%02x \n",pd.Cbus1H)
    @printf(io,"Cbus2H = 0x%02x \n",pd.Cbus2H)
    @printf(io,"Cbus3H = 0x%02x \n",pd.Cbus3H)
    @printf(io,"Cbus4H = 0x%02x \n",pd.Cbus4H)
    @printf(io,"Cbus5H = 0x%02x \n",pd.Cbus5H)
    @printf(io,"Cbus6H = 0x%02x \n",pd.Cbus6H)
    @printf(io,"Cbus7H = 0x%02x \n",pd.Cbus7H)
    @printf(io,"Cbus8H = 0x%02x \n",pd.Cbus8H)
    @printf(io,"Cbus9H = 0x%02x \n",pd.Cbus9H)
    @printf(io,"IsFifoH = 0x%02x \n",pd.IsFifoH)
    @printf(io,"IsFifoTarH = 0x%02x \n",pd.IsFifoTarH)
    @printf(io,"IsFastSerH = 0x%02x \n",pd.IsFastSerH)
    @printf(io,"IsFT1248H = 0x%02x \n",pd.IsFT1248H)
    @printf(io,"FT1248CpolH = 0x%02x \n",pd.FT1248CpolH)
    @printf(io,"FT1248LsbH = 0x%02x \n",pd.FT1248LsbH)
    @printf(io,"FT1248FlowControlH = 0x%02x \n",pd.FT1248FlowControlH)
    @printf(io,"IsVCPH = 0x%02x \n",pd.IsVCPH)
    @printf(io,"PowerSaveEnableH = 0x%02x \n",pd.PowerSaveEnableH)
  end
end