export FT_SetBreakOn

function FT_SetBreakOn(ft_handle::UInt32)
  ft_status = ccall((:FT_SetBreakOn, d2xx),Cuint,(Cuint,),ft_handle)
  checkstatus(ft_status)
  return nothing
end