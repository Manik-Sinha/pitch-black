function newitem(name, storageuse, range, aoe, vision)
  local self = {}
  local x, y, duration
  function self.set_xy(xx,yy)
    x = xx
	y = yy
  end
  function self.set_duration(d)
    duration = d
  end
  function self.get_name() return name end
  function self.get_storageuse() return storageuse end
  function self.get_range(range) return range end
  function self.get_aoe() return aoe end
  function self.get_vision() return vision end
  function self.duration() return duration end
  function self.get_xy() return x, y end
  function self.get_x() return x end
  function self.get_y() return y end
  return self
end
