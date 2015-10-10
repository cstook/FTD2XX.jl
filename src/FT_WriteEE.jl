export FT_WriteEE

function FT_WriteEE(ft_handle::Culong, wordoffset::Integer, value::UInt16)
  @assert wordoffset >= 0
  ft_status = ccall((:FT_WriteEE, d2xx),
                     Cuint,
                     (Culong, Cuint, Cushort),
                     ft_handle, wordoffset, value)
  checkstatus(ft_status)
  return nothing
end 