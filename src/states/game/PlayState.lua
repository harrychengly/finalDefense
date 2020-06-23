PlayState = Class {__includes = BaseState}

function PlayState:init() end

function PlayState:enter(params)
    self.hero = params.hero
    self.level = params.level
    self.player = Player {
        animations = ENTITY_DEFS[self.hero].animations,
        walkSpeed = ENTITY_DEFS[self.hero].walkSpeed,

        x = VIRTUAL_WIDTH / 2 - 8,
        y = VIRTUAL_HEIGHT / 2 - 11,

        width = 16,
        height = 22,

        -- one heart == 2 health
        health = 6,

        -- rendering and collision offset for spaced sprites
        offsetY = 5,
        item = nil,
        skin = self.hero
    }

    self.battlefield = Battlefield(self.player, self.level)
    self.player.stateMachine = StateMachine {
        ['walk'] = function() return PlayerWalkState(self.player) end,
        ['idle'] = function() return PlayerIdleState(self.player) end,
        ['cast-spell'] = function()
            return PlayerCastSpell(self.player, self.battlefield)
        end
    }
    self.player:changeState('idle')
end

function PlayState:update(dt)
    if love.keyboard.wasPressed('escape') then love.event.quit() end
    self.battlefield:update(dt)
end

function PlayState:render()
    self.battlefield:render()

    -- draw player hearts, top of screen
    local healthLeft = self.player.health
    local heartFrame = 1

    for i = 1, 3 do
        if healthLeft > 1 then
            heartFrame = 5
        elseif healthLeft == 1 then
            heartFrame = 3
        else
            heartFrame = 1
        end

        love.graphics.draw(gTextures['hearts'], gFrames['hearts'][heartFrame],
                           (i - 1) * (TILE_SIZE + 1), 2)

        healthLeft = healthLeft - 2
    end
end
