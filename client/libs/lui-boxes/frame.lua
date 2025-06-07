local Frame = {}
Frame.__index = Frame

function Frame.new(x, y, w, h)
    local i = setmetatable({}, Frame)

    if x and y then
        i:set_position(x, y)
    end

    if w and h then
        i:set_dimension(w, h)
    end

    i.components = {}
    i.index = 1

    return i
end

--+ SETTERS +--
function Frame:add_component(component)
    table.insert(self.components, component)
    return self
end

function Frame:set_position(x, y)
    self.x, self.y = x, y
    return self
end

function Frame:set_dimension(w, h)
    self.w, self.h = w, h
    return self
end

--+ GETTERS +--
function Frame:get_position()
    if self.x and self.y then
        return self.x, self.y
    end
    return false
end

function Frame:get_dimension()
    if self.w and self.h then
        return self.w, self.h
    end
    return false
end

function Frame:get_focused()
    if self.components[self.index] then
        return self.components[self.index]
    end
    return false
end

function Frame:is_keyboard_busy()
    if self:get_focused() then
        if type(self:get_focused().handle_input) == "function" then
            return true
        end
    end
    return false
end

--+ HOOK +--
function Frame:handle_input()
    if lui.input == lui.keys["ARROW_UP"] then
        self:focus_previous()
    elseif lui.input == lui.keys["ARROW_DOWN"] then
        self:focus_next()
    else
        if self:is_keyboard_busy() then
            self:get_focused():handle_input()
        end
    end
end

function Frame:focus_next()
    self.index = (self.index % #self.components) + 1
end

function Frame:focus_previous()
    self.index = (self.index - 2) % #self.components + 1
end

function Frame:draw_stroke()
    local x, y = self:get_position()
    local w, h = self:get_dimension()

    lui.graphics.draw("┌", x, y)
    lui.graphics.draw("┐", x + w - 1, y)
    lui.graphics.draw("└", x, y + h - 1)
    lui.graphics.draw("┘", x + w - 1, y + h - 1)
    for i = x + 1, x + w - 2 do
        lui.graphics.draw("─", i, y)
        lui.graphics.draw("─", i, y + h - 1)
    end
    for j = y + 1, y + h - 2 do
        lui.graphics.draw("│", x, j)
        lui.graphics.draw("│", x + w - 1, j)
    end
end

function Frame:draw()
    if self:get_position() and self:get_dimension() then
        self:draw_stroke()
    end

    for _, component in ipairs(self.components) do
        local x, y = self:get_position()
        component:draw(x, y)
    end
end

return Frame