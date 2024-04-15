StartState = Class{__includes = BaseState}

function StartState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('serve')
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function StartState:render()
    -- Render text, X position, Y position, Pixels to center, Alignment mode
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf("PONG", 0, VIRTUAL_HEIGHT / 3, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf("Press ENTER to Start", 0, VIRTUAL_HEIGHT / 2 + 70, VIRTUAL_WIDTH, 'center')

    -- Reset color of menu back
    love.graphics.setColor(1, 1, 1, 1)
end
