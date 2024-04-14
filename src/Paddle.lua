-- Declare paddle class

Paddle = Class{}

-- Initialize Paddle
function Paddle:init(x, y, w, h)
    self.x = x
    self.y = y
    self.w = w
    self.h = h

    -- Init paddle speed
    self.dy = 0
end

-- Update Paddle position
function Paddle:update(dt)
    -- We check if speed is -ve, that is, if we are moving up
    if self.dy < 0 then
        -- Update paddle position based on the paddle speed and screen height
        -- Paddle position is scaled by delta time for smooth movement
        -- We use max to prevent paddle from leaving the screen
        self.y = math.max(0, self.y + self.dy * dt)
    -- We check if speed is +ve, that is, if we are moving down
    else
        self.y = math.min(VIRTUAL_HEIGHT - self.h, self.y + self.dy * dt)
    end
end

-- Render Paddle
function Paddle:render()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle('fill', self.x, self.y, self.w, self.h, 4, 4)
end