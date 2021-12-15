-- Author: Uliana Gubanova (github username: ul2910)

--[[ 

]]--

board_size = 3
board = {}
mode = 1 -- mode 1 - player vs player, mode 2 - player vs computer, mode 3 - computer vs computer
player1 = 'x'
player2 = 'o'
current_player = player1

function love.load()
	background = love.graphics.newImage("images/pexels-miriam-espacio-110854.jpg")
	font90 = love.graphics.newFont(90)
	font20 = love.graphics.newFont(20)
	love.graphics.setFont(font20)
	board_x = 640 - board_size/2 * 100
	board_y = 360 - board_size/2 * 100
	for i = 1, board_size * board_size do board[i] = ''	end
end

-- Drawing the start screen
function draw_start()	
	
end

function love.focus(f) gameIsPaused = not f end

function love.update(dt)
	if gameIsPaused then return end
	dt = math.min(dt, 0.07)
	
end

function love.draw()
	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(background, 0, 0)
	love.graphics.setFont(font20)
	love.graphics.setColor(0.8, 0.1, 1)
	love.graphics.print('Developed by Uliana (github: ul2910)', 880, 680)
	draw_board()
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
   	if button == 1 then
   		if mouse_x > board_x and mouse_x < board_x + board_size * 100 
   		and mouse_y > board_y and mouse_y < board_y + board_size * 100 then
   			local x_index = math.floor((mouse_x - board_x) / 100 + 1)
   			local y_index = math.floor((mouse_y - board_y) / 100 + 1)
   			local cell_index = (y_index - 1) * board_size + x_index
   			if board[cell_index] == '' then board[cell_index] = current_player end
   		end
   	end
end

function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	end
end