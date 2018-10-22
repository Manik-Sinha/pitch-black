function love.load()
  x = 100
  y = 100
  speed = 100
end

function love.update(dt)
--You place code here when you update things in the game.

  if love.keyboard.isScancodeDown("w", "up") then y = y - speed * dt end
  if love.keyboard.isScancodeDown("a", "left") then x = x - speed * dt end
  if love.keyboard.isScancodeDown("d", "right") then x = x + speed * dt end
  if love.keyboard.isScancodeDown("s", "down") then y = y + speed * dt end
end

function love.draw()
--You place code here when you want to draw to the screen.

  love.graphics.print("Pitch Black OOOOH SPOOKI", 400, 300)
  love.graphics.rectangle("line", x, y, 50, 50)
end