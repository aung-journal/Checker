checker = require 'src/checker'
push = require 'lib/push'
Timer = require 'lib/knife.timer'
Class = require 'lib/class'

--other files
require 'src/constants'
require 'src/Control'
require 'src/Util'

--states
require 'src/states/BaseState'
require 'src/states/StateStack'

--game states
require 'src/states/game/BeginGameState'
require 'src/states/game/StartState'

gTextures = {
    ['logo'] = love.graphics.newImage('graphics/logo.jpeg')
}

gFonts = {
    ['medium'] = love.graphics.newFont('fonts/OpenSans-Regular.ttf', 28),
    ['large'] = love.graphics.newFont('fonts/OpenSans-Regular.ttf', 40),
    ['title'] = love.graphics.newFont('fonts/OpenSans-Regular.ttf', 60)
}

gSounds = {
    ['music'] = love.audio.newSource('sounds/music.mp3', 'stream')
}