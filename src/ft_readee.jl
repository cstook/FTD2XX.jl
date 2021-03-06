export ft_readee

function ft_readee(ft_handle::Culong, wordoffset::Integer)
  @assert wordoffset >= 0
  value = Ref{Cushort}()
  ft_status = ccall((:FT_ReadEE, d2xx),
                     Cuint,
                     (Culong, Cuint, Ref{Cushort}),
                     ft_handle, wordoffset, value)
  checkstatus(ft_status)
  return value[]
end