export FT_EraseEE

function FT_EraseEE(ft_handle::Culong)
  ft_status = ccall((:FT_EraseEE, d2xx),Cuint,(Culong, ),ft_handle)
  checkstatus(ft_status)
  return nothing
end 