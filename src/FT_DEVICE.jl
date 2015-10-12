#FT_DEVICE (DWORD)
if ~isdefined(:FT_DEVICE_232BM)
  export FT_DEVICE_232BM, FT_DEVICE_232AM, FT_DEVICE_100AX
  export FT_DEVICE_UNKNOWN, FT_DEVICE_2232C, FT_DEVICE_232R
  export FT_DEVICE_2232H, FT_DEVICE_4232H, FT_DEVICE_232H
  export FT_DEVICE_X_SERIES
  const FT_DEVICE_232BM = 0
  const FT_DEVICE_232AM = 1
  const FT_DEVICE_100AX = 2
  const FT_DEVICE_UNKNOWN = 3
  const FT_DEVICE_2232C = 4
  const FT_DEVICE_232R = 5
  const FT_DEVICE_2232H = 6
  const FT_DEVICE_4232H = 7
  const FT_DEVICE_232H = 8
  const FT_DEVICE_X_SERIES = 9
  export ftdevicetypedict
  ftdevicetypedict = Dict(
    FT_DEVICE_232BM => "232BM",
    FT_DEVICE_232AM => "232AM",
    FT_DEVICE_100AX => "100AX",
    FT_DEVICE_UNKNOWN => "UNKNOWN",
    FT_DEVICE_2232C => "2232C",
    FT_DEVICE_232R => "232R",
    FT_DEVICE_2232H => "2232H",
    FT_DEVICE_4232H => "4232H",
    FT_DEVICE_232H => "232H",
    FT_DEVICE_X_SERIES => "X_SERIES")
end