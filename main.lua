push = require 'libs/push'
Class = require 'libs/class'



WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200
BALL_ACCELERATION = 1.03

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
    love.window.setTitle('P O N G')
    player1Score = 0
    player2Score = 0

    player1 = Paddle(10, 30, 5, 20)
    player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)

    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)
    if ball.dx < 0 then
        servingPlayer = 2
    else 
        servingPlayer = 1
    end
    gameState = ''
    changeGameState('start')
end

function love.update(dt)
        
    handleInput(dt)


    if gameState == 'play' then
        ball:update(dt)
    end

    player1:update(dt)
    player2:update(dt)

    if isColliding(player1, ball) then
        ball:collidedWithPaddle(player1)
    end
    if isColliding(player2, ball) then
        ball:collidedWithPaddle(player2)    
    end

    if ball.x + ball.width < 0 then
        servingPlayer = 2
        player2Score = player2Score + 1
        changeGameState('serve')
    end

    if ball.x > VIRTUAL_WIDTH then
        servingPlayer = 1
        player1Score = player1Score + 1
        changeGameState('serve')
    end
    
    
end

function handleInput(dt)

    --[[if gameState == 'start' then
        if love.keyboard.isDown('space') then
            changeGameState('play')
        end
    end

    if gameState == 'paused' then
        if love.keyboard.isDown('space') then
            changeGameState('play')
        end
    end
    ]]--

    if gameState == 'serve' then
        --[[if love.keyboard.isDown('space') then
            changeGameState('play')
        end]]--

        if servingPlayer == 1 then
            if love.keyboard.isDown('w') then
                ball.y = ball.y - 1
            elseif love.keyboard.isDown('s') then
                ball.y = ball.y + 1
            elseif love.keyboard.isDown('up') then
                player2.dy = -PADDLE_SPEED
            elseif love.keyboard.isDown('down') then
                player2.dy = PADDLE_SPEED
            else
                player2.dy = 0
            end
        else
            if love.keyboard.isDown('up') then
                ball.y = ball.y - 1
            elseif love.keyboard.isDown('down') then
                ball.y = ball.y + 1
            elseif love.keyboard.isDown('w') then
                player1.dy = -PADDLE_SPEED
            elseif love.keyboard.isDown('s') then
                player1.dy = PADDLE_SPEED
            else
                player1.dy = 0
            end
        end
    end

    if gameState == 'play' then
        --[[if love.keyboard.isDown('space') then
            changeGameState('paused')
        end]]--

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
    end
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'space' then
        --print(tostring(gameState))
        if gameState == 'start' or gameState == 'paused' or gameState == 'serve' then
            changeGameState('play')
        else
            changeGameState('paused')
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
    love.graphics.printf(
        tostring(love.timer.getFPS()), 0, 0, VIRTUAL_WIDTH, 'right'
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

function isColliding(rect1, rect2)
    return rect1.x <= rect2.x + rect2.width and
        rect1.x + rect1.width >= rect2.x and
        rect1.y <= rect2.y + rect2.height and
        rect1.y + rect1.height >= rect2.y
end


function changeGameState(newState)
    gameState = newState
    if newState == 'start' then
        header = 'press space'
    end

    if newState == 'paused' then
        header = 'P A U S E D'
    end
    
    if newState == 'play' then
        local yOffset = ball.y - VIRTUAL_HEIGHT / 2 - (ball.height / 2)
        ball:reset(yOffset)
        header = 'P O N G'
    end

    if newState == 'serve' then
        ball:reset(0)
        header = 'P' .. tostring(servingPlayer) .. ' Serving'
    end
end