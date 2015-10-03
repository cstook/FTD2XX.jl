# exported functions
export FT_CreateDeviceInfoList, FT_GetDeviceInfoList, FT_Open, FT_Description
export FT_SerialNumber, FT_OpenEx, FT_Close, FT_Read, FT_Write, FT_SetBaudRate
export FT_SetDataCharacteristics, FT_SetTimeouts, FT_SetFlowControl, FT_SetDtr
export FT_ClrDtr,  FT_SetRts, FT_ClrRts, FT_GetModemStatus, FT_GetQueueStatus
export FT_GetDeviceInfo, FT_GetDriverVersion, FT_GetLibraryVersion
export FT_GetComPortNumber, FT_GetStatus, FT_SetChars, FT_SetBreakOn
export FT_SetBreakOff, FT_Purge, FT_ResetDevice, FT_ResetPort, FT_CyclePort
export FT_Rescan, FT_Reload, FT_SetResetPipeRetryCount, FT_StopInTask
export FT_RestartInTask, FT_SetDeadmanTimeout, FT_ReadEE, FT_WriteEE, FT_EraseEE
export FT_EE_Read, FT_EE_Program, FT_EE_UASize, FT_EE_UARead!, FT_EE_UAWrite
export FT_GetLatencyTimer
export FT_SetLatencyTimer, FT_SetBitMode, FT_GetBitMode, FT_SetUSBParameters

# exported constants

export FT_OK, FT_INVALID_HANDLE, FT_DEVICE_NOT_FOUND, FT_DEVICE_NOT_OPENED
export FT_IO_ERROR, FT_INSUFFICIENT_RESOURCES, FT_INVALID_PARAMETER
export FT_INVALID_BAUD_RATE, FT_DEVICE_NOT_OPENED_FOR_ERASE
export FT_DEVICE_NOT_OPENED_FOR_WRITE, FT_FAILED_TO_WRITE_DEVICE
export FT_EEPROM_READ_FAILED, FT_EEPROM_WRITE_FAILED, FT_EEPROM_ERASE_FAILED
export FT_EEPROM_NOT_PRESENT, FT_EEPROM_NOT_PROGRAMMED, FT_INVALID_ARGS
export FT_NOT_SUPPORTED, FT_OTHER_ERROR

export FT_LIST_NUMBER_ONLY, FT_LIST_BY_INDEX, FT_LIST_ALL

export FT_DEVICE_232BM, FT_DEVICE_232AM, FT_DEVICE_100AX, FT_DEVICE_UNKNOWN
export FT_DEVICE_2232C, FT_DEVICE_232R, FT_DEVICE_2232H, FT_DEVICE_4232H
export FT_DEVICE_232H, FT_DEVICE_X_SERIES

export FT_BITS_8, FT_BITS_7, FT_STOP_BITS_1, FT_STOP_BITS_2
export FT_PARITY_NONE, FT_PARITY_ODD, FT_PARITY_EVEN
export FT_PARITY_MARK, FT_PARITY_SPACE
export FT_FLOW_NONE, FT_FLOW_RTS_CTS, FT_FLOW_DTR_DSR, FT_FLOW_XON_XOFF
export FT_PURGE_RX, FT_PURGE_TX
export FT_EVENT_RXCHAR, FT_EVENT_MODEM_STATUS, FT_EVENT_LINE_STATUS
export CTS,DSR,RI,DCD
export OE,PE,FE,BI

export FT_BITMODE_RESET, FT_BITMODE_ASYNC_BITBANG, FT_BITMODE_MPSSE
export FT_BITMODE_SYNC_BITBANG, FT_BITMODE_MCU_HOST, FT_BITMODE_FAST_SERIAL
export FT_BITMODE_CBUS_BITBANG, FT_BITMODE_SYNC_FIFO

export FT_232R_CBUS_TXDEN, FT_232R_CBUS_PWRON, FT_232R_CBUS_RXLED, 
       FT_232R_CBUS_TXLED, FT_232R_CBUS_TXRXLED, FT_232R_CBUS_SLEEP,
       FT_232R_CBUS_CLK48, FT_232R_CBUS_CLK24, FT_232R_CBUS_CLK12,
       FT_232R_CBUS_CLK6, FT_232R_CBUS_IOMODE, FT_232R_CBUS_BITBANG_WR,
       FT_232R_CBUS_BITBANG_RD
export FT_232H_CBUS_TRISTATE, FT_232H_CBUS_RXLED, FT_232H_CBUS_TXLED,
       FT_232H_CBUS_TXRXLED, FT_232H_CBUS_PWREN, FT_232H_CBUS_SLEEP,
       FT_232H_CBUS_DRIVE_0, FT_232H_CBUS_DRIVE_1, FT_232H_CBUS_IOMODE,
       FT_232H_CBUS_TXDEN, FT_232H_CBUS_CLK30, FT_232H_CBUS_CLK15,
       FT_232H_CBUS_CLK7_5
export FT_X_SERIES_CBUS_TRISTATE, FT_X_SERIES_CBUS_RXLED, FT_X_SERIES_CBUS_TXLED,
       FT_X_SERIES_CBUS_TXRXLED, FT_X_SERIES_CBUS_PWREN, FT_X_SERIES_CBUS_SLEEP,
       FT_X_SERIES_CBUS_DRIVE_0, FT_X_SERIES_CBUS_DRIVE_1, FT_X_SERIES_CBUS_IOMODE,
       FT_X_SERIES_CBUS_TXDEN, FT_X_SERIES_CBUS_CLK24, FT_X_SERIES_CBUS_CLK12,
       FT_X_SERIES_CBUS_CLK6, FT_X_SERIES_CBUS_BCD_CHARGER, FT_X_SERIES_CBUS_BCD_CHARGER_N,
       FT_X_SERIES_CBUS_I2C_TXE, FT_X_SERIES_CBUS_I2C_RXF, FT_X_SERIES_CBUS_VBUS_SENSE,
       FT_X_SERIES_CBUS_BITBANG_WR, FT_X_SERIES_CBUS_BITBANG_RD, FT_X_SERIES_CBUS_TIMESTAMP,
       FT_X_SERIES_CBUS_KEEP_AWAKE

# exported dictionary
export ftbitmodedict, ftdevicetypedict, ftstatusdict

