Ball = Class{}

function Ball:init(x,y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    self.dx = math.random(2) == 1 and 100 or -100
    self.dy = math.random(-50, 50)

end

function Ball:reset()
    self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)
    self.dx = math.random(2) == 1 and 100 or -100
    self.dy = math.random(-50, 50)
end

function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt

    if ball.y < 0 then
        self.dy = -1 * self.dy
    elseif ball.y > VIRTUAL_HEIGHT - ball.height then
        self.dy = -1 * self.dy
    elseif ball.x < 0 then

    elseif ball.x > VIRTUAL_WIDTH then

    end
end

function Ball:draw()
    if gameState == 'play' then
        love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
    end
end

function Ball:collidedWithPaddle(player)
    if self.dx < 0 then
        self.x = player.x + player.width + .1
    elseif self.dx > 0 then
        self.x = player.x - self.width - .1
    end
    self.dx = -self.dx * BALL_ACCELERATION
    
    
    if self.dy < 0 then
        self.dy = -1 * math.random(10,150)
    else
        self.dy = math.random(10,150)
    end

end