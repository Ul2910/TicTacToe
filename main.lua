-- Author: Uliana Gubanova (github username: ul2910)

--[[ 
	Callback functions, loading fonts, images, sounds,
	drawing, mouse and esc handling, changing player
]]--

require("finish_check")
require("ai_moves")

board_size = 3
board = {}
modes = {'human vs human', 'human vs computer', 'computer vs computer'}
current_mode = 1
players = {'x', 'o'}
current_player = 1
state = 'start' -- can be 'start', 'game', 'finish'
result = '' -- can be 'Player One wins!', 'Player Two wins!', 'It's a tie!'
computer_move = false
crossline_type = ''
crossline_cell = 1
timer = 0.5

function love.load()
	background = love.graphics.newImage("images/pexels-vojta-kovarik-1275415.jpg")
	sign_sound = love.audio.newSource("sounds/458867__raclure__damage-sound-effect.mp3", 'static')
	start_finish_sound = love.audio.newSource("sounds/243020__plasterbrain__game-start.ogg", 'static')
	font90 = love.graphics.newFont(90)
	font38 = love.graphics.newFont(38)
	font32 = love.graphics.newFont(32)
	font20 = love.graphics.newFont(20)
	font16 = love.graphics.newFont(16)
end

-- Drawing the start screen
function draw_start_finish()	
	love.graphics.setColor(1, 0.8, 0.6, 0.7)
	love.graphics.rectangle('fill', 540, 630, 200, 50, 10, 10, 5)
	if state == 'start' then
		love.graphics.setColor(1, 0.8, 0.6, 0.7)
		love.graphics.rectangle('fill', 440, 100, 400, 400, 10, 10, 5)
		love.graphics.setFont(font32)
		love.graphics.setColor(0, 0, 0)
		love.graphics.print('PLAY', 600, 635)
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
		love.graphics.print(result, 30, board_y)
		love.graphics.setColor(0, 0, 0)
		love.graphics.setFont(font32)
		love.graphics.print('PLAY AGAIN', 545, 635)
	end	
end

function love.focus(f) gameIsPaused = not f end

-- There is 0.5 sec delay before computer's move
function love.update(dt)
	if gameIsPaused then return end
	dt = math.min(dt, 0.07)
	if computer_move == true and state == 'game' then 
		if timer < 0 then timer = 0.5 ai_move() 
		else timer = timer - 1 * dt end
	end
end

function love.draw()
	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(background, 0, 0)
	love.graphics.setFont(font38)
	love.graphics.setColor(1, 0.8, 0.6)
	love.graphics.print('Tic Tac Toe', 530, 20)

	if state == 'game' then
		-- Print info: mode and whose turn it is now
		if current_player == 1 then love.graphics.print('Player One\'s turn', 30, board_y)
		else love.graphics.print('Player Two\'s turn', 30, board_y) end
	else 
		draw_start_finish() 
	end

	if state ~= 'start' then
		love.graphics.setFont(font20)
		love.graphics.setColor(1, 0.8, 0.6)
		love.graphics.print('mode: '..modes[current_mode], board_x, board_y - 30)
		love.graphics.setFont(font32)
		local start_index, end_index = string.find(modes[current_mode], "%w+ %w+ ")
		love.graphics.print('Player One: '..modes[current_mode]:gmatch("%w+")(), board_x + 100 * board_size + 20, board_y)
		love.graphics.print('Player Two: '..string.sub(modes[current_mode], end_index + 1), board_x + 100 * board_size + 20, board_y + 50)
		draw_board()
	end

	love.graphics.setFont(font20)
	love.graphics.setColor(1, 1, 1)
	love.graphics.print('Developed by Uliana (github: ul2910)', 880, 680)
	love.graphics.setFont(font16)
	love.graphics.setColor(1, 1, 1)
	love.graphics.print('Photo by Vojta Kovarík from pexels.com', 20, 630)	
	love.graphics.print('Sounds:', 20, 650)
	love.graphics.print('by Raclure from freesound.org', 30, 670)
	love.graphics.print('by plasterbrain from freesound.org', 30, 690)
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
			if board[(i - 1) * board_size + j] == 'x' then love.graphics.setColor(0.8, 0.1, 1)
			else love.graphics.setColor(0.3, 0.5, 0.1) end
			love.graphics.print(board[(i - 1) * board_size + j], x + 22, y - 10)
			x = x + 100
		end
		x = x - 100 * board_size
		y = y + 100
	end
	if state == 'finish' and result ~= 'It\'s a tie!' then draw_crossline() end
