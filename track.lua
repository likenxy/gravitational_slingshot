local Track = {}

function Track:new(maxLen)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    obj.maxLen = maxLen
    obj.trackList = {}
    return obj
end


function Track:append(x, y)
    if #self.trackList > self.maxLen then
        table.remove(self.trackList, 1)
    end
    self.trackList[#self.trackList + 1] = {x, y}
end

function Track:draw()
    local len = #self.trackList
    if len == 0 then
        return
    end
    local rate = 1 / len
    for i = 1, #self.trackList do
        love.graphics.setColor(1 * rate * i * 0.7, 1 * rate * i, 1 * rate * i)
        love.graphics.circle('fill', self.trackList[i][1], self.trackList[i][2], 3)
    end
    love.graphics.setColor(1, 1, 1)
end

return Track