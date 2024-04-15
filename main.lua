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
    gFonts = {
        ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
        ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
        ['large'] = love.graphics.newFont('fonts/font.ttf', 32)
    }
    love.graphics.setFont(gFonts['small'])

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

    gStateMachine = StateMachine {
        ['start'] = function() return StartState() end,
        ['serve'] = function () return ServeState() end,
        ['play'] = function() return PlayState() end,
        ['game'] = function() return GameOverState() end
    }
    gStateMachine:change('start')

    love.keyboard.keysPressed = {}
end

-- Function call for resizing screen
function love.resize(w, h)
    push:resize(w, h)  
end

-- Update game
function love.update(dt)
    gStateMachine:update(dt)

    -- Reset keys pressed
   love.keyboard.keysPressed = {}
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]  
end

-- Draw anything to screen
function love.draw()
    -- Start virtual screen rendering
    push:start()

    love.graphics.clear(0.176, 0.192, 0.259, 1)
    gStateMachine:render()

    -- Show FPS
    displayFPS()

    -- End virtual screen rendering
    push:finish()
end

-- Render FPS
function displayFPS()
    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(0.016, 0.541, 0.506, 1)
    love.graphics.print('FPS ' .. tostring(love.timer.getFPS()), 10, 10)
end
