PlayState = Class{__includes = BaseState}

colors = {
    X = {1, 1, 1, 1},
    O = {1, 0, 0, 1}
}

function PlayState:init()
    self.board = checker.initial_state()
    self.ai_turn = false
    self.game_over = checker.terminal(self.board)
    self.player = checker.player(self.board)
    self.move = checker.EMPTY
    self.rect = checker.EMPTY--this is to store everything like x, y
    self.selected = {false, {checker.EMPTY, checker.EMPTY}} --this is to indicate if a piece have been selected
    --the second item is for index of that selected piece
end

function PlayState:enter(def)
    self.user = def.user
end

function PlayState:update(dt)
    -- Check for AI move
    if self.user ~= self.player and not self.game_over then
        if self.ai_turn then
            self.move = checker.minimax(self.board)
            self.board = checker.result(self.board, self.move)
            self.ai_turn = false
        else
            self.ai_turn = true
        end
    end

    --Check for a user move
    --I will later add dots to indicate possible legal moves
    if love.mouse.wasPressed(1) and self.user == self.player and not self.game_over then
        for i = 1, 8 do
            for j = 1, 8 do
                --this checks if you have clicked a piece
                if (self.board[i][j] ~= checker.EMPTY and self:collidepoint(self:find_board_coordinates(i, j))) then
                    self.selected = {true, {i, j}}
                --this checks if you have selected a piece and click on an empty square
                elseif (self.board[i][j] == checker.EMPTY and self:collidepoint(self:find_board_coordinates(i, j)) and self.selected[1]) then
                    self.board = checker.result(self.board, {self.selected[2], {i, j}})
                --this checks if you have selected a piece and click on another piece again
                elseif (self.board[i][j] ~= checker.EMPTY and self:collidepoint(self:find_board_coordinates(i, j)) and self.selected[1]) then
                    self.selected = {true, {i, j}}
                end
            end
        end
    end
end

function PlayState:render()
    self:draw_board(self.board)
end

function PlayState:find_board_coordinates(i, j)
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

function PlayState:collidepoint(object)
    local mouseX, mouseY = push:toGame(love.mouse.getPosition())
    
    -- Check if the mouse is within the bounding box of the object
    if mouseX >= object.x and mouseX <= object.x + object.width and
       mouseY >= object.y and mouseY <= object.y + object.height then
        return true
    end

    return false
end

--drawing game board
function PlayState:draw_board(board)
    local tile_size = 80
    local tile_origin = {VIRTUAL_WIDTH / 2 - (1.5 * tile_size),
                        VIRTUAL_HEIGHT / 2 - (1.5 * tile_size)}

    for i = 1, 8 do
        for j = 1, 8 do
            -- Define the rectangle
            local rect = {
                x = tile_origin[1] + j * tile_size,
                y = tile_origin[2] + i * tile_size,
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
                    love.graphics.circle(rect.x + 40, rect.y + 40, 40)
                elseif board[i][j] == checker.O then
                    love.graphics.setColor(table.unpack(colors.O))
                    love.graphics.circle(rect.x + 40, rect.y + 40, 40)  
                elseif board[i][j] == checker.X_KING then
                    love.graphics.setColor(table.unpack(colors.X))
                    love.graphics.circle(rect.x + 40, rect.y + 40, 40)
                    love.graphics.print("K", rect.x + 40, rect.y + 40)
                elseif board[i][j] == checker.O_KING then
                    love.graphics.setColor(table.unpack(colors.O))
                    love.graphics.circle(rect.x + 40, rect.y + 40, 40)
                    love.graphics.print("K", rect.x + 40, rect.y + 40)
                end
                love.graphics.setColor(1, 1, 1, 1)
            end        
        end
    end
end