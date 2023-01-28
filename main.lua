function love.conf(t)
    t.console = true
end

function love.load()
    Windfield = require "windfield"
    Camera = require "Camera"
    Planet = require "planet"
    Track = require "track"

    WorldW = 1500
    WorldH = 800
    love.window.setMode(WorldW, WorldH)
    Cam = Camera(WorldW / 2, WorldH / 2, WorldW, WorldH, 1.0)

    -- 设置物理引擎
    world = Windfield.newWorld(0, 0, true)
    world:setGravity(0, 0)

    -- 创建地球
    local earthR = 30
    local earchM = 100
    earth = Planet:new(200, 100, earthR, earchM, world, "image/earth.jpg")
    -- 创建木星
    jupiter = Planet:new(800, 400, earthR * 6.8, earchM * 317, world, "image/jupiter.jpg")

    -- 速度计算
    earthPx, earthPy = earth:getPosition()
    earthSpeedX = 0
    earthSpeedY = 0
    maxSpeed = 0
    love.graphics.setNewFont(30)
    info = string.format("speed %f\nmax speed %f", 0, maxSpeed)

    -- 轨迹
    track = Track:new(1000)

end


function love.update(dt)
    Cam:update(dt)
    local jx, jy = jupiter:getPosition()
    Cam:follow(jx, jy)
    world:update(dt)

    local dx, dy = earth:getPosition()
    track:append(dx, dy)
    dx = dx - earthPx
    dy = dy - earthPy
    earthPx, earthPy = dx, dy
    earthSpeedX = math.abs(dx) / dt
    earthSpeedY = math.abs(dy) / dt
    local speed = math.pow(earthSpeedX*earthSpeedX + earthSpeedY*earthSpeedY, 0.5)
    if speed > maxSpeed then
        maxSpeed = speed
    end
    info = string.format("speed %f\nmax speed %f", speed, maxSpeed)
    

    -- 计算引力
    local f = CalculateGravity(earth, jupiter)
    earth.w:applyForce(f[1], f[2])
    earth.fx, earth.fy = f[1], f[2]
    jupiter.w:applyForce(-1.0*f[1], -1.0*f[2])
    jupiter.fx, jupiter.fy = -1.0*f[1], -1.0*f[2]


    local fp = 500000 * dt
    if love.keyboard.isDown("up") then
        earth.w:applyForce(0, -fp)
    end
    if love.keyboard.isDown("down") then
        earth.w:applyForce(0, fp)
    end
    if love.keyboard.isDown("left") then
        earth.w:applyForce(-fp, 0)
    end
    if love.keyboard.isDown("right") then
        earth.w:applyForce(fp, 0 )
    end
end

function love.draw()
    Cam:attach()
        earth:draw()
        jupiter:draw()
        love.graphics.print(info, 50, 0)
        track:draw()
    Cam:detach()
    Cam:draw()
end

function CalculateGravity(a, b)
    local x1, y1 = a:getPosition()
    local x2, y2 = b:getPosition()
    local m1, m2 = a.m, b.m
    local d = math.pow(x1-x2, 2) + math.pow(y1-y2, 2)
    local f = 100 * m1 * m2 / d
    local theta = 0
    if x2 - x1 ~= 0 then
        theta = math.atan(math.abs(y2 - y1)/math.abs(x2 - x1))
    end
    local r = {}
    r[1] = f * math.cos(theta)
    r[2] = f * math.sin(theta)
    if x2 < x1 then
        r[1] = r[1] * -1
    end
    if y2 < y1 then
        r[2] = r[2] * -1
    end
    return r
end