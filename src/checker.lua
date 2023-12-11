X = "X" --player 1
O = "O" -- player 2
X_KING = "XK"
O_KING = "OK"
EMPTY = nil
PLAYERS = {X, O} --X will get to start first
KINGS = {
    [X] = X_KING,
    [O] = O_KING
}
COUNT_X = 12
COUNT_O = 12

TOURANMENT = false
--create local history and move count
HISTORY = {}
MOVE_COUNT = 0


function initial_state()
    local board = {}
    
    for i = 1, 8 do
        board[i] = {}
        for j = 1, 8 do
            -- Place player(board) and O on alternate squares
            if (i + j) % 2 == 0 then
                if i <= 3 then
                    board[i][j] = X  -- Player 1 piece
                elseif i >= 6 then
                    board[i][j] = O  -- Player 2 piece
                else
                    board[i][j] = EMPTY  -- Empty square
                end
            else
                board[i][j] = EMPTY  -- Empty square
            end
        end
    end
    
    return board
end

function player(board)
    local count_X = 0
    local count_O = 0
    
    for i = 1, 8 do
        for j = 1, 8 do
            if board[i][j] == X then
                count_X = count_X + 1
            elseif board[i][j] == O then
                count_O = count_O + 1
            end
        end
    end
    
    -- Determine whose move it is based on the counts
    if count_X == count_O then
        return X  -- Player 1's move
    else
        return O  -- Player 2's move
    end
end

function jump_moves(board, i, j, play, current_moves)
    local possible_moves = current_moves or {}
    local turn = play or player(board)

    if board[i][j] == turn or board[i][j] == KINGS[turn] then
        -- Check possible jumps for Player 1 (player(board))
        local jump_moves

        if board[i][j] == X then
            jump_moves = {
                {i - 2, j - 2},
                {i - 2, j + 2}
            }
        elseif board[i][j] == O then
            jump_moves = {
                {i + 2, j - 2},
                {i + 2, j + 2}
            }
        else
            jump_moves = {
                {i - 2, j - 2},
                {i - 2, j + 2},
                {i + 2, j - 2},
                {i + 2, j + 2}
            }
        end  

        for _, jump in ipairs(jump_moves) do
            local new_i, new_j = unpack(jump)
            
            -- Check if the new position is within the board boundaries
            if new_i >= 1 and new_i <= 8 and new_j >= 1 and new_j <= 8 then

                --opponent
                local opponent = turn == X and O or X

                -- Check if the new position is an opponent's piece that can be jumped
                if board[new_i][new_j] == opponent then
                    local jump_over_i, jump_over_j = (i + new_i) / 2, (j + new_j) / 2
                    
                    -- Check if the square between the current position and the new position is empty
                    if board[jump_over_i][jump_over_j] == EMPTY then
                        local new_moves = {unpack(possible_moves)}
                        table.insert(new_moves, jump)

                        
                        -- Recursively call the function to find additional jumps
                        local next_moves = jump_moves(board, new_i, new_j, new_moves)
                        
                        for _, next_move in ipairs(next_moves) do
                            table.insert(possible_moves, next_move)
                        end
                    end
                end
            end
        end
    end

    return possible_moves
end

function diagonal_moves(board, i, j, turn)
    local possible_moves = {}
    local play = turn or player(board)

    if board[i][j] == play or board[i][j] == KINGS[play] then
        -- Check possible moves for (player(board))
        local diagonal_moves
        if board[i][j] == X then
            diagonal_moves = {
                {i - 1, j - 1},
                {i - 1, j + 1}
            }
        elseif board[i][j] == O then
            diagonal_moves = {
                {i + 1, j - 1},
                {i + 1, j + 1}
            }
        else
            diagonal_moves = {
                {i - 1, j - 1},
                {i - 1, j + 1},
                {i + 1, j - 1},
                {i + 1, j + 1}
            }
        end

        for _, move in ipairs(diagonal_moves) do
            local new_i, new_j = unpack(move)
            
            -- Check if the new position is within the board boundaries
            if new_i >= 1 and new_i <= 8 and new_j >= 1 and new_j <= 8 then
                -- Check if the new position is empty
                if board[new_i][new_j] == EMPTY then
                    table.insert(possible_moves, move)
                end
            end
        end
    end

    return possible_moves
