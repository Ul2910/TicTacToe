-- Author: Uliana Gubanova (github username: ul2910)

--[[ 

]]--

function check_if_finish()
	local i = 1
	-- Check horizontal lines
	while i < #board do
		for j = 1, board_size - 1 do
			if board[i] ~= board[i + j] or board[i] == '' then break end
			if j == board_size - 1 then result_generation('horizontal', board[i], math.floor(i / board_size + 1)) return end
		end		
		i = i + board_size
	end
	-- Check vertical lines
	for i = 1, board_size do
		for j = 1, board_size - 1 do
			if board[i] ~= board[i + board_size * j] or board[i] == '' then break end
			if j == board_size - 1 then result_generation('vertical', board[i], i) return end
		end
	end
	-- Check diagonal lines
	for i = 1, board_size - 1 do
		if board[1] ~= board[1 + i * (board_size + 1)] or board[1] == '' then break end
		if i == board_size - 1 then result_generation('diagonal', board[1], 1) return end
	end
	for i = 1, board_size - 1 do
		if board[board_size] ~= board[board_size + i * (board_size - 1)] or board[board_size] == '' then break end
		if i == board_size - 1 then result_generation('diagonal', board[board_size], board_size) return end
	end
end

function result_generation(line_type, winner_sign, cell)
	if winner_sign == 'x' then result = 'Player One wins!'
	else result = 'Player Two wins!' end
	state = 'finish'
	start_finish_sound:play()
	crossline_type = line_type
	crossline_cell = cell
end

