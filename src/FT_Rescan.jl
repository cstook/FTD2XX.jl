export FT_Rescan

function FT_Rescan(ft_handle::UInt32)
  ft_status = ccall((:FT_Rescan, "ftd2xx.dll"),Culong,(Culong,),ft_handle)
  checkstatus(ft_status)
  return nothing
end