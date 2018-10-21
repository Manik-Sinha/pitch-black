function love.load()
  x = 100
  y = 100
  speed = 100
end

function love.update(dt)
--You place code here when you update things in the game.

  if love.keyboard.isDown("w") then y = y - speed * dt end
  if love.keyboard.isDown("a") then x = x - speed * dt end
  if love.keyboard.isDown("d") then x = x + speed * dt end
  if love.keyboard.isDown("s") then y = y + speed * dt end
end

function love.draw()
--You place code here when you want to draw to the screen.

  love.graphics.print("Pitch Black OOOOH SPOOKI", 400, 300)
  love.graphics.rectangle("line", x, y, 50, 50)
end