end

-- Draw a line crossing the winner's combination
function draw_crossline()
	love.graphics.setColor(0, 0, 0)
	local x, y, length, height
	if crossline_type == "horizontal" then
		x = board_x + 5
		y = board_y + crossline_cell * 100 - 55
		length = 100 * board_size - 10
		height = 10
	elseif crossline_type == "vertical" then
		x = board_x + crossline_cell * 100 - 55
		y = board_y + 5
		length = 10
		height = 100 * board_size - 10
	else
		local angle		
		length = 140 * board_size - 15
		height = 10
		if crossline_cell == 1 then
			x = board_x + 10
			y = board_y + 5
			angle = 0.7854
		else
			x = board_x + 5
			y = board_y + crossline_cell * 100 - 10
			angle = -0.7854
		end
		love.graphics.push()
		love.graphics.translate(x, y)
		love.graphics.rotate(angle)
		love.graphics.rectangle('fill', 0, 0, length, height)
		love.graphics.pop()
		return
	end
	love.graphics.rectangle('fill', x, y, length, height)
end

-- If current player presses on an empty cell then we draw there player's sign (x or o)
function love.mousepressed(mouse_x, mouse_y, button, istouch)
   	if button == 1 and state == 'game' and current_mode < 3 and computer_move == false then
   		if mouse_x > board_x and mouse_x < board_x + board_size * 100 
   		and mouse_y > board_y and mouse_y < board_y + board_size * 100 then
   			local x_index = math.floor((mouse_x - board_x) / 100 + 1)
   			local y_index = math.floor((mouse_y - board_y) / 100 + 1)
   			local cell_index = (y_index - 1) * board_size + x_index
   			if board[cell_index] == '' then 
   				sign_sound:play() 
   				board[cell_index] = players[current_player]
   				change_current_player()
   			end
   		end
   	elseif button == 1 and state == 'start' 
   		and mouse_x > 450 and mouse_x < 700 
   		and mouse_y > 140 and mouse_y < 460 then
	   		if mouse_y < 260 then
	   			board_size = math.floor((mouse_y - 140) / 40 + 3)
	   		elseif mouse_y > 340 then
	   			current_mode = math.floor((mouse_y - 340) / 40 + 1)
	   			if current_mode == 3 or (current_mode == 2 and who_is_first() == 2) then computer_move = true end
	   		end
   	elseif button == 1 and mouse_x > 540 and mouse_x < 740
   		and mouse_y > 630 and mouse_y < 680 then
   			if state == 'finish' then
   				love.event.quit('restart')
   			elseif state == 'start' then
   				board_x = 640 - board_size/2 * 100
				board_y = 360 - board_size/2 * 100
				for i = 1, board_size * board_size do board[i] = ''	end
				if current_mode == 2 and computer_move == true then modes[2] = 'computer vs human' end
				state = 'game'
				start_finish_sound:play()
				-- if computer_move == true then ai_move() end
   			end 
   	end
end

-- If it's human vs computer we randomly choose who is going to be first
function who_is_first()
	math.randomseed(os.time())
	if math.random(2) == 1 then 
		return 1
	else 
		return 2
	end
end

function change_current_player()
	if current_player == 1 then current_player = 2 else current_player = 1 end
	if current_mode == 2 and computer_move == false then computer_move = true
	elseif current_mode == 2 and computer_move == true then computer_move = false end
	check_if_finish()
	-- if computer_move == true and state == 'game' then ai_move() end
end

function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	end
end