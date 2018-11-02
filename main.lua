--main.lua

local game = require "game"

function love.load()
  love.keyboard.setKeyRepeat(true)
  game.init()
  window_width, window_height = love.window.getMode()
  scale = {}
end

function love.update(dt)
end

function love.draw()
  love.resize(1920, 1080)
  game.draw()
end

function love.keypressed(key, scancode, isrepeat)
  game.keypressed(key, scancode, isrepeat)
  if scancode == "escape" then
    love.event.quit()
  end
  if scancode == "f" then
    love.window.setFullscreen(not love.window.getFullscreen(), "desktop")
  end
  if scancode == "v" then
    game.vision_cycle()
  end
end

function love.resize(w, h)
  scale.x = love.graphics.getWidth()/w
  scale.y = love.graphics.getHeight()/h
  love.graphics.scale(scale.x*2, scale.y*2)
end
