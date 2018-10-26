function newmonster(type, health, attack, defense, vision, speed, range)
  local self = {}
  function self.set_xy(xx,yy)
    x = xx
	y = yy
  end
  function self.get_type() return type end
  function self.set_health(hp) health = hp end
  function self.get_health() return health end
  function self.set_attack(at) attack = at end
  function self.get_attack() return attack end
  function self.set_defense(def) defense = def end
  function self.get_defense() return defense end
  function self.set_vison(vis) vision = vis end
  function self.get_vision() return vision end
  function self.set_range(ran) range = ran end
  function self.get_range() return range end
  function self.set_speed(sp) speed = sp end
  function self.get_speed() return speed end
  function self.get_xy() return x, y end
  function self.get_x() return x end
  function self.get_y() return y end
  if type == "skeleton" then health, attack, defense, speed, vision = 1, 2, 0, 2, 5 end
  if type == "spider" then health, attack, defense, speed, vision = 3, 5, 2, 2, 7 end
  if type == "bloater" then health, attack, defense, speed, vision = 5, 10, 5, 0.5, 4 end
  return self
end
