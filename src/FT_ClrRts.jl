export FT_ClrRts

function FT_ClrRts(ft_handle::UInt32)
  ft_status = ccall((:FT_ClrRts, "ftd2xx.dll"),Culong,(Culong,),ft_handle)
  checkstatus(ft_status)
  return nothing
end