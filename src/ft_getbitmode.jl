export ft_getbitmode
export ftbitmodedict

ftbitmodedict = Dict(
  FT_BITMODE_RESET => "FT_BITMODE_RESET",
  FT_BITMODE_ASYNC_BITBANG => "FT_BITMODE_ASYNC_BITBANG",
  FT_BITMODE_MPSSE => "FT_BITMODE_MPSSE",
  FT_BITMODE_SYNC_BITBANG => "FT_BITMODE_SYNC_BITBANG",
  FT_BITMODE_MCU_HOST => "FT_BITMODE_MCU_HOST",
  FT_BITMODE_FAST_SERIAL => "FT_BITMODE_FAST_SERIAL",
  FT_BITMODE_CBUS_BITBANG => "FT_BITMODE_CBUS_BITBANG",
  FT_BITMODE_SYNC_FIFO => "FT_BITMODE_SYNC_FIFO")

function ft_getbitmode(ft_handle::Culong)
  mode = Ref{Cuchar}()
  ft_status = ccall((:FT_GetBitMode, d2xx),
                     Cuint,
                     (Culong, Ref{Cuchar}),
                     ft_handle, mode)
  checkstatus(ft_status)
  return mode[]
end 