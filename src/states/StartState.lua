-- Declare Start state class
StartState = Class{__includes = BaseState}

-- Update state
function StartState:update(dt)
    -- Check if enter was pressed and change to serve state
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('serve')
    end

    -- Check if player wants to quit
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

-- Render objects
function StartState:render()
    -- Render text
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf("PONG", 0, VIRTUAL_HEIGHT / 3, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf("Press ENTER to Start", 0, VIRTUAL_HEIGHT / 2 + 70, VIRTUAL_WIDTH, 'center')

    -- Reset color of menu back
    love.graphics.setColor(1, 1, 1, 1)
end
