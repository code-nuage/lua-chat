local TextInput = {}
TextInput.__index = TextInput

function TextInput.new(x, y, w)
    local i = setmetatable({}, TextInput)

    if x and y then
        i:set_position(x, y)
    end

    if w then
        i:set_width(w)
    end

    i:set_value("")
    i:set_scroll(0)

    return i
end

--+ SETTERS +--
function TextInput:set_position(x, y)
    self.x, self.y = x, y
    return self
end

function TextInput:set_width(w)
    self.w = w
    return self
end

function TextInput:set_value(value)
    self.value = value
    return self
end

function TextInput:set_scroll(value)
    self.scroll = value
    return self
end

function TextInput:increment_value(char)
    self.value = self.value .. char

    local len = #self.value
    if len > self:get_width() then
        self.scroll = len - self:get_width()
    end
    return self
end

function TextInput:decrement_value()
    self.value = self.value:sub(1, -2)

    local len = #self.value
    if len <= self:get_width() then
        self.scroll = 0
    elseif self.scroll > 0 then
        self.scroll = math.max(0, self.scroll - 1)
    end
    return self
end


--+ GETTERS +--
function TextInput:get_position()
    if self.x and self.y then
        return self.x, self.y
    end
    return false
end

function TextInput:get_width()
    if self.w then
        return self.w
    end
    return false
end

function TextInput:get_value()
    if self.value then
        return self.value
    end
    return ""
end

function TextInput:draw(px, py)
    local full_text = self:get_value()
    local visible_width = self:get_width()
    local start_index = self.scroll + 1
    local visible_text = full_text:sub(start_index, start_index + visible_width - 1)

    visible_text = visible_text .. string.rep(" ", visible_width - #visible_text)

    lui.graphics.draw(visible_text, (px or 0) + self.x, (py or 0) + self.y)
end


function TextInput:update()
    self:handle_input()
end

function TextInput:handle_input()
    if lui.input == lui.keys.BACKSPACE then
        self:decrement_value()
    elseif lui.input == lui.keys.ENTER then
        if type(self.enter) == "function" then                                 -- Callback if something has to be done
            self:enter()
        end
    elseif #lui.input == 1 then
        self:increment_value(lui.input)
    end
end

function TextInput:enter() end

return TextInput
