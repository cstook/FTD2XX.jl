export FT_SetDeadmanTimeout

function FT_SetDeadmanTimeout(ft_handle::Culong, deadmantimeout::Integer = 5000)
  ft_status = ccall((:FT_SetDeadmanTimeout, d2xx),
                     Cuint,
                     (Culong, Cuint),
                     ft_handle, deadmantimeout)
  checkstatus(ft_status)
  return nothing
end 