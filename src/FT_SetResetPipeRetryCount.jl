export FT_SetResetPipeRetryCount

function FT_SetResetPipeRetryCount(ft_handle::UInt32, count::Integer)
  ft_status = ccall((:FT_SetResetPipeRetryCount, d2xx),
                     Culong,
                     (Culong, Culong),
                     ft_handle, count)
  checkstatus(ft_status)
  return nothing
end