-- Author: Uliana Gubanova (github username: ul2910)

--[[ 

]]--

board_size = 3
board = {}
modes = {'human vs human', 'human vs computer', 'computer vs computer'}
current_mode = 1
players = {'x', 'o'}
current_player = 1
state = 'start' -- can be 'start', 'game', 'finish'
result = 'dfsdfsf' -- can be 'Player One wins!', 'Player Two wins!', 'It's a tie!'

function love.load()
	background = love.graphics.newImage("images/pexels-vojta-kovařík-1275415.jpg")
	font90 = love.graphics.newFont(90)
	font38 = love.graphics.newFont(38)
	font32 = love.graphics.newFont(32)
	font20 = love.graphics.newFont(20)
end

-- Drawing the start screen
function draw_start_finish()	
	love.graphics.setColor(1, 0.8, 0.6, 0.7)
	love.graphics.rectangle('fill', 540, 550, 200, 50, 10, 10, 5)
	if state == 'start' then
		love.graphics.setColor(1, 0.8, 0.6, 0.7)
		love.graphics.rectangle('fill', 440, 100, 400, 400, 10, 10, 5)
		love.graphics.setFont(font32)
		love.graphics.setColor(0, 0, 0)
		love.graphics.print('PLAY', 600, 555)
		love.graphics.print('Choose board size:', 450, 100)
		love.graphics.print('Choose mode:', 450, 300)
		love.graphics.setFont(font20)
		for i = 1, 3 do
			if (i + 2) == board_size then love.graphics.setColor(0.3, 0.5, 0.1) love.graphics.rectangle('line', 450, 100 + i * 40, 250, 35, 10, 10, 5) end
			love.graphics.setColor(0, 0, 0)
			love.graphics.print((i + 2)..' x '..(i + 2), 460, 105 + i * 40)
		end			
		for i = 1, #modes do	
			if i == current_mode then love.graphics.setColor(0.3, 0.5, 0.1) love.graphics.rectangle('line', 450, 300 + i * 40, 250, 35, 10, 10, 5) end
			love.graphics.setColor(0, 0, 0)
			love.graphics.print(modes[i], 460, 305 + i * 40)
		end		
	else
		love.graphics.setColor(1, 0.8, 0.6)
		love.graphics.print(result, 50, board_y)
		love.graphics.setColor(0, 0, 0)
		love.graphics.setFont(font32)
		love.graphics.print('PLAY AGAIN', 545, 555)
	end
end

function love.focus(f) gameIsPaused = not f end

function love.update(dt)
	if gameIsPaused then return end
	dt = math.min(dt, 0.07)
	
end

function love.draw()
	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(background, 0, 0)
	love.graphics.setFont(font38)
	love.graphics.setColor(1, 0.8, 0.6)
	love.graphics.print('Tic Tac Toe', 530, 20)

	if state == 'game' then
		-- Print info: mode and whose turn it is now
		if current_player == 1 then love.graphics.print('Player One\'s turn', 50, board_y)
		else love.graphics.print('Player Two\'s turn', 50, board_y) end
		love.graphics.setFont(font20)
		love.graphics.print('mode: '..modes[current_mode], board_x, board_y - 30)
		draw_board()
	else
		draw_start_finish()
	end

	love.graphics.setFont(font20)
	love.graphics.setColor(1, 1, 1)
	love.graphics.print('Developed by Uliana (github: ul2910)', 880, 680)	
end

function draw_board()
	love.graphics.setColor(1, 0.8, 0.6)
	love.graphics.rectangle('fill', board_x, board_y, 100 * board_size, 100 * board_size)
	love.graphics.setColor(0.8, 0.1, 1)
	local x = board_x
	local y = board_y
	-- Draw cells
	for i = 1, board_size do
		for j = 1, board_size do
			love.graphics.rectangle('line', x, y, 100, 100)
			x = x + 100
		end
		x = x - 100 * board_size
		y = y + 100
	end
	x = board_x
	y = board_y
	-- Draw signs inside the cells
	love.graphics.setFont(font90)
	for i = 1, board_size do
		for j = 1, board_size do
			love.graphics.print(board[(i - 1) * board_size + j], x + 22, y - 10)
			x = x + 100
		end
		x = x - 100 * board_size
		y = y + 100
	end
end

-- If current player presses on an empty cell then we draw there player's sign (x or o)
function love.mousepressed(mouse_x, mouse_y, button, istouch)
   	if button == 1 and state == 'game' then
   		if mouse_x > board_x and mouse_x < board_x + board_size * 100 
   		and mouse_y > board_y and mouse_y < board_y + board_size * 100 then
   			local x_index = math.floor((mouse_x - board_x) / 100 + 1)
   			local y_index = math.floor((mouse_y - board_y) / 100 + 1)
   			local cell_index = (y_index - 1) * board_size + x_index
   			if board[cell_index] == '' then board[cell_index] = players[current_player] end
   			if current_player == 1 then current_player = 2 else current_player = 1 end
   		end
   	elseif button == 1 and state == 'start' 
   		and mouse_x > 450 and mouse_x < 700 
   		and mouse_y > 140 and mouse_y < 460 then
	   		if mouse_y < 260 then
	   			board_size = math.floor((mouse_y - 140) / 40 + 3)
	   		elseif mouse_y > 340 then
	   			current_mode = math.floor((mouse_y - 340) / 40 + 1)
	   		end
   	elseif button == 1 and mouse_x > 540 and mouse_x < 740
   		and mouse_y > 550 and mouse_y < 600 then
   			if state == 'finish' then
   				love.event.quit('restart')
   			elseif state == 'start' then
   				board_x = 640 - board_size/2 * 100
				board_y = 360 - board_size/2 * 100
				for i = 1, board_size * board_size do board[i] = ''	end
				state = 'game'
   			end 
   	end
end

function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	end
end