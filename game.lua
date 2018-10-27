--game.lua

require "monster"
local m = require "messenger"
local messenger = m.new(5)
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
  --Assume view.h and view.w are odd for now.
  local view = {w = 21, h = 11}

  local monsters = {}
  for i = 1, 3 do
    monsters[i] = newmonster("spider")
  end
  monsters[1].set_xy(5, 3)
  monsters[2].set_xy(5, 10)
  monsters[3].set_xy(10, 4)

  local near_vision = 1
  local far_vision =  1
  local vision_state = 1
  function self.vision_cycle()
    vision_state = (vision_state + 1) % 3
    if vision_state == 0 then
      far_vision = 0
      near_vision = 1
    elseif vision_state == 1 then
      far_vision = 1
      near_vision = 1
    else
      far_vision = 0.005
      near_vision = 0
    end

  end

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
      local monster_found = false
      for i = 1, 3 do
        local x, y = monsters[i].get_xy()
        if new_x == x and new_y == y and not monsters[i].isdead() then
          monster_found = true
          local dmg = monsters[i].take_damage(player.get_attack())
          local monster = monsters[i].get_type()
          messenger.post("Hit a " .. monster .. " for " .. dmg .. " damage.")
          if not monsters[i].isdead() then
            dmg = player.take_damage(monsters[i].get_attack())
            messenger.post("Hit by " .. monster .. " for " .. dmg .. " dmg.")
          else
            messenger.post("You killed a " .. monster .. ".")
          end
        end
      end
      if not monster_found then
        local tile = map[new_y][new_x]
        if tile ~= nil and tile ~= WALL then
          map[player_y][player_x] = FLOOR
          map[new_y][new_x] = PLAYER
          player.set_xy(new_x, new_y)
        end
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
    local vision_first_row = math.max(py - pv, 1)
    local vision_last_row = math.min(py + pv, map.rows)
    local vision_first_col = math.max(px - pv, 1)
    local vision_last_col = math.min(px + pv, map.cols)
    --Assume view.h and view.w are odd for now.
    local vh = (view.h - 1) / 2
    local vw = (view.w - 1) / 2

    local first_row = math.max(py - vh, 1)
    local last_row = math.min(py + vh, map.rows)
    local first_col = math.max(px - vw, 1)
    local last_col = math.min(px + vw, map.cols)

    last_col = math.min(first_col + view.w - 1, map.cols)
    first_col = math.max(last_col - view.w + 1, 1)
    last_row = math.min(first_row + view.h - 1, map.rows)
    first_row = math.max(last_row - view.h + 1, 1)

    --[[
    if (first_col + view.w - 1) <= map.cols then
      last_col = first_col + view.w - 1
    else
      first_col = last_col - view.w + 1
    end

    if (first_row + view.h - 1) <= map.rows then
      last_row = first_row + view.h - 1
    else
      first_row = last_row - view.h + 1
    end
    --]]
    for r = first_row, last_row do
      for c = first_col, last_col do
        local tile = map[r][c]
        --if tile ~= nil then
          local dist_x = view.w - math.abs(px - c)
          local dist_y = view.h - math.abs(py - r)
          if tile == FLOOR then
            love.graphics.setColor(0.2, 0.2, 0.2, far_vision * dist_x * dist_y)
          elseif tile == WALL then
            love.graphics.setColor(1, 1, 1, far_vision * dist_x * dist_y)
          elseif tile == PLAYER then
            love.graphics.setColor(1, 0, 0)
          end
          love.graphics.rectangle(
            "fill",
            (c - first_col+4) * 32,
            (r - first_row+3) * 32,
            32,
            32
          )
        --end
      end
    end
    for i = 1, 3 do
      local x, y = monsters[i].get_xy()
      local dist_x = view.w - math.abs(px - x)
      local dist_y = view.h - math.abs(py - y)
      if first_row <= y and y <= last_row and
         first_col <= x and x <= last_col and
         not monsters[i].isdead() then
        love.graphics.setColor(0, 1, 0, far_vision * dist_x * dist_y)
        love.graphics.rectangle(
          "fill",
          (x - first_col + 4) * 32,
          (y - first_row + 3) * 32,
          32,
          32
        )
      end
    end
    ---[[
    for r = vision_first_row, vision_last_row do
      for c = vision_first_col, vision_last_col do
        local tile = map[r][c]
        --if tile ~= nil then
          if tile == FLOOR then
            love.graphics.setColor(0.2, 0.2, 0.2, near_vision)
          elseif tile == WALL then
            love.graphics.setColor(1, 1, 1, near_vision)
          elseif tile == PLAYER then
            love.graphics.setColor(1, 0, 0, near_vision)
          end
          love.graphics.rectangle(
            "fill",
            (c - first_col+4) * 32,
            (r - first_row+3) * 32,
            32,
            32
          )
        --end
      end
    end
    --]]
    for i = 1, 3 do
      local x, y = monsters[i].get_xy()
      local dist_x = view.w - math.abs(px - x)
      local dist_y = view.h - math.abs(py - y)
      if vision_first_row <= y and y <= vision_last_row and
         vision_first_col <= x and x <= vision_last_col and
         not monsters[i].isdead() then
        love.graphics.setColor(0, 1, 0, near_vision)
        love.graphics.rectangle(
          "fill",
          (x - first_col + 4) * 32,
          (y - first_row + 3) * 32,
          32,
          32
        )
      end
    end
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("hp: " .. player.get_hp(), 0, window_height - 20)
    love.graphics.setColor(1, 1, 1, 0.5)
    love.graphics.rectangle("fill", 40, window_height - 80, 200, 80)
    love.graphics.setColor(0, 0, 0)
    love.graphics.print(messenger.tostring(), 40, window_height - 80)
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
