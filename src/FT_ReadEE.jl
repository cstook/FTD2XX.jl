export FT_ReadEE

function FT_ReadEE(ft_handle::UInt32, wordoffset::Integer)
  @assert wordoffset >= 0
  value = Ref{Cushort}()
  ft_status = ccall((:FT_ReadEE, "ftd2xx.dll"),
                     Culong,
                     (Culong, Culong, Ref{Cushort}),
                     ft_handle, wordoffset, value)
  checkstatus(ft_status)
  return convert(UInt16,value[])
end