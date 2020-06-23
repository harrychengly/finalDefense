--
-- libraries
--
Class = require 'lib/class'
Event = require 'lib/knife.event'
push = require 'lib/push'
Timer = require 'lib/knife.timer'

require 'src/Animation'
require 'src/constants'
require 'src/Entity'
require 'src/entity_defs'
require 'src/GameObject'
require 'src/game_objects'
require 'src/Hitbox'
require 'src/Player'
require 'src/StateMachine'
require 'src/Util'
require 'src/Battlefield'

require 'src/states/BaseState'

require 'src/states/entity/EntityIdleState'
require 'src/states/entity/EntityWalkState'

require 'src/states/entity/player/PlayerIdleState'
require 'src/states/entity/player/PlayerCastSpell'
require 'src/states/entity/player/PlayerWalkState'

require 'src/states/game/GameOverState'
require 'src/states/game/PlayState'
require 'src/states/game/StartState'
require 'src/states/game/ChooseHeroState'

gTextures = {
    ['tiles'] = love.graphics.newImage('graphics/tile.png'),
    ['walls'] = love.graphics.newImage('graphics/wall.png'),
    ['background'] = love.graphics.newImage('graphics/background.png'),
    ['arrows'] = love.graphics.newImage('graphics/arrows.png'),
    ['whitemale'] = love.graphics.newImage('graphics/whitemale.png'),
    ['darkmale'] = love.graphics.newImage('graphics/darkmale.png'),
    ['elf'] = love.graphics.newImage('graphics/elf.png'),
    ['orc'] = love.graphics.newImage('graphics/orc.png'),
    ['skeleton'] = love.graphics.newImage('graphics/skeleton.png'),
    ['hearts'] = love.graphics.newImage('graphics/hearts.png'),
    ['fire'] = love.graphics.newImage('graphics/fire.png')
}

gFrames = {
    ['arrows'] = GenerateQuads(gTextures['arrows'], 24, 24),
    ['whitemale'] = GenerateQuads(gTextures['whitemale'], 65, 65),
    ['darkmale'] = GenerateQuads(gTextures['darkmale'], 65, 65),
    ['elf'] = GenerateQuads(gTextures['elf'], 65, 65),
    ['orc'] = GenerateQuads(gTextures['orc'], 65, 65),
    ['skeleton'] = GenerateQuads(gTextures['skeleton'], 65, 65),
    ['hearts'] = GenerateQuads(gTextures['hearts'], 16, 16),
    ['tiles'] = GenerateQuads(gTextures['tiles'], 64, 64),
    ['walls'] = GenerateQuads(gTextures['walls'], 64, 64),
    ['fire'] = GenerateQuads(gTextures['fire'], 120, 95)
}

gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['large'] = love.graphics.newFont('fonts/font.ttf', 32),
    ['gothic-medium'] = love.graphics.newFont('fonts/GothicPixels.ttf', 16),
    ['gothic-large'] = love.graphics.newFont('fonts/GothicPixels.ttf', 32),
    ['zelda'] = love.graphics.newFont('fonts/zelda.otf', 64),
    ['zelda-small'] = love.graphics.newFont('fonts/zelda.otf', 32),
    ['zelda-time'] = love.graphics.newFont('fonts/zelda.otf', 20)
}

gSounds = {
    ['music'] = love.audio.newSource('sounds/backgroundmusic.mp3', 'static'),
    ['select'] = love.audio.newSource('sounds/select.wav', 'static'),
    ['no-select'] = love.audio.newSource('sounds/noselect.wav', 'static'),
    ['cast-spell'] = love.audio.newSource('sounds/cast.wav', 'static'),
    ['hurt'] = love.audio.newSource('sounds/hurt.wav', 'static'),
    ['clock'] = love.audio.newSource('sounds/clock.wav', 'static')
}
