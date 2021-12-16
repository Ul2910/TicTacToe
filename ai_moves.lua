-- Author: Uliana Gubanova (github username: ul2910)

--[[ 
	Computer move algorithm
]]--

MINIMUM = -1000
MAXIMUM = 1000

function ai_move()
	if board_size > 3 and #board - empty_cells_left() < 4 then
		board[rand_empty_cell()] = players[current_player]
		sign_sound:play()
		change_current_player()
		return
	elseif board_size == 5 and #board - empty_cells_left() < 13 then
		board[dont_let_him_win()] = players[current_player]
		sign_sound:play()
		change_current_player()
		return
	end
	local max_result = -1000
    local best_index = -1
    local board_copy = {}
   	for i = 1, #board do
    	board_copy[i] = board[i]
    end
    if current_player == 2 then enemy = 1 
 	else enemy = 2 end
    for i = 1, #board_copy do
        if board_copy[i] == '' then
            board_copy[i] = players[current_player]
			local current_result = minimax(0, board_copy, false, MINIMUM, MAXIMUM)
 			board_copy[i] = ''
 			if current_result > max_result then
                best_index = i
                max_result = current_result
            end
        end
    end
    board[best_index] = players[current_player]
    sign_sound:play()
	change_current_player()
end

-- Minimax recursive algorithm with alpha-beta pruning
function minimax(depth, board_copy, is_max, alpha, beta)
	local result1 = board_analizer(board_copy)
	-- Base case for recursion
    if result1 == 10 then
    	return 10 - depth
    elseif result1 == 0 then
    	return 0
    elseif result1 == -10 then
        return depth - 10
    end

 	depth = depth + 1
    if is_max == true then 
    	local best = MINIMUM
    	for i = 1, #board_copy do
    		if board_copy[i] == '' then 
    			board_copy[i] = players[current_player]
    			best = math.max(best, minimax(depth, board_copy, false, alpha, beta))
    			board_copy[i] = ''
    			alpha = math.max(alpha, best)
 				if beta <= alpha then
                	break
                end
    		end
    	end
    	return best
    elseif is_max == false then 
    	local best = MAXIMUM
    	for i = 1, #board_copy do
    		if board_copy[i] == '' then 
    			board_copy[i] = players[enemy]
    			best = math.min(best, minimax(depth, board_copy, true, alpha, beta))
    			board_copy[i] = ''
    			beta = math.min(beta, best)
 				if beta <= alpha then
                	break
                end
    		end
    	end
    	return best
    end
end

-- Check if virtual game inside the algorithm is over and there is a winner or it's a tie
function board_analizer(board_copy)
	local i = 1
	-- Check horizontal lines
	while i < #board_copy do
		for j = 1, board_size - 1 do
			if board_copy[i] ~= board_copy[i + j] or board_copy[i] == '' then break end
			if j == board_size - 1 then return result_score(board_copy[i]) end
		end		
		i = i + board_size
	end
	-- Check vertical lines
	for i = 1, board_size do
		for j = 1, board_size - 1 do
			if board_copy[i] ~= board_copy[i + board_size * j] or board_copy[i] == '' then break end
			if j == board_size - 1 then return result_score(board_copy[i]) end
		end
	end
	-- Check diagonal lines
	for i = 1, board_size - 1 do
		if board_copy[1] ~= board_copy[1 + i * (board_size + 1)] or board_copy[1] == '' then break end
		if i == board_size - 1 then return result_score(board_copy[1]) end
	end
	for i = 1, board_size - 1 do
		if board_copy[board_size] ~= board_copy[board_size + i * (board_size - 1)] or board_copy[board_size] == '' then break end
		if i == board_size - 1 then return result_score(board_copy[board_size]) end
	end
	if no_moves_left(board_copy) == true then return 0
	else return 55 end
end

function no_moves_left(board_copy)
	for i = 1, #board_copy do
		if board_copy[i] == '' then return false end
	end
	return true
end

function result_score(winner_sign)
	if winner_sign == players[current_player] then return 10
	else return -10 end
end

function empty_cells_left()
	local counter = 0
	for i = 1, #board do
		if board[i] == '' then counter = counter + 1 end
	end
	return counter
end

function rand_empty_cell()
	math.randomseed(os.time())
	local empty_cells = {}
	for i = 1, #board do
		if board[i] == '' then table.insert(empty_cells, i) end
	end
	return empty_cells[math.random(#empty_cells)]
end

-- Check rows, columns and diagonals and count opponent signs in each
function dont_let_him_win()
	if players[current_player] == 'x' then oppon_sign = 'o'
	else oppon_sign = 'x' end
	local counter = {} -- 1-5 for rows, 6-10 for columns, 11-12 for diagonals
	local x = 1
	for i = 1, 12 do
		counter[i] = 0
	end
	-- Count opponent signs in evey row
	for i = 1, 25, 5 do
		for j = 1, 5 do
			if board[i + j - 1] == oppon_sign then counter[x] = counter[x] + 1 end
			if board[i + j - 1] == players[current_player] then counter[x] = 0 break end 
		end		
		x = x + 1
	end
	-- Count opponent signs in evey column
	for i = 1, 5 do
		for j = 1, 5 do
			if board[i + 5 * (j - 1)] == oppon_sign then counter[x] = counter[x] + 1 end
			if board[i + 5 * (j - 1)] == players[current_player] then counter[x] = 0 break end 
		end
		x = x + 1
	end
	-- Count opponent signs in diagonals
	for i = 1, 25, 6 do
		if board[i] == oppon_sign then counter[11] = counter[11] + 1 end 
		if board[i] == players[current_player] then counter[11] = 0 break end 
	end
	for i = 5, 21, 4 do
		if board[i] == oppon_sign then counter[12] = counter[12] + 1 end 
		if board[i] == players[current_player] then counter[12] = 0 break end 
	end
	local max_counter = math.max(unpack(counter))
	for i = 1, 12 do
		if max_counter == counter[i] then 
			return choose_cell(i)
		end
	end
end

-- Place sign in the row/column/diagonal with most opponent signs
function choose_cell(counter_index)
	if counter_index < 6 then
		for i = counter_index * 5 - 4, counter_index * 5 do
			if board[i] == '' then return i end
		end
	elseif counter_index < 11 then
		for i = counter_index - 5, counter_index + 15, 5 do
			if board[i] == '' then return i end
		end
	elseif counter_index == 11 then
		for i = 1, 25, 6 do
			if board[i] == '' then return i end
		end
	elseif counter_index == 12 then
		for i = 5, 21, 4 do
			if board[i] == '' then return i end
		end
	end
	return rand_empty_cell()
end