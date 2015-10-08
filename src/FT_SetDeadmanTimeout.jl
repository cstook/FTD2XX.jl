export FT_SetDeadmanTimeout

function FT_SetDeadmanTimeout(ft_handle::UInt32, deadmantimeout::Integer = 5000)
  ft_status = ccall((:FT_SetDeadmanTimeout, "ftd2xx.dll"),
                     Culong,
                     (Culong, Culong),
                     ft_handle, deadmantimeout)
  checkstatus(ft_status)
  return nothing
end 