end


function actions(board, play)
    -- Returns a set of all possible actions available on the board.
    local moves = {}

    local turn = play or player(board)
    for i, row in ipairs(board) do
        for j, _ in ipairs(row) do
            if board[i][j] == turn then
                local jump_moves_result = jump_moves(board, i, j, play)
                local diagonal_moves_result = diagonal_moves(board, i, j, play)

                if #jump_moves_result > 0 then
                    moves[{i, j}] = jump_moves_result
                else
                    moves[{i, j}] = diagonal_moves_result
                end
            end
        end
    end

    return moves
end


function result(board, action)
    --the action is in the form {{i, j}, {ni, nj}}
    local newBoard = board

    local i, j = unpack(action[1])
    local ni, nj = unpack(action[2])

    if newBoard[ni][nj] == EMPTY then
        if player(board) == X and ni == 1 then
            newBoard[ni][nj] = X_KING
        elseif player(board) == O and ni == 8 then
            newBoard[ni][nj] = O_KING
        else
            newBoard[ni][nj] = player(board)
            newBoard[i][j] = EMPTY
        end
    else
        return EMPTY
    end
end

function are_positions_equal(board1, board2)
    -- Check if two board positions are equal
    for i, row in ipairs(board1) do
        for j, piece in ipairs(row) do
            if piece ~= board2[i][j] then
                return false
            end
        end
    end

    return true
end

function check_stale(board, play) --this checks if enemey is not able to make moves or not
    local turn = (play == X) and O or X
    local acts = actions(board, turn)
    if #acts == 0 then
        return true
    else
        return false
    end
end

function is_threefold_repetition(board, history)
    -- Check if the current board position has occurred three times
    local count = 0
    for _, past_board in ipairs(history) do
        if are_positions_equal(board, past_board) then
            count = count + 1
            if count == 3 then
                return true  -- Threefold repetition, it's a draw
            end
        end
    end

    return false
end

-- function is_fifty_move_rule(board, move_count)
--     -- Check if fifty moves have been made without any captures
--     if move_count >= 100 and COUNT_X then
--         return true  -- Fifty-move rule without capture, it's a draw
--     end

--     return false
-- end

function check_draws(board) -- this check draws and tournament rules are not included yet
    return is_threefold_repetition(board, HISTORY) --or is_fifty_move_rule(board, MOVE_COUNT)
end

function winner(board)
    if COUNT_X == 0 or check_stale(board, O) then
        return X
    elseif COUNT_O == 0 or check_stale(board, X) then
        return O
    else
        return EMPTY
    end
end

function terminal(board)
    return winner(board) or check_draws(board)
end

function utility(board)
    if winner(board) == X then
        return 1
    elseif winner(board) == O then
        return -1
    else
        return 0
    end
end

function min_value(board, alpha, beta, depth)
    if terminal(board) or depth == 0 then
        if terminal(board) then
            return {EMPTY, utility(board)}
        else
            return {EMPTY, evaluate_board(board)}
        end
    end

    local min_value = math.huge
    local best_action = EMPTY
    local actions_list = actions(board, O)

    for location, action in pairs(actions_list) do
        local result_value = max_value(result(board, {location, action}), alpha, beta, depth - 1)

        local value = result_value[2]  -- Use the second element of the result_value table
        if value < min_value then
            min_value = value
            best_action = action
        end

        beta = math.min(beta, min_value)
        if beta <= alpha then
            break
        end
    end

    return {best_action, min_value}
end

