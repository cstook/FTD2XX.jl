# FT_STATUS (DWORD)
const FT_OK = 0 
const FT_INVALID_HANDLE = 1
const FT_DEVICE_NOT_FOUND = 2
const FT_DEVICE_NOT_OPENED = 3
const FT_IO_ERROR = 4
const FT_INSUFFICIENT_RESOURCES = 5
const FT_INVALID_PARAMETER = 6
const FT_INVALID_BAUD_RATE = 7
const FT_DEVICE_NOT_OPENED_FOR_ERASE = 8
const FT_DEVICE_NOT_OPENED_FOR_WRITE = 9
const FT_FAILED_TO_WRITE_DEVICE = 10
const FT_EEPROM_READ_FAILED = 11
const FT_EEPROM_WRITE_FAILED = 12
const FT_EEPROM_ERASE_FAILED = 13
const FT_EEPROM_NOT_PRESENT = 14
const FT_EEPROM_NOT_PROGRAMMED = 15
const FT_INVALID_ARGS = 16
const FT_NOT_SUPPORTED = 17
const FT_OTHER_ERROR = 18

ftstatusdict = Dict(
  FT_OK                           => "FT_OK",
  FT_INVALID_HANDLE               => "FT_INVALID_HANDLE",
  FT_DEVICE_NOT_FOUND             => "FT_DEVICE_NOT_FOUND",
  FT_DEVICE_NOT_OPENED            => "FT_DEVICE_NOT_OPENED",
  FT_IO_ERROR                     => "FT_IO_ERROR",
  FT_INSUFFICIENT_RESOURCES       => "FT_INSUFFICIENT_RESOURCES",
  FT_INVALID_PARAMETER            => "FT_INVALID_PARAMETER",
  FT_INVALID_BAUD_RATE            => "FT_INVALID_BAUD_RATE",
  FT_DEVICE_NOT_OPENED_FOR_ERASE  => "FT_DEVICE_NOT_OPENED_FOR_ERASE",
  FT_DEVICE_NOT_OPENED_FOR_WRITE  => "FT_DEVICE_NOT_OPENED_FOR_WRITE",
  FT_FAILED_TO_WRITE_DEVICE       => "FT_FAILED_TO_WRITE_DEVICE",
  FT_EEPROM_READ_FAILED           => "FT_EEPROM_READ_FAILED",
  FT_EEPROM_WRITE_FAILED          => "FT_EEPROM_WRITE_FAILED",
  FT_EEPROM_ERASE_FAILED          => "FT_EEPROM_ERASE_FAILED",
  FT_EEPROM_NOT_PRESENT           => "FT_EEPROM_NOT_PRESENT",
  FT_EEPROM_NOT_PROGRAMMED        => "FT_EEPROM_NOT_PROGRAMMED",
  FT_INVALID_ARGS                 => "FT_INVALID_ARGS",
  FT_NOT_SUPPORTED                => "FT_NOT_SUPPORTED",
  FT_OTHER_ERROR                  => "FT_OTHER_ERROR")

type Ftd2xxError <: Exception 
  ft_status :: UInt64
end
function Base.showerror(io::IO, e::Ftd2xxError)
  fts = e.ft_status
  errortext = get(ftstatusdict,fts,"Code Not Found")
  print(io, "Ftd2xxError: FT_STATUS=$(fts), $errortext")
end

function checkstatus(ft_status::Culong)
  if ft_status != 0
    throw(Ftd2xxError(ft_status))
  end
  return 0
end