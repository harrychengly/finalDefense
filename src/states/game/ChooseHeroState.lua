ChooseHeroState = Class {__includes = BaseState}

function ChooseHeroState:enter(params) end

function ChooseHeroState:init()
    self.currentHero = 1
    self.hero = 'whitemale'
end

function ChooseHeroState:update(dt)
    if love.keyboard.wasPressed('left') then
        if self.currentHero == 1 then
            gSounds['no-select']:play()
        else
            gSounds['select']:play()
            self.currentHero = self.currentHero - 1
        end
    elseif love.keyboard.wasPressed('right') then
        if self.currentHero == 3 then
            gSounds['no-select']:play()
        else
            gSounds['select']:play()
            self.currentHero = self.currentHero + 1
        end
    end

    if love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter') then
        gSounds['select']:play()

        gStateMachine:change('play', {hero = self.hero, level = 1})
    end

    if love.keyboard.wasPressed('escape') then love.event.quit() end

    if self.currentHero == 1 then
        self.hero = 'whitemale'
    elseif self.currentHero == 2 then
        self.hero = 'darkmale'
    else
        self.hero = 'elf'
    end
end

function ChooseHeroState:render()
    love.graphics.draw(gTextures['background'], 0, 0, 0,
                       VIRTUAL_WIDTH / gTextures['background']:getWidth(),
                       VIRTUAL_HEIGHT / gTextures['background']:getHeight())
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf("Select your hero!", 0, VIRTUAL_HEIGHT / 4,
                         VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(gFonts['small'])
    love.graphics.printf("(Press Enter to continue!)", 0, VIRTUAL_HEIGHT / 3,
                         VIRTUAL_WIDTH, 'center')

    -- left arrow; should render normally if we're higher than 1, else
    -- in a shadowy form to let us know we're as far left as we can go
    if self.currentHero == 1 then
        -- tint; give it a dark gray with half opacity
        love.graphics.setColor(128, 128, 128, 0.5)
    end

    love.graphics.draw(gTextures['arrows'], gFrames['arrows'][1],
                       VIRTUAL_WIDTH / 4 - 24,
                       VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 3)

    -- reset drawing color to full white for proper rendering
    love.graphics.setColor(255, 255, 255, 255)

    -- right arrow; should render normally if we're less than 4, else
    -- in a shadowy form to let us know we're as far right as we can go
    if self.currentHero == 3 then
        -- tint; give it a dark gray with half opacity
        love.graphics.setColor(128, 128, 128, 0.5)
    end

    love.graphics.draw(gTextures['arrows'], gFrames['arrows'][2],
                       VIRTUAL_WIDTH - VIRTUAL_WIDTH / 4,
                       VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 3)

    -- reset drawing color to full white for proper rendering
    love.graphics.setColor(255, 255, 255, 255)

    love.graphics.draw(gTextures[self.hero], gFrames[self.hero][13],
                       VIRTUAL_WIDTH / 2 - 16,
                       VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 2 + 25, 0, 1 / 2, 1 / 2)
end
