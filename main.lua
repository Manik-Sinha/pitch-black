--main.lua

local game = require "game"

function love.load()
  love.keyboard.setKeyRepeat(true)
  game.init()
  window_width, window_height = love.window.getMode()
end

function love.update(dt)
end

function love.draw()
  game.draw()
end

function love.keypressed(key, scancode, isrepeat)
  game.keypressed(key, scancode, isrepeat)
  if scancode == "escape" then
    love.event.quit()
  elseif scancode == "f" then
    love.window.setFullscreen(not love.window.getFullscreen(), "desktop")
  end
end

function love.resize(w, h)
  window_width, window_height = w, h
end
