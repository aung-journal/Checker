--music: dreamscape
require 'src/Dependencies'

function love.load()
    math.randomseed(os.time())
    --love.graphics.setDefaultFilter('')
    love.window.setTitle('Checker')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true
    })

    gStateStack = StateStack()
    gStateStack:push(BeginGameState())

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
    gStateStack:update(dt)

    love.mouse.keysPressed = {}
end

function love.draw()
    push:start()
    gStateStack:render()
    push:finish()
end