push = require 'lib/push'
Timer = require 'lib/knife.timer'
Class = require 'lib/class'
checker = require 'src/checker'

--other files
require 'src/constants'
require 'src/Control'
require 'src/Util'

--states
require 'src/states/BaseState'
require 'src/states/StateStack'
require 'src/StateMachine'

--game states
require 'src/states/game/BeginGameState'
require 'src/states/game/StartState'
require 'src/states/game/PlayState'

gTextures = {
    ['logo'] = love.graphics.newImage('graphics/logo.jpeg')
}

gFonts = {
    ['small'] = love.graphics.newFont('fonts/OpenSans-Regular.ttf', 28),
    ['medium'] = love.graphics.newFont('fonts/OpenSans-Regular.ttf', 56),
    ['large'] = love.graphics.newFont('fonts/OpenSans-Regular.ttf', 80),
    ['title'] = love.graphics.newFont('fonts/OpenSans-Regular.ttf', 120)
}

gSounds = {
    ['music'] = love.audio.newSource('sounds/music.mp3', 'stream')
}