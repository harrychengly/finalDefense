PlayerCastSpell = Class {__includes = BaseState}

function PlayerCastSpell:init(player, battlefield)
    self.player = player
    self.battlefield = battlefield

    -- render offset for spaced character sprite
    self.player.offsetY = 6
    self.player.offsetX = 6

    -- create hitbox based on where the player is and facing
    local direction = self.player.direction
    self.offsetEnergyY = 0;
    self.offsetEnergyX = 0;

    self.player.item = GameObject(GAME_OBJECT_DEFS['fire'], 0, 0)
    self.player:changeAnimation('cast-' .. self.player.direction)
end

function PlayerCastSpell:enter(params)
    gSounds['cast-spell']:stop()
    gSounds['cast-spell']:play()

    self.player.currentAnimation:refresh()
end

function PlayerCastSpell:update(dt)

    local throwX, throwY
    if self.player.direction == 'up' then
        self.offsetEnergyX = -8
        throwX = self.player.x + self.offsetEnergyX
        throwY = self.player.y - PLAYER_THROW_DISTANCE
    elseif self.player.direction == 'down' then
        self.offsetEnergyX = 35
        self.offsetEnergyY = 18
        throwX = self.player.x +self.offsetEnergyX
        throwY = self.player.y + PLAYER_THROW_DISTANCE + self.offsetEnergyY
    elseif self.player.direction == 'left' then
        self.offsetEnergyY = 33
        throwX = self.player.x - PLAYER_THROW_DISTANCE
        throwY = self.player.y + self.offsetEnergyY
    elseif self.player.direction == 'right' then
        self.offsetEnergyY = -10
        self.offsetEnergyX = 15
        throwX = self.player.x + PLAYER_THROW_DISTANCE + self.offsetEnergyX
        throwY = self.player.y + self.offsetEnergyY
    end

    self.player.item:fire(self.player.direction, throwY, throwX,
                          self.player.y + self.offsetEnergyY,
                          self.player.x + self.offsetEnergyX)
    table.insert(self.battlefield.projectiles, self.player.item)

    if self.player.currentAnimation.timesPlayed > 0 then
        self.player.currentAnimation.timesPlayed = 0
        self.player:changeState('idle')
    end

    if love.keyboard.wasPressed('space') then
        self.player:changeState('cast-spell')
    end
end

function PlayerCastSpell:render()
    local anim = self.player.currentAnimation
    love.graphics.draw(gTextures[anim.texture],
                       gFrames[anim.texture][anim:getCurrentFrame()],
                       math.floor(self.player.x),
                       math.floor(self.player.y - self.player.offsetY), 0,
                       1 / 2, 1 / 2)
end
