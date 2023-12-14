--music: dreamscape
require 'src/Dependencies'

function love.load()
    math.randomseed(os.time())
    --love.graphics.setDefaultFilter('')
    love.window.setTitle('Checker Bot')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true
    })

    gStateMachine = StateMachine {
        ['begin-game'] = function() return BeginGameState() end,
        ['start'] = function() return StartState() end,
        ['play'] = function() return PlayState() end
    }

    gStateMachine:change('begin-game')

    gSounds['music']:setLooping(true)
    gSounds['music']:play()

    love.keyboard.keysPressed = {}
    love.mouse.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
end

function love.mousepressed(x, y, key)
    love.mouse.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.mouse.wasPressed(key)
    return love.mouse.keysPressed[key]
end

function love.update(dt)
    Timer.update(dt)
    Control.update(dt)
    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}
    love.mouse.keysPressed = {}
end

function love.draw()
    push:start()
    gStateMachine:render()
    push:finish()
end