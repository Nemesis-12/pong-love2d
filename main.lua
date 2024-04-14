-- Import libraries and modules
require 'src/Dependencies'

-- Init game window and load assets
function love.load()
    -- Nearest-neighbor filtering is required when we need the images 
    -- or fonts to load properly when upscaling or downscaling
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- Set application window title
    love.window.setTitle('Pong')

    -- Generate a random seed
    math.randomseed(os.time())

    -- Initialize font and size for the game. Size needs to be set when
    -- we initialize and cannot be changed later.
    smallFont = love.graphics.newFont('fonts/font.ttf', 8)
    medFont = love.graphics.newFont('fonts/font.ttf', 16)
    bigFont = love.graphics.newFont('fonts/font.ttf', 32)

    -- Set active font
    love.graphics.setFont(smallFont)

    -- Game SFX initialization
    sounds = {
        ['ball_hit'] = love.audio.newSource('sounds/hit.ogg', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['gameOver'] = love.audio.newSource('sounds/gg.wav', 'static')
    }

    -- Initialize virtual window which will contain the game
    -- The function below is replaced since we are using the 
    -- push library for resolution
    -- love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {fullscreen = false, resizable = true, vsync = true})
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {fullscreen = false, resizable = true, vsync = true})

    -- Init score
    servingPlayer = 1
    p1Score = 0
    p2Score = 0

    -- Init paddle position
    p1 = Paddle(10, 30, 5, 20)
    p2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)

    -- Init ball position
    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

    -- Init game state
    gameState = 'start'
end

-- Function call for resizing screen
function love.resize(w, h)
    push:resize(w, h)  
end

-- Update game
function love.update(dt)
    -- Update ball position
    if gameState == 'serve' then
        -- Reset the ball's velocity based on who lost a point
        ball.dy = math.random(-50, 50) * 1.5
        if servingPlayer == 1 then
            ball.dx = math.random(140, 200)
        else
            ball.dx = -math.random(140, 200)
        end
    elseif gameState == 'play' then
        -- Detect ball collision and reverse dx if true
        -- Slightly increase speed
        if ball:collides(p1) then
            ball.dx = -ball.dx * 1.05
            ball.x = p1.x + 5

            -- Keep velocity in same direction but randomize it
            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end

            sounds['ball_hit']:play()
        end

        if ball:collides(p2) then
            ball.dx = -ball.dx * 1.05
            ball.x = p2.x - 4

            -- Keep velocity in same direction but randomize it
            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end

            sounds['ball_hit']:play()
        end

        -- Check collision with screen edges
        if ball.y <= 0 then
            ball.y = 0
            ball.dy = -ball.dy

            sounds['ball_hit']:play()
        end

        -- We account for the ball's size with -4
        if ball.y >= VIRTUAL_HEIGHT - 4 then
            ball.y = VIRTUAL_HEIGHT - 4
            ball.dy = -ball.dy

            sounds['ball_hit']:play()
        end

        ball:update(dt)

        -- Calculate score for both players
        if ball.x < 0 then
            servingPlayer = 1
            p2Score = p2Score + 1

            sounds['score']:play()

            -- Win condition
            if p2Score == 5 then
                gameState = 'gg'
                sounds['gameOver']:play()

                servingPlayer = 2
                p1Score = 0
                p2Score = 0
                ball:reset()
            else
                gameState = 'serve'
                ball:reset()
            end

        elseif ball.x > VIRTUAL_WIDTH then
            servingPlayer = 2
            p1Score = p1Score + 1

            sounds['score']:play()
            
            -- Win condition
            if p1Score == 5 then
                gameState = 'gg'
                sounds['gameOver']:play()

                servingPlayer = 1
                p1Score = 0
                p2Score = 0
                ball:reset()
            else
                gameState = 'serve'
                ball:reset()
            end
        end

        -- Player 2 Movement
        -- Player 2 will move along with the ball which basically
        -- turns it into a very basic AI
        if ball.y < 0 then
            p2.y = -ball.y
        elseif ball.y > 0 then
            p2.y = ball.y
        else
            p2.y = 0
        end
    end

    -- Player 1 Movement
    if love.keyboard.isDown('w') then
        p1.dy = -PADDLE_SPD
    elseif love.keyboard.isDown('s') then
        p1.dy = PADDLE_SPD
    else
        p1.dy = 0
    end

    p1:update(dt)
    p2:update(dt)
end

-- Keyboard input handling
function love.keypressed(key)
    -- State update based on input
    if key == 'escape' then
        love.event.quit()
    
    -- When we press enter, check if game state is start. If so, change it to play.
    -- Also reset ball position to default    
    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'serve'
        elseif gameState == 'serve' then
            gameState = 'play'
        elseif gameState == 'gg' then
            gameState = 'start'
        end
    end
end

-- Draw anything to screen
function love.draw()
    -- Start virtual screen rendering
    push:apply('start')

    -- Set a specific background color (Clear screen with a color)
    love.graphics.clear(0.176, 0.192, 0.259, 1)

    love.graphics.setFont(smallFont)

    if gameState == 'start' then
        -- Render text, X position, Y position, Pixels to center, Alignment mode
        love.graphics.printf('Pong', 0, 20, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'serve' then
        love.graphics.printf('Player ' .. tostring(servingPlayer) .. "'s serve", 0, 20, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to serve', 0, 40, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'gg' then
        love.graphics.setFont(medFont)
        love.graphics.printf('Player ' .. tostring(servingPlayer) .. " Wins!", 0, 20, VIRTUAL_WIDTH, 'center')
        
        love.graphics.setFont(smallFont)
        love.graphics.printf('Press Enter to restart', 0, 50, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'play' then

    end

    -- Render score
    love.graphics.setFont(bigFont)
    love.graphics.print(tostring(p1Score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(p2Score), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)

    -- Render left and right paddles
    p1:render()
    p2:render()

    -- Render ball
    ball:render()

    -- Show FPS
    displayFPS()

    -- End virtual screen rendering
    push:apply('end')
end

-- Render FPS
function displayFPS()
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0.016, 0.541, 0.506, 1)
    love.graphics.print('FPS ' .. tostring(love.timer.getFPS()), 10, 10)
end