ServeState = Class{__includes = BaseState}

function ServeState:init()
    self.player1 = Paddle(10, 30)
    self.player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30)
    self.ball = Ball()
    self.paused = false
end

function ServeState:update(dt)
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
        gStateMachine:change('play')
    end

    -- Reset the ball's velocity based on who lost a point
    self.ball.dy = math.random(-50, 50) * 1.5
    if servingPlayer == 1 then
        self.ball.dx = math.random(140, 200)
    else
        self.ball.dx = -math.random(140, 200)
    end

end

function ServeState:render()
    if self.paused then
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
    else
        love.graphics.printf('Player ' .. tostring(servingPlayer) .. "'s serve", 0, 20, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to serve', 0, 40, VIRTUAL_WIDTH, 'center')

        -- Render score
        love.graphics.setFont(gFonts['large'])
        love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
        love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)

        self.player1:render()
        self.player2:render()
        self.ball:render()
    end
end