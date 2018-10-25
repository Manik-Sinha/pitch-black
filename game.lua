--game.lua

--Game class.
local Game = {}
function Game.new()
  --private variables
  local self = {}
  local FLOOR, WALL, PLAYER = 0, 1, 2
  local map = {
    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
    {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 2, 0, 0, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
  }
  map.rows = #map
  map.cols = #map[1]
  local player = require "player"

  --Initialize game.
  function self.init()
    local player_found = false
    for r = 1, map.rows do
      for c = 1, map.cols do
        if map[r][c] == PLAYER then
          if not player_found then
            player.set_xy(c, r)
            player_found = true
          else
            map[r][c] = FLOOR
          end
        end
      end
    end
  end

  function self.keypressed(key, scancode, isrepeat)
    local player_x, player_y = player.get_xy()
    local function move(new_x, new_y)
      local tile = map[new_y][new_x]
      if tile ~= nil and tile ~= WALL then
        map[player_y][player_x] = FLOOR
        map[new_y][new_x] = PLAYER
        player.set_xy(new_x, new_y)
      end
    end
    if scancode == "w" or scancode == "up" then
      move(player_x, player_y - 1)
    elseif scancode == "s" or scancode == "down" then
      move(player_x, player_y + 1)
    elseif scancode == "a" or scancode == "left" then
      move(player_x - 1, player_y)
    elseif scancode == "d" or scancode == "right" then
      move(player_x + 1, player_y)
    end
  end

  function self.keyreleased()
  end

  --Draw game.
  function self.draw()
    local px, py = player.get_xy()
    local pv = player.get_vision()
    local first_row = math.max(py - pv, 1)
    local last_row = math.min(py + pv, map.rows)
    local first_col = math.max(px - pv, 1)
    local last_col = math.min(px + pv, map.cols)
    for r = first_row, last_row do
      for c = first_col, last_col do
        local tile = map[r][c]
        if tile == FLOOR then
          love.graphics.setColor(0.2, 0.2, 0.2)
        elseif tile == WALL then
          love.graphics.setColor(1, 1, 1)
        elseif tile == PLAYER then
          love.graphics.setColor(1, 0, 0)
        end
        love.graphics.rectangle("fill", (c - 1) * 32, (r - 1) * 32, 32, 32)
      end
    end
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("hp: " .. player.get_hp(), 0, window_height - 20)
  end

  --Print the map to the console.
  function self.print()
    for r = 1, map.rows do
      for c = 1, map.cols do
        io.write(map[r][c], " ")
      end
      io.write("\n")
    end
  end

  return self
end
return Game.new()
