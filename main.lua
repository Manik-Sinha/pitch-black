function love.load()
  x = 100
  y = 100
  speed = 100
end

function love.update(dt)
--You place code here when you update things in the game.

  if love.keyboard.isScancodeDown("w") then y = y - speed * dt end
  if love.keyboard.isScancodeDown("a") then x = x - speed * dt end
  if love.keyboard.isScancodeDown("d") then x = x + speed * dt end
  if love.keyboard.isScancodeDown("s") then y = y + speed * dt end
  if love.keyboard.isDown("up") then y = y - speed * dt end
  if love.keyboard.isDown("left") then x = x - speed * dt end
  if love.keyboard.isDown("right") then x = x + speed * dt end
  if love.keyboard.isDown("down") then y = y + speed * dt end
end

function love.draw()
--You place code here when you want to draw to the screen.

  love.graphics.print("Pitch Black OOOOH SPOOKI", 400, 300)
  love.graphics.rectangle("line", x, y, 50, 50)
end