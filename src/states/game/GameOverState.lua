 GameOverState = Class {__includes = BaseState}

function GameOverState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('start')
    end

    if love.keyboard.wasPressed('escape') then love.event.quit() end
end

function GameOverState:render()
    love.graphics.draw(gTextures['background'], 0, 0, 0,
                       VIRTUAL_WIDTH / gTextures['background']:getWidth(),
                       VIRTUAL_HEIGHT / gTextures['background']:getHeight())
    love.graphics.setFont(gFonts['zelda'])

    love.graphics.setColor(212 / 255, 175 / 255, 55 / 255, 255 / 255)
    love.graphics.printf('Game Over', 2, VIRTUAL_HEIGHT / 2 - 30,
                         VIRTUAL_WIDTH, 'center')

    love.graphics.setColor(0 / 255, 0 / 255, 0 / 255, 255 / 255)
    love.graphics.printf('Game Over', 0, VIRTUAL_HEIGHT / 2 - 32,
                         VIRTUAL_WIDTH, 'center')

    love.graphics.setColor(0 / 255, 0 / 255, 0 / 255, 255 / 255)
    love.graphics.setFont(gFonts['zelda-small'])
    love.graphics.printf('Press Enter', 0, VIRTUAL_HEIGHT / 2 + 64,
                         VIRTUAL_WIDTH, 'center')
end
