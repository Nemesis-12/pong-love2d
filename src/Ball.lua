-- Declare ball class
Ball = Class{}

-- Initialize ball
function Ball:init()
    self.x = VIRTUAL_WIDTH / 2 - 2
    self.y = VIRTUAL_HEIGHT / 2 - 2
    self.width = 4
    self.height = 4

    -- Initialize ball velocity
    self.dx = math.random(2) == 1 and 100 or -100
    self.dy = math.random(-50, 50) * 1.5
end

-- Check ball collision
function Ball:collides(paddle)
    -- First check if the left edge of either is farther to the right
    -- than right edge of the other
    if self.x > paddle.x + paddle.width or paddle.x > self.x + self.width then
        return false
    end

    -- Then check to see if the bottom edge of either is higher than
    -- the edge of the other
    if self.y > paddle.y + paddle.height or paddle.y > self.y + self.height then
        return false
    end

    -- If the above aren't true, they are overlapping
    return true
end

-- Reset ball to original position
function Ball:reset()
    self.x = VIRTUAL_WIDTH / 2 - 2
    self.y = VIRTUAL_HEIGHT / 2 - 2
    self.dx = math.random(2) == 1 and 100 or -100
    self.dy = math.random(-50, 50) * 1.5
end

-- Update ball position
function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

-- Render ball
function Ball:render()
    love.graphics.setColor(0.356, 0.753, 0.745, 1)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end
