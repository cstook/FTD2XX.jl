export  FT_GetComPortNumber

function FT_GetComPortNumber(ft_handle::UInt32)
  comportnumber = Ref{Culong}()
  ft_status = ccall((:FT_GetComPortNumber, "ftd2xx.dll"),
                     Culong,
                     (Culong, Ref{Culong}),
                     ft_handle, comportnumber)
  checkstatus(ft_status)
  return convert(Int32, comportnumber[])
end