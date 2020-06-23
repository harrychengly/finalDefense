PlayerIdleState = Class {__includes = EntityIdleState}

function PlayerIdleState:enter(params)
    -- render offset for spaced character sprite
    self.entity.offsetY = 6
    self.entity.offsetX = 6
end

function PlayerIdleState:update(dt) EntityIdleState.update(self, dt) end

function PlayerIdleState:update(dt)
    if love.keyboard.isDown('left') or love.keyboard.isDown('right') or
        love.keyboard.isDown('up') or love.keyboard.isDown('down') then
        self.entity:changeState('walk')
    end
    if love.keyboard.wasPressed('space') then
        self.entity:changeState('cast-spell')
    end
end
