Battlefield = Class {}

function Battlefield:init(player, level)
    self.width = MAP_WIDTH
    self.height = MAP_HEIGHT

    self.level = level

    self.tiles = {}
    self:generateWallsAndFloors()

    self.entities = {}
    self:generateEntities()

    self.projectiles = {}

    self.player = player
    self.timer = 60
    Timer.every(1, function()
        self.timer = self.timer - 1
        if self.timer <= 10 then gSounds['clock']:play() end
    end)

    self.renderOffsetX = MAP_RENDER_OFFSET_X
    self.renderOffsetY = MAP_RENDER_OFFSET_Y

    self.adjacentOffsetX = 0
    self.adjacentOffsetY = 0
end

function Battlefield:generateWallsAndFloors()
    for y = 1, self.height do
        table.insert(self.tiles, {})

        for x = 1, self.width do
            local id = TILE_EMPTY

            if x == 1 and y == 1 then
                id = 2
            elseif x == 1 and y == self.height then
                id = 2
            elseif x == self.width and y == 1 then
                id = 2
            elseif x == self.width and y == self.height then
                id = 2
            elseif x == 1 then
                id = 2
            elseif x == self.width then
                id = 2
            elseif y == 1 then
                id = 2
            elseif y == self.height then
                id = 2
            else
                id = 1
            end

            table.insert(self.tiles[y], {id = id})
        end
    end
end

function Battlefield:generateEntities()
    local types = {'skeleton', 'orc'}

    for i = 1, self.level * 10 do
        local type = types[math.random(#types)]

        table.insert(self.entities, Entity {
            animations = ENTITY_DEFS[type].animations,
            walkSpeed = ENTITY_DEFS[type].walkSpeed or 20,

            -- ensure X and Y are within bounds of the map
            x = math.random(MAP_RENDER_OFFSET_X + TILE_SIZE,
                            VIRTUAL_WIDTH - TILE_SIZE * 2 - 16),
            y = math.random(MAP_RENDER_OFFSET_Y + TILE_SIZE,
                            VIRTUAL_HEIGHT -
                                (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE) +
                                MAP_RENDER_OFFSET_Y - TILE_SIZE - 16),

            width = 16,
            height = 16,

            health = 1
        })

    end

    for e, entity in pairs(self.entities) do
        entity.stateMachine = StateMachine {
            ['walk'] = function() return EntityWalkState(entity) end,
            ['idle'] = function() return EntityIdleState(entity) end
        }

        entity:changeState('walk')
    end
end

function Battlefield:update(dt)
    self.player:update(dt)

    if self.timer <= 0 then
        Timer.clear()
        gStateMachine:change('game-over')
    end

    for i, entity in pairs(self.entities) do
        if entity.health <= 0 then
            entity.dead = true
            table.remove(self.entities, i)
        elseif not entity.dead then
            entity:processAI({battlefield = self}, dt)
            entity:update(dt)
        end

        -- collision between the player and entities in the battlefield
        if not entity.dead and self.player:collides(entity) and
            not self.player.invulnerable then
            gSounds['hurt']:play()
            self.player:damage(1)
            self.player:goInvulnerable(1.5)

            if self.player.health == 0 then
                Timer.clear()
                gStateMachine:change('game-over')
            end
        end
    end

    for p, projectile in pairs(self.projectiles) do
        projectile:update(dt)

        for i = #self.entities, 1, -1 do
            local entity = self.entities[i]
            if not entity.dead and projectile:collides(entity) then
                gSounds['hurt']:play()
                entity:damage(1)
                table.remove(self.projectiles, p)
            end
        end

        if projectile.timeBroken > 30 then
            table.remove(self.projectiles, p)
        end
    end

    if #self.entities == 0 then
        Timer.clear()
        gStateMachine:change('play',
                             {hero = self.player.skin, level = self.level + 1})
    end

end

function Battlefield:render()
    for y = 1, self.height do
        for x = 1, self.width do
            local tile = self.tiles[y][x]
            if tile.id == 2 then
                love.graphics.draw(gTextures['walls'], gFrames['walls'][1],
                                   (x - 1) * TILE_SIZE + self.renderOffsetX +
                                       self.adjacentOffsetX,
                                   (y - 1) * TILE_SIZE + self.renderOffsetY +
                                       self.adjacentOffsetY, 0, 1 / 4, 1 / 4)
            else
                love.graphics.draw(gTextures['tiles'], gFrames['tiles'][1],
                                   (x - 1) * TILE_SIZE + self.renderOffsetX +
                                       self.adjacentOffsetX,
                                   (y - 1) * TILE_SIZE + self.renderOffsetY +
                                       self.adjacentOffsetY, 0, 1 / 3, 1 / 3)
            end
        end
    end
    self.player:render()

    for k, projectile in pairs(self.projectiles) do
        projectile:render(self.adjacentOffsetX, self.adjacentOffsetY)
    end

    for k, entity in pairs(self.entities) do
        if not entity.dead then
            entity:render(self.adjacentOffsetX, self.adjacentOffsetY)
        end
    end

    love.graphics.setColor(255 / 255, 255 / 255, 255 / 255, 255 / 255)
    love.graphics.setFont(gFonts['zelda-time'])
    love.graphics.printf(tostring(self.timer), 0, MAP_HEIGHT - 10,
                         VIRTUAL_WIDTH, 'center')

    love.graphics.printf("LVL " .. tostring(self.level), 0, MAP_HEIGHT - 10,
                         VIRTUAL_WIDTH, 'right')

end
