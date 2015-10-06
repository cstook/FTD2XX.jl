export FT_GetDriverVersion

function FT_GetDriverVersion(ft_handle::UInt32)
  driverversion = Ref{Culong}()
  ft_status = ccall((:FT_GetDriverVersion, "ftd2xx.dll"),
                     Culong,
                     (Culong, Ref{Culong}),
                     ft_handle, driverversion)
  checkstatus(ft_status)
  build = (driverversion[] & 0x000000ff)
  minor = (driverversion[] & 0x0000ff00)>>8
  major = (driverversion[] & 0x00ff0000)>>16
  return VersionNumber(major,minor,build)
end