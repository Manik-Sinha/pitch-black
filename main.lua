--main.lua

local game = require "game"

function love.load()
  love.keyboard.setKeyRepeat(true)
  game.init()
end

function love.update(dt)
end

function love.draw()
  game.draw()
end

function love.keypressed(key, scancode, isrepeat)
  game.keypressed(key, scancode, isrepeat)
  if scancode == "escape" then love.event.quit() end
end
