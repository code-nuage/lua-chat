local frames = {}
frames.__index = frames
local frame = {}
frame.__index = frame

function frames:new()
    local i = setmetatable({}, frames)

    i.frames = {}
    i.selected = 0

    return i
end

function frames:add(x, y, w, h)
    table.insert(self.frames, frame:new(x, y, w, h))
end

function frames:move(i)
    self.selected = (self.selected + i) % #self.frames
end

function frames:draw()
    for _, f in ipairs(self.frames) do
        f:draw()
    end
end

function frame:new(x, y, w, h)
    local i = setmetatable({}, frame)

    i.x, i.y = x, y
    i.w, i.h = w, h

    return i
end

function frame:draw()
    lui.graphics.draw("┌", self.x, self.y)
    lui.graphics.draw("┐", self.x + self.w - 1, self.y)
    lui.graphics.draw("└", self.x, self.y + self.h - 1)
    lui.graphics.draw("┘", self.x + self.w - 1, self.y + self.h - 1)
    for x = self.x + 1, self.x + self.w - 2 do
        lui.graphics.draw("─", x, self.y)
        lui.graphics.draw("─", x, self.y + self.h - 1)
    end
    for y = self.y + 1, self.y + self.h - 2 do
        lui.graphics.draw("│", self.x, y)
        lui.graphics.draw("│", self.x + self.w - 1, y)
    end
end

return frames