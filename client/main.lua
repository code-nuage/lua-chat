require("lui")
require("libs.lui-boxes.init")
require("libs.lui-keys.init")
require("libs.lui-themes.init")

local socket = require("socket")
local config = require("config")

local client = assert(socket.tcp())
client:connect(config.ip, config.port)
client:settimeout(0)

local manager = lui.boxes.manager.new()
local frame_chat = lui.boxes.frame.new(1, 2, lui.graphics.get_width(), lui.graphics.get_height() - 4)
local frame_input = lui.boxes.frame.new(1, lui.graphics.get_height() - 2, lui.graphics.get_width(), 3)

local text_input = lui.boxes.text_input.new(1, 1, lui.graphics.get_width() - 2)

local line_y = 1

local function add_chat_line(msg)
    local label = lui.boxes.label.new(msg, 1, line_y)
    frame_chat:add_component(label)
    line_y = line_y + 1
end

local function receive_loop()
    local s, status, partial = client:receive()
    if s then
        add_chat_line(s)
    elseif partial and #partial > 0 then
        add_chat_line(s)
    end
    socket.sleep(0.001)
end

local recv_thread = coroutine.create(function()
    while true do
        receive_loop()
        coroutine.yield() -- Rend la main à lui.update()
    end
end)

function text_input:enter()
    local message = self:get_value()
    if message ~= "" then
        client:send(message .. "\n")
    end
    self:set_value("")
end

frame_input:add_component(text_input)
manager:add_frame(frame_chat):add_frame(frame_input)

lui.graphics.clear()

function lui.update()
    coroutine.resume(recv_thread)
    manager:update()
    if lui.keyboard.is_down(lui.keys["ESCAPE"]) then
        lui.exit()
    end
end

function lui.draw()
    manager:draw()
    local text = "lua-chat"
    local tx, ty = lui.graphics.get_width() / 2 - #text / 2, 1
    lui.graphics.draw(text, tx, ty)
end

lui.run()