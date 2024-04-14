PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.player1 = Paddle()
    self.paused = false
end

function PlayState:update(dt)
    -- Check if the game is paused
    if self.paused then
        if love.keyboard.wasPressed('space') then
            self.paused = false
        else
            return
        end
    elseif love.keyboard.wasPressed('space') then
        self.paused = true
    end

    -- Update paddle position
    self.player1:update(dt)

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function PlayState:render()
    -- Render pause text if paused
    if self.paused then
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
    else
        self.player1:render()
    end
end
