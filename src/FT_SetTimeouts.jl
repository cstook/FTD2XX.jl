export FT_SetTimeouts

function FT_SetTimeouts(ft_handle::Culong,
                         readtimeout::Integer,
                         writetimeout::Integer)
  ft_status = ccall((:FT_SetTimeouts, d2xx),
                     Cuint,
                     (Culong, Cuint, Cuint),
                     ft_handle, readtimeout, writetimeout)
  checkstatus(ft_status)
  return nothing
end 