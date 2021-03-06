PlayerWalkState = Class {__includes = EntityWalkState}

function PlayerWalkState:init(player)
    self.entity = player
    
    -- render offset for spaced character sprite
    self.entity.offsetY = 2
    self.entity.offsetX = 6
end

function PlayerWalkState:update(dt)
    if love.keyboard.isDown('left') then
        self.entity.direction = 'left'
        self.entity:changeAnimation('walk-left')
    elseif love.keyboard.isDown('right') then
        self.entity.direction = 'right'
        self.entity:changeAnimation('walk-right')
    elseif love.keyboard.isDown('up') then
        self.entity.direction = 'up'
        self.entity:changeAnimation('walk-up')
    elseif love.keyboard.isDown('down') then
        self.entity.direction = 'down'
        self.entity:changeAnimation('walk-down')
    else
        self.entity:changeState('idle')
    end

    EntityWalkState.update(self, dt)

    if love.keyboard.wasPressed('space') then
        self.entity:changeState('cast-spell')
    end

    -- if we bumped something when checking collision, check any object collisions
    if self.bumped then
        if self.entity.direction == 'left' then
            self.entity.x = self.entity.x - PLAYER_WALK_SPEED * dt
            self.entity.x = self.entity.x + PLAYER_WALK_SPEED * dt
        elseif self.entity.direction == 'right' then
            self.entity.x = self.entity.x + PLAYER_WALK_SPEED * dt
            self.entity.x = self.entity.x - PLAYER_WALK_SPEED * dt
        elseif self.entity.direction == 'up' then
            self.entity.y = self.entity.y - PLAYER_WALK_SPEED * dt
            self.entity.y = self.entity.y + PLAYER_WALK_SPEED * dt
        else
            self.entity.y = self.entity.y + PLAYER_WALK_SPEED * dt
            self.entity.y = self.entity.y - PLAYER_WALK_SPEED * dt
        end
    end

end
