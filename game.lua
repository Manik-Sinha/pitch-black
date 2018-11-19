--game.lua

require "monster"
require "item"
local m = require "messenger"
local messenger = m.new(5)
--Game class.
local Game = {}
function Game.new()

  --private variables
  local self = {}
  local FLOOR, WALL, START = 0, 1, 2
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
  map.unit = {{}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}}
  map.item = {{}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}}
  map.rows = #map
  map.cols = #map[1]
  local player = require "player"
  --Assume view.h and view.w are odd for now.
  local view = {w = 21, h = 11}
  local monsters = {}
  --local items = {}

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

  function remove_dead_monsters()
    local index = 1
    local length = #monsters
    for i = 1, length do
      if not monsters[i].isdead() then
        if i ~= index then
          monsters[index] = monsters[i]
          monsters[i] = nil
        end
        index = index + 1
      else
        local x, y = monsters[i].get_xy()
        map.unit[y][x] = nil
        monsters[i] = nil
      end
    end
  end

  function place_monsters(count)
    --Create table floor holding all coordinates of floor tiles.
    local floor = {}
    local index = 1
    for r = 1, map.rows do
      for c = 1, map.cols do
        if map[r][c] == FLOOR and map.unit[r][c] == nil then
          floor[index] = {}
          floor[index].x = c
          floor[index].y = r
          index = index + 1
        end
      end
    end
    --Place monsters on random floor tiles.
    count = math.min(count, #floor)
    local last_index = #floor
    for i = 1, count do
      local index = love.math.random(1, last_index)
      monsters[i] = newmonster("spider")
      local x, y = floor[index].x, floor[index].y
      monsters[i].set_xy(x, y)
      map.unit[y][x] = monsters[i]
      floor[index], floor[last_index] = floor[last_index], floor[index]
      last_index = last_index - 1
    end
  end

  function place_items(count)
    --Create table floor holding all coordinates of floor tiles.
    local floor = {}
    local index = 1
    for r = 1, map.rows do
      for c = 1, map.cols do
        if map[r][c] == FLOOR and map.item[r][c] == nil then
          floor[index] = {}
          floor[index].x = c
          floor[index].y = r
          index = index + 1
        end
      end
    end

    --Place items on random floor tiles.
    count = math.min(count, #floor)
    local last_index = #floor
    for i = 1, count do
      local index = love.math.random(1, last_index)
      --items[i] = newitem("Unknown Item")
      local x, y = floor[index].x, floor[index].y
      --items[i].set_xy(x, y)
      --map.item[y][x] = items[i]
      map.item[y][x] = newitem("Unknown Item")
      map.item[y][x].set_xy(x, y)
      floor[index], floor[last_index] = floor[last_index], floor[index]
      last_index = last_index - 1
    end
  end

  --Initialize game.
  function self.init()
    map.unit = {{}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}}
    map.item = {{}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}}
    local player_found = false
    for r = 1, map.rows do
      for c = 1, map.cols do
        if map[r][c] == START then
          if not player_found then
            player.set_xy(c, r)
            map.unit[r][c] = player
            player_found = true
          else
            map[r][c] = FLOOR
          end
        end
      end
    end
    monsters = {}
    --items = {}
    place_monsters(50)
    place_items(50)
    --Needed for resetting the game:
    player.born()
    messenger.reset()
  end

  function self.keypressed(key, scancode, isrepeat)
    local player_x, player_y = player.get_xy()
    local function move(new_x, new_y)
      local monster_died = false
      local monster_found = false
      local monster = map.unit[new_y][new_x]
      if monster ~= nil and monster.ismonster() then
        monster_found = true
        local dmg = monster.take_damage(player.get_attack())
        local monster_type = monster.get_type()
        messenger.post("Hit a " .. monster_type .. " for " .. dmg .. " damage.")
        if not monster.isdead() then
          dmg = player.take_damage(monster.get_attack())
          messenger.post("Hit by " .. monster_type .. " for " .. dmg .. " dmg.")
        else
          messenger.post("You killed a " .. monster_type .. ".")
          monster_died = true
        end
      end
      --Move player to new position.
      if not monster_found then
        local tile = map[new_y][new_x]
        if tile ~= nil and tile ~= WALL then
          map.unit[player_y][player_x] = nil
          map.unit[new_y][new_x] = player
          player.set_xy(new_x, new_y)
          --Try to pick up an item if there is one.
          if map.item[new_y][new_x] ~= nil then
            local name = map.item[new_y][new_x].get_name()
            if player.pickup(map.item[new_y][new_x]) then
              messenger.post("You picked up a " .. name .. ".")
              map.item[new_y][new_x] = nil
            else
              messenger.post("There is a " .. name .. " on the ground.")
            end
          end
        end
      end
      if monster_died then remove_dead_monsters() end
    end
    if player.is_alive() then
      if scancode == "w" or scancode == "up" then
        move(player_x, player_y - 1)
      elseif scancode == "s" or scancode == "down" then
        move(player_x, player_y + 1)
      elseif scancode == "a" or scancode == "left" then
        move(player_x - 1, player_y)
      elseif scancode == "d" or scancode == "right" then
        move(player_x + 1, player_y)
      end
    else
      if scancode == "space" then
        --Restart game.
        --Note that this is a naive reset. Later there may be caveats such as
        --resetting the map when we restart the game.
        self.init()
      end
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

    if player.is_alive() == true then
      --Far vision:
      --Draw land.
      for r = first_row, last_row do
        for c = first_col, last_col do
          local tile = map[r][c]
          --if tile ~= nil then
            local dist_x = view.w - math.abs(px - c)
            local dist_y = view.h - math.abs(py - r)
            if tile == FLOOR or tile == START then
              love.graphics.setColor(0.2, 0.2, 0.2, far_vision * dist_x * dist_y)
            elseif tile == WALL then
              love.graphics.setColor(1, 1, 1, far_vision * dist_x * dist_y)
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

      --Draw items.
      for r = first_row, last_row do
        for c = first_col, last_col do
          local item_tile = map.item[r][c]
          if item_tile ~= nil then
            local x, y = map.item[r][c].get_xy()
            local dist_x = view.w - math.abs(px - x)
            local dist_y = view.h - math.abs(py - y)
            love.graphics.setColor(0, 0, 1, far_vision * dist_x * dist_y)
            love.graphics.rectangle(
              "fill",
              (x - first_col + 4) * 32,
              (y - first_row + 3) * 32,
              32,
              32
            )
          end
        end
      end

      --Draw player.
      love.graphics.setColor(1, 0, 0)
      love.graphics.rectangle(
        "fill",
        (player.get_x() - first_col + 4) * 32,
        (player.get_y() - first_row + 3) * 32,
        32,
        32
      )

      --Draw monsters.
      for i = 1, #monsters do
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
      --Near vision:
      ---[[
      for r = vision_first_row, vision_last_row do
        for c = vision_first_col, vision_last_col do
          local tile = map[r][c]
          --if tile ~= nil then
            if tile == FLOOR or tile == START then
              love.graphics.setColor(0.2, 0.2, 0.2, near_vision)
            elseif tile == WALL then
              love.graphics.setColor(1, 1, 1, near_vision)
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

      --Draw items.
      for r = vision_first_row, vision_last_row do
        for c = vision_first_col, vision_last_col do
          local item_tile = map.item[r][c]
          if item_tile ~= nil then
            local x, y = map.item[r][c].get_xy()
            local dist_x = view.w - math.abs(px - x)
            local dist_y = view.h - math.abs(py - y)
            love.graphics.setColor(0, 0, 1, near_vision)
            love.graphics.rectangle(
              "fill",
              (x - first_col + 4) * 32,
              (y - first_row + 3) * 32,
              32,
              32
            )
          end
        end
      end

      --Draw player.
      love.graphics.setColor(1, 0, 0, near_vision)
      love.graphics.rectangle(
        "fill",
        (player.get_x() - first_col + 4) * 32,
        (player.get_y() - first_row + 3) * 32,
        32,
        32
      )

      --Draw monsters.
      for i = 1, #monsters do
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
      --Draw hp.
      love.graphics.setColor(1, 1, 1)
      love.graphics.print("hp: " .. player.get_hp(), 0, window_height - 20)
      --Draw message box.
      love.graphics.setColor(1, 1, 1, 0.5)
      love.graphics.rectangle("fill", 40, window_height - 80, 250, 80)
      love.graphics.setColor(0, 0, 0)
      love.graphics.print(messenger.tostring(), 40, window_height - 80)
    else
      love.graphics.setColor(1, 1, 1)
      love.graphics.print('You died!', 400, 300)
    end
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
