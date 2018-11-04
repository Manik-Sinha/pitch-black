local Player = {}
function Player.new()
  local self = {}
  local x, y
  local alive
  local hp, attack, defense, vision = 100, 3, 1, 2
  function self.set_xy(xx, yy)
    x = xx
    y = yy
  end
  function self.get_xy() return x, y end
  function self.get_x() return x end
  function self.get_y() return y end
  function self.get_hp() return hp end
  function self.get_vision() return vision end
  function self.get_attack() return attack end
  function self.take_damage(dmg)
    local damage_dealt = math.max(0, dmg - defense)
    hp = hp - damage_dealt
    if hp < 0 then
       alive = false
    end
    return damage_dealt
  end

  function self.born()
    alive = true
  end

  function self.is_alive() return alive end

  function self.ismonster() return false end
  return self
end
return Player.new()
