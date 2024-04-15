GameOverState = Class{__includes = BaseState}

function GameOverState:init()
    self.player1 = Paddle(10, 30)
    self.player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30)
    self.ball = Ball()
    self.paused = false
end

function GameOverState:update(dt)
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

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('serve')
    end
end

function GameOverState:render()
    if self.paused then
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
    else
        love.graphics.setFont(gFonts['medium'])
        love.graphics.printf('Player ' .. tostring(servingPlayer) .. " Wins!", 0, 20, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(gFonts['small'])
        love.graphics.printf('Press Enter to restart', 0, 40, VIRTUAL_WIDTH, 'center')

        -- Render score
        love.graphics.setFont(gFonts['large'])
        love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
        love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)

        self.player1:render()
        self.player2:render()
        self.ball:render()
    end
end