Paddle = Class{}

function Paddle:init(x, y, width, height)
    
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    self.dy = 0

end

function Paddle:update(dt)
    self.y = math.min(VIRTUAL_HEIGHT - self.height, math.max(0, self.y + self.dy * dt))
end

function Paddle:draw()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end

