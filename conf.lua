function love.conf(t)
    t.window.width = 1280
    t.window.height = 720
    t.window.title = "Tic Tac Toe"   
    t.version = "11.3"  -- The LÖVE version this game was made for
    t.modules.joystick = false
    t.modules.physics = false
    t.modules.thread = false
    t.modules.touch = false
    t.modules.video = false
end