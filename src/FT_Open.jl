export FT_Open

function FT_Open(iDevice::Integer)
  ft_handle = Ref{Culong}()
  ft_status = ccall((:FT_Open, "ftd2xx.dll"),
                      Culong,
                      (Culong,Ref{Culong}),
                      iDevice,ft_handle)
  checkstatus(ft_status)
  return ft_handle[]
end