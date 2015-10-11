# Types and Constants

# Win32
const OPEN_EXISTING = 3
const FILE_ATTRIBUTE_NORMAL = 0x00000080
const FILE_FLAG_OVERLAPPED = 0x40000000
const GENERIC_READ = 0x80000000
const GENERIC_WRITE = 0x40000000

const CLRDTR = 6 # – Clear the DTR signal 
const CLRRTS = 4 # – Clear the RTS signal 
const SETDTR = 5 # – Set the DTR signal 
const SETRTS = 3 # – Set the RTS signal 
const SETBREAK = 8 # – Set the BREAK condition 
const CLRBREAK = 9 # – Clear the BREAK condition

const MS_CTS_ON = 0x0010 # – Clear To Send (CTS) is on 
const MS_DSR_ON = 0x0020 # – Data Set Ready (DSR) is on 
const MS_RING_ON = 0x0040 # – Ring Indicator (RI) is on 
const MS_RLSD_ON = 0x0080 # – Receive Line Signal Detect (RLSD) is on

# FTDCB structure
type _FTDCB
  DCBlength :: Cuint # sizeof(FTDCB) 
  BaudRate :: Cuint # Baud rate at which running
  status :: Cuint # fields below 
                  # fBinary: 1;  Binary Mode (skip EOF check) 
                  # fParity: 1;  Enable parity checking
                  # fOutxCtsFlow:1; CTS handshaking on output 
                  # fOutxDsrFlow:1; DSR handshaking on output
                  # fDtrControl:2;  DTR Flow control 
                  # fDsrSensitivity:1; DSR Sensitivity
                  # fTXContinueOnXoff: 1; Continue TX when Xoff sent 
                  # fOutX: 1; Enable output X-ON/X-OFF 
                  # fInX: 1; Enable input X-ON/X-OFF 
                  # fErrorChar: 1; Enable Err Replacement 
                  # fNull: 1; Enable Null stripping
                  # fRtsControl:2; Rts Flow control 
                  # fAbortOnError:1; Abort all reads and writes on Error 
                  # fDummy2:17; Reserved 
  wReserved :: Cushort # Not currently used 
  XonLim :: Cushort # Transmit X-ON threshold
  XoffLim :: Cushort # Transmit X-OFF threshold
  ByteSize :: Cuchar # Number of bits/byte, 7-8 
  Parity :: Cuchar # 0-4=None,Odd,Even,Mark,Space 
  StopBits :: Cuchar # 0,2 = 1, 2
  XonChar :: Cchar # Tx and Rx X-ON character
  XoffChar :: Cchar # Tx and Rx X-OFF character
  ErrorChar :: Cchar # Error replacement char 
  EofChar :: Cchar # End of Input character 
  EvtChar :: Cchar # Received Event character 
  wReserved1 :: Cushort # Fill
end

#FTTIMEOUTS structure 
type _FTTIMEOUTS 
  ReadIntervalTimeout :: Cuint #  Maximum time between read chars 
  ReadTotalTimeoutMultiplier :: Cuint #  Multiplier of characters 
  ReadTotalTimeoutConstant :: Cuint #  Constant in milliseconds 
  WriteTotalTimeoutMultiplier :: Cuint #  Multiplier of characters 
  WriteTotalTimeoutConstant :: Cuint #  Constant in milliseconds
end

const EV_BREAK = 0x0040 # – BREAK condition detected 
const EV_CTS = 0x0008 # – Change in Clear To Send (CTS) 
const EV_DSR = 0x0010 # – Change in Data Set Ready (DSR) 
const EV_ERR = 0x0080 # – Error in line status 
const EV_RING = 0x0100 # – Change in Ring Indicator (RI) 
const EV_RLSD = 0x0020 # – Change in Receive Line Signal Detect (RLSD) 
const EV_RXCHAR = 0x0001 # – Character received 
const EV_RXFLAG = 0x0002 # – Event character received 
const EV_TXEMPTY = 0x0004 # – Transmitter empty

const PURGE_TXABORT = 0x0001 # – Terminate outstanding overlapped writes 
const PURGE_RXABORT = 0x0002 # – Terminate outstanding overlapped reads 
const PURGE_TXCLEAR = 0x0004 # – Clear the transmit buffer 
const PURGE_RXCLEAR = 0x0008 # – Clear the receive buffer

# FTCOMSTAT structure 
type _FTCOMSTAT 
  comstat :: Cuint  # fields below
                    # fCtsHold : 1
                    # fDsrHold : 1
                    # fRlsdHold : 1
                    # fXoffHold : 1
                    # fXoffSent : 1
                    # fEof : 1
                    # fTxim : 1
                    # fReserved : 25
                    # cbInQue
                    # cbOutQue;
end