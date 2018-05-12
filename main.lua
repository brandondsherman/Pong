push = require 'libs/push'
Class = require 'libs/class'



WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

function love.load()

    require 'obj/Paddle'
    require 'obj/Ball'

    love.graphics.setDefaultFilter('nearest', 'nearest')

    math.randomseed(os.time())

    font = love.graphics.newFont('data/font.ttf', 8)
    fontBig = love.graphics.newFont('data/font.ttf', 32)

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT,{
        fullscreen = false,
        resizable = false,
        vsync = true
    })

    player1Score = 0
    player2Score = 0

    player1 = Paddle(10,30,5,20)
    player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)

    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)
    ball:reset()
    header = 'press space'
    gameState = 'start'
end

function love.update(dt)
        
    if love.keyboard.isDown('w') then
        player1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('s') then
        player1.dy = PADDLE_SPEED
    else
        player1.dy = 0
    end

    if love.keyboard.isDown('up') then
        player2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then
        player2.dy = PADDLE_SPEED
    else
        player2.dy = 0
    end
    if gameState == 'play' then
        ball:update(dt)
    end

    player1:update(dt)
    player2:update(dt)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'space' then
        --print(tostring(gameState))
        if gameState == 'start' then
            ball:reset()
            gameState = 'play'
            header = 'P O N G'
        else
            gameState = 'start'
            header = 'P A U S E D'
        end    
    end
end

function love.draw()
    push:apply('start')

    love.graphics.clear(40,45,52,255)

    love.graphics.setFont(font)

    love.graphics.printf(
         header, 0, 20, VIRTUAL_WIDTH, 'center'
    )

    love.graphics.setFont(fontBig)
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, 
    VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30,
    VIRTUAL_HEIGHT / 3)

    player1:draw()
    player2:draw()
    ball:draw()

    push:apply('end')
end