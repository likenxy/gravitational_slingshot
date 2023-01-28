local Planet = {}

function Planet:new(x, y, r, m, world, imgPath)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    local w = world:newCircleCollider(x, y, r)
    obj.w = w
    obj.w:setMass(m)
    obj.w:setObject(self)

    obj.m = m
    obj.r = r
    obj.d = r * 2

    -- 加载材质
    print(imgPath)
    obj.img = love.graphics.newImage(imgPath)

    -- 保存引力
    obj.fx = 0
    obj.fy = 0

    return obj
end

function Planet:getPosition()
    return self.w:getX(), self.w:getY()
end

function Planet:draw()
    local x, y = self:getPosition()
    local function stencil()
        love.graphics.circle("fill", x, y, self.r)
    end

    love.graphics.stencil(stencil)
    love.graphics.setStencilTest("greater", 0)

    local w, h = self.img:getWidth(), self.img:getHeight()
    local sx, sy = self.d / w , self.d / h  

    local angle = self.w:getAngle()
    love.graphics.draw(self.img, x, y, angle, sx, sy, w / 2, h / 2)
    love.graphics.setStencilTest()

    -- 绘制引力
    love.graphics.line(x, y, x+self.fx/10, y+self.fy/10)
end

return Planet