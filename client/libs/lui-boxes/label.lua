local Label = {}
Label.__index = Label

function Label.new(value, x, y)
    local i = setmetatable({}, Label)

    if x and y then
        i:set_position(x, y)
    end

    if value then
        i:set_value(value)
    end

    return i
end

--+ SETTERS +--
function Label:set_value(value)
    self.value = value
    return self
end

function Label:set_position(x, y)
    self.x, self.y = x, y
    return self
end

--+ GETTERS +--
function Label:get_value()
    if self.value then
        if type(self.value) == "function" then
            local value = self.value()
            if type(value) == "string" then
                return value
            end
        end
        return self.value
    end
    return false
end

function Label:get_position()
    if self.x and self.y then
        return self.x, self.y
    end
    return false
end

function Label:draw(px, py)
    local x, y = self:get_position()
    lui.graphics.draw(self:get_value(), (px or 0) + x, (py or 0) + y)
end

return Label