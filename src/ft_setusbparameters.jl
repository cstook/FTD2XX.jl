export ft_setusbparameters

function ft_setusbparameters(ft_handle::Culong,
                             intransfersize::Integer = 4096,
                             outtransfersize::Integer = 4096)
  @assert intransfersize > 63
  @assert outtransfersize > 63
  @assert intransfersize < 2^16+1
  @assert outtransfersize < 2^16+1
  @assert (intransfersize>>4)*16 == intransfersize
  @assert (outtransfersize>>4)*16 == outtransfersize
  ft_status = ccall((:FT_SetUSBParameters, d2xx),
                     Cuint,
                     (Culong, Cuint, Cuint),
                     ft_handle, intransfersize, outtransfersize)
  checkstatus(ft_status)
  return nothing
end