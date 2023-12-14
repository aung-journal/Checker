--[[
    Recursive table printing function.
    https://coronalabs.com/blog/2014/09/02/tutorial-printing-table-contents/
]]
function print_r ( t )
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        print(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        print(indent..string.rep(" ",string.len(pos)+6).."}")
                    elseif (type(val)=="string") then
                        print(indent.."["..pos..'] => "'..val..'"')
                    else
                        print(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    if (type(t)=="table") then
        print(tostring(t).." {")
        sub_print_r(t,"  ")
        print("}")
    else
        sub_print_r(t,"  ")
    end
    print()
end

require 'checker'
push = require ('push')

colors = {
    X = {1, 1, 1, 1},
    O = {1, 0, 0, 1}
}

-- gTextures = {
--     ['logo'] = love.graphics.newImage('../graphics/logo.jpeg')
-- }

gFonts = {
    ['small'] = love.graphics.newFont('OpenSans-Regular.ttf', 28),
    ['medium'] = love.graphics.newFont('OpenSans-Regular.ttf', 56),
    ['large'] = love.graphics.newFont('OpenSans-Regular.ttf', 80),
    ['title'] = love.graphics.newFont('OpenSans-Regular.ttf', 120)
}

-- gSounds = {
--     ['music'] = love.audio.newSource('../sounds/music.mp3', 'stream')
-- }

WINDOW_WIDTH = 1920
WINDOW_HEIGHT = 1080

VIRTUAL_WIDTH = 1280
VIRTUAL_HEIGHT = 720

function love.load()
    math.randomseed(os.time())
    --love.graphics.setDefaultFilter('')
    love.window.setTitle('Checker Bot')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true
    })

    board = checker:initial_state()
    ai_turn = false
    game_over = checker:terminal(board)
    player = checker:player(board)
    move = checker.EMPTY
    rect = checker.EMPTY--this is to store everything like x, y
    selected = {checker.EMPTY, {checker.EMPTY, checker.EMPTY}} --this is to indicate if a piece have been selected
    user = checker.X
    --the second item is for index of that selected piece

    love.mouse.keysPressed = {}
    love.keyboard.keysPressed = {}
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
    print_r(board)

    -- Check for AI move
    if user ~= player and not game_over then
        if ai_turn then
            move = checker:minimax(board)
            board = checker:result(board, move)
            ai_turn = false
        else
            ai_turn = true
        end
    end

    --Check for a user move
    --I will later add dots to indicate possible legal moves
    if love.mouse.wasPressed(1) and user == player and not game_over then
        for i = 1, 8 do
            for j = 1, 8 do
                --this checks if you have clicked a piece
                if (board[i][j] ~= checker.EMPTY and collidepoint(find_board_coordinates(i, j))) then
                    selected = {true, {i, j}}
                --this checks if you have selected a piece and click on .empty square
                elseif (board[i][j] == checker.EMPTY and collidepoint(find_board_coordinates(i, j)) and selected[1]) then
                    board = checker:result(board, {selected[2], {i, j}})
                --this checks if you have selected a piece and click on another piece again
                elseif (board[i][j] ~= checker.EMPTY and collidepoint(find_board_coordinates(i, j)) and selected[1]) then
                    selected = {true, {i, j}}
                end
            end
        end
    end

    love.mouse.keysPressed = {}
    love.keyboard.keysPressed = {}
end

function love.draw()
    draw_board(board)
end

function find_board_coordinates(i, j)
    local tile_size = 80
    local tile_origin = {VIRTUAL_WIDTH / 2 - (1.5 * tile_size),
                        VIRTUAL_HEIGHT / 2 - (1.5 * tile_size)}
    local rect = {
        x = tile_origin[1] + j * tile_size,
        y = tile_origin[2] + i * tile_size,
        width = tile_size,
        height = tile_size
    }
    return rect
end

function collidepoint(object)
    local mouseX, mouseY = push:toGame(love.mouse.getPosition())
    
    -- Check if the mouse is within the bounding box of the object
    if mouseX >= object.x and mouseX <= object.x + object.width and
       mouseY >= object.y and mouseY <= object.y + object.height then
        return true
    end

    return false
end

--drawing game board
function draw_board(board)
    local tile_size = math.min(VIRTUAL_WIDTH, VIRTUAL_HEIGHT) / 10
    local tile_origin = {
        (VIRTUAL_WIDTH - tile_size * 8) / 2,
        (VIRTUAL_HEIGHT - tile_size * 8) / 2
    }

    for i = 1, 8 do
        for j = 1, 8 do
            -- Define the rectangle
            local rect = {
                x = tile_origin[1] + (j - 1) * tile_size,
                y = tile_origin[2] + (i - 1) * tile_size,
                width = tile_size,
                height = tile_size
            }

            -- Draw the rectangle with a border
            love.graphics.setColor(1, 1, 1) -- Set color to white
            love.graphics.rectangle("line", rect.x, rect.y, rect.width, rect.height)

            if board[i][j] ~= checker.EMPTY then
                love.graphics.setFont(gFonts['medium'])
                if board[i][j] == checker.X then
                    love.graphics.setColor(table.unpack(colors.X))
                    love.graphics.circle(rect.x + tile_size / 2, rect.y + tile_size / 2, tile_size / 2 - 5)
                elseif board[i][j] == checker.O then
                    love.graphics.setColor(table.unpack(colors.O))
                    love.graphics.circle(rect.x + tile_size / 2, rect.y + tile_size / 2, tile_size / 2 - 5)
                elseif board[i][j] == checker.X_KING then
                    love.graphics.setColor(table.unpack(colors.X))
                    love.graphics.circle(rect.x + tile_size / 2, rect.y + tile_size / 2, tile_size / 2 - 5)
                    love.graphics.print("K", rect.x + tile_size / 2 - 5, rect.y + tile_size / 2 - 10)
                elseif board[i][j] == checker.O_KING then
                    love.graphics.setColor(table.unpack(colors.O))
                    love.graphics.circle(rect.x + tile_size / 2, rect.y + tile_size / 2, tile_size / 2 - 5)
                    love.graphics.print("K", rect.x + tile_size / 2 - 5, rect.y + tile_size / 2 - 10)
                end
                love.graphics.setColor(1, 1, 1, 1)
            end
        end
    end
end