function max_value(board, alpha, beta, depth)
    if terminal(board) then
        return {EMPTY, utility(board)}
    end

    local max_value = -math.huge
    local best_action = EMPTY
    local actions_list = actions(board, X)

    for _, action in pairs(actions_list) do
        local result_value = min_value(result(board, action), alpha, beta, depth - 1)

        local value = result_value[2]  -- Use the second element of the result_value table
        if value > max_value then
            max_value = value
            best_action = action
        end

        alpha = math.max(alpha, max_value)
        if beta <= alpha then
            break
        end
    end

    return {best_action, max_value}
end 

function minimax(board, depth)
    local result_value
    if player(board) == X then
        result_value = max_value(board, -math.huge, math.huge, depth)
        return result_value[1]
    else
        result_value = min_value(board, -math.huge, math.huge, depth)
        return result_value[1]
    end
end--I want to implement depth-limited min-max algorithm

function evaluate_board(board)
    local evaluation = 0

    -- Material Count
    for i, row in ipairs(board) do
        for j, piece in ipairs(row) do
            if piece == X then
                evaluation = evaluation + 1
            elseif piece == O then
                evaluation = evaluation - 1
            elseif piece == X_KING then
                evaluation = evaluation + 2
            elseif piece == O_KING then
                evaluation = evaluation - 2
            end
        end
    end

    -- Piece Mobility
    local mobility_X = count_piece_mobility(board, X)
    local mobility_O = count_piece_mobility(board, O)
    evaluation = evaluation + (mobility_X - mobility_O)

    -- King Safety (simple assessment based on their row)
    evaluation = evaluation + king_safety(board)

    -- Pawn Structure
    evaluation = evaluation + pawn_structure(board)

    -- Control of the Center
    evaluation = evaluation + control_of_center(board)

    -- Forced Jumps and Double Jumps
    evaluation = evaluation + count_forced_jumps(board, X) - count_forced_jumps(board, O)

    return evaluation
end

function count_piece_mobility(board, player)
    local mobility = 0

    -- Count available moves for each piece
    for i, row in ipairs(board) do
        for j, piece in ipairs(row) do
            if piece == player then
                local moves
                local jump_moves_result = jump_moves(board, i, j)
                local diagonal_moves_result = diagonal_moves(board, i, j)

                if #jump_moves_result > 0 then
                    moves = jump_moves_result
                else
                    moves = diagonal_moves_result
                end
                mobility = mobility + #moves
            end
        end
    end

    return mobility
end

function king_safety(board)
    local king_safety_X = 0
    local king_safety_O = 0

    for i, row in ipairs(board) do
        for j, piece in ipairs(row) do
            if piece == X_KING then
                king_safety_X = king_safety_X + i
            elseif piece == O_KING then
                king_safety_O = king_safety_O + (8 - i + 1)
            end
        end
    end

    return king_safety_X - king_safety_O
end

function pawn_structure(board)
    local pawn_structure_X = 0
    local pawn_structure_O = 0

    for i, row in ipairs(board) do
        for j, piece in ipairs(row) do
            if piece == X then
                pawn_structure_X = pawn_structure_X + i
            elseif piece == O then
                pawn_structure_O = pawn_structure_O + (8 - i + 1)
            end
        end
    end

    return pawn_structure_X - pawn_structure_O
end

function control_of_center(board)
    local center_control_X = 0
    local center_control_O = 0

    for i = 4, 5 do
        for j = 1, 8 do
            if board[i][j] == X then
                center_control_X = center_control_X + 1
            elseif board[i][j] == O then
                center_control_O = center_control_O + 1
            end
        end
    end

    return center_control_X - center_control_O
end

function count_forced_jumps(board, player)
    local forced_jumps = 0

    for i, row in ipairs(board) do
        for j, piece in ipairs(row) do
            if piece == player then
                local jump_moves_result = jump_moves(board, i, j)
                if #jump_moves_result > 0 then
                    forced_jumps = forced_jumps + 1
                end
            end
        end
    end

    return forced_jumps
end
        






