PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.player1 = Paddle(10, 30)
    self.player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30)
    self.ball = Ball()

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

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    -- Note that the paddle speed is defined in constants.lua
    -- Move the paddle
    if love.keyboard.isDown('w') then
        self.player1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('s') then
        self.player1.dy = PADDLE_SPEED
    else
        self.player1.dy = 0
    end

    -- Player 2 Movement
    -- Player 2 will move along with the ball which basically
    -- turns it into a very basic AI
    if self.ball.y < 0 then
        self.player2.y = -self.ball.y
    elseif self.ball.y > 0 then
        self.player2.y = self.ball.y
    else
        self.player2.y = 0
    end

    -- Detect ball collision and reverse dx if true
    -- Slightly increase speed
    if self.ball:collides(self.player1) then
        self.ball.dx = -self.ball.dx * 1.05
        self.ball.x = self.player1.x + 5

        -- Keep velocity in same direction but randomize it
        if self.ball.dy < 0 then
            self.ball.dy = -math.random(10, 150)
        else
            self.ball.dy = math.random(10, 150)
        end

        sounds['ball_hit']:play()
    end

    if self.ball:collides(self.player2) then
        self.ball.dx = -self.ball.dx * 1.05
        self.ball.x = self.player2.x - 4

        -- Keep velocity in same direction but randomize it
        if self.ball.dy < 0 then
            self.ball.dy = -math.random(10, 150)
        else
            self.ball.dy = math.random(10, 150)
        end

        sounds['ball_hit']:play()
    end

    -- Check collision with screen edges
    if self.ball.y <= 0 then
        self.ball.y = 0
        self.ball.dy = -self.ball.dy

        sounds['ball_hit']:play()
    end

    -- We account for the ball's size with -4
    if self.ball.y >= VIRTUAL_HEIGHT - 4 then
        self.ball.y = VIRTUAL_HEIGHT - 4
        self.ball.dy = -self.ball.dy

        sounds['ball_hit']:play()
    end

    -- Calculate score for both players
    if self.ball.x < 0 then
        servingPlayer = 1
        player2Score = player2Score + 1

        sounds['score']:play()

        -- Win condition
        if player2Score == 5 then
            gStateMachine:change('game')
            sounds['gameOver']:play()

            servingPlayer = 2
            player1Score = 0
            player2Score = 0
           self.ball:reset()
        else
            gStateMachine:change('serve')
            self.ball:reset()
        end

    elseif self.ball.x > VIRTUAL_WIDTH then
        servingPlayer = 2
        player1Score = player1Score + 1

        sounds['score']:play()
        
        -- Win condition
        if player1Score == 5 then
            gStateMachine:change('game')
            sounds['gameOver']:play()

            servingPlayer = 1
            player1Score = 0
            player2Score = 0
            self.ball:reset()
        else
            gStateMachine:change('serve')
            self.ball:reset()
        end
    end

    -- Update paddle and ball position
    self.player1:update(dt)
    self.player2:update(dt)
    self.ball:update(dt)

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
        -- Render score
        love.graphics.setFont(gFonts['large'])
        love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
        love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)
        
        self.player1:render()
        self.player2:render()
        self.ball:render()
    end
end
