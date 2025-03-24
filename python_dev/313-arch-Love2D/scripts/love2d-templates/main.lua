-- Main Love2D game file

function love.load()
    -- Initialize your game here
    love.graphics.setBackgroundColor(0.1, 0.1, 0.3)
    
    -- Game variables
    circleX = 400
    circleY = 300
    circleRadius = 50
    circleColor = {1, 1, 1}
    
    -- Font setup
    font = love.graphics.newFont(24)
    love.graphics.setFont(font)
end

function love.update(dt)
    -- Game logic goes here (dt is delta time)
    -- Example: simple animation
    circleX = circleX + math.cos(love.timer.getTime()) * dt * 100
    circleY = circleY + math.sin(love.timer.getTime()) * dt * 100
end

function love.draw()
    -- Rendering code goes here
    love.graphics.setColor(circleColor)
    love.graphics.circle("fill", circleX, circleY, circleRadius)
    
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Welcome to LÖVE2D!", 10, 10)
    love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 10, 40)
end

function love.keypressed(key)
    -- Keyboard input handling
    if key == "escape" then
        love.event.quit()
    elseif key == "space" then
        -- Change circle color randomly
        circleColor = {math.random(), math.random(), math.random()}
    end
end 