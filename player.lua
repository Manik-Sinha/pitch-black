local Player = {}
function Player.new()
  local self = {}
  local x, y
  local hp, attack, defense, vision = 1, 1, 1, 1
  function self.set_xy(xx, yy)
    x = xx
    y = yy
  end
  function self.get_xy() return x, y end
  function self.get_hp() return hp end
  return self
end
return Player.new()
