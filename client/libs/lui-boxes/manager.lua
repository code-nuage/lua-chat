local Manager = {}
Manager.__index = Manager

function Manager.new()
    local i = setmetatable({}, Manager)

    i.frames = {}
    i.index = 1

    return i
end

--+ SETTERS +--
function Manager:add_frame(frame)
    table.insert(self.frames, frame)
    return self
end

function Manager:focus_next()
    self.index = (self.index % #self.frames) + 1
end

function Manager:focus_previous()
    self.index = (self.index - 2) % #self.frames + 1
end

--+ GETTERS +--
function Manager:get_focused()
    return self.frames[self.index]
end

function Manager:is_keyboard_busy()
    if self:get_focused():is_keyboard_busy() then
        return true
    end
    return false
end

function Manager:draw()
    for _, frame in ipairs(self.frames) do
        frame:draw()
    end
end

function Manager:update()
    if lui.input == lui.keys.TAB then
        self:focus_next()
    elseif lui.input == lui.keys.SHIFT_TAB then
        self:focus_previous()
    else
        self:get_focused():handle_input()
    end
end

return Manager
