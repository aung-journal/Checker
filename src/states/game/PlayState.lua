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
    self.move = nil
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
    if love.mouse.wasPressed(1) and self.user == self.player and not self.game_over then
        local mouseX, mouseY = push:toGame(love.mouse.getPosition())
        for i = 1, 8 do
            for j = 1, 8 do
                if (board[i][j] == checker.EMPTY and )
end

function PlayState:render()

end

--drawing game board
function PlayState:draw_board(board)
    local tile_size = 80
    local tile_origin = {width / 2 - (1.5 * tile_size),
                        height / 2 - (1.5 * tile_size)}
    local tiles = {}
    for i = 1, 8 do
        local row = {}
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
                    love.graphics.setColor(unpack(colors.X))
                    love.graphics.circle(rect.x + 40, rect.y + 40, 40)
                elseif board[i][j] == checker.O then
                    love.graphics.setColor(unpack(colors.O))
                    love.graphics.circle(rect.x + 40, rect.y + 40, 40)  
                elseif board[i][j] == checker.X_KING then
                    love.graphics.setColor(unpack(colors.X))
                    love.graphics.circle(rect.x + 40, rect.y + 40, 40)
                    love.graphics.print("K", rect.x + 40, rect.y + 40)
                elseif board[i][j] == checker.O_KING then
                    love.graphics.setColor(unpack(colors.O))
                    love.graphics.circle(rect.x + 40, rect.y + 40, 40)
                    love.graphics.print("K", rect.x + 40, rect.y + 40)
                end
                love.graphics.setColor(1, 1, 1, 1)
            end        
        end
    end
end