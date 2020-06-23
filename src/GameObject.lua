GameObject = Class {}

function GameObject:init(def, x, y)
    -- string identifying this object type
    self.type = def.type

    self.texture = def.texture
    self.frame = def.frame or 1

    self.animations = self:createAnimations(def.animations)
    -- whether it acts as an obstacle or not
    self.solid = def.solid

    -- dimensions
    self.x = nil
    self.y = nil
    self.width = def.width
    self.height = def.height
    self.direction = nil
    self.dy = 0
    self.dx = 0
    self.timeBroken = 0
    self.thrown = false

    self.orientation = 0
end

function GameObject:createAnimations(animations)
    local animationsReturned = {}

    for k, animationDef in pairs(animations) do
        animationsReturned[k] = Animation {
            texture = animationDef.texture,
            frames = animationDef.frames,
            interval = animationDef.interval
        }
    end

    return animationsReturned
end

function GameObject:changeAnimation(name)
    self.currentAnimation = self.animations[name]
end

function GameObject:update(dt)
    if self.thrown then self.timeBroken = self.timeBroken + dt end
    if self.currentAnimation then self.currentAnimation:update(dt) end
end

function GameObject:collides(target)
    return not (self.x + self.width < target.x or self.x > target.x +
               target.width or self.y + self.height < target.y or self.y >
               target.y + target.height)
end

function GameObject:fire(direction, dy, dx, fireY, fireX)
    self.thrown = true
    self.direction = direction
    self.y = fireY
    self.x = fireX
    self:changeAnimation('fire-ball')
    Timer.tween(0.5, {[self] = {x = dx, y = dy}})
end

function GameObject:render(adjacentOffsetX, adjacentOffsetY)

    if self.direction == 'left' then
        self.orientation = math.rad(180)
    elseif self.direction == 'right' then
        self.orientation = 0
    elseif self.direction == 'up' then
        self.orientation = math.rad(-90)
    elseif self.direction == 'down' then
        self.orientation = math.rad(90)
    end

    local anim = self.currentAnimation
    love.graphics.draw(gTextures[anim.texture],
                       gFrames[anim.texture][anim:getCurrentFrame()],
                       math.floor(self.x), math.floor(self.y), self.orientation,
                       1 / 3, 1 / 3)
end

