local base = (...):gsub("message", "")

local core = require(base .. "core")

local message = {}

function message.broadcast(msg)
    for _, c in ipairs(core.get_clients()) do
        c.client:send(msg .. "\n")
    end
end

function message.broadcast_exclude(msg, client)
    for _, c in ipairs(core.get_clients()) do
        if client ~= c then
            c.client:send(msg .. "\n")
        end
    end
end

function message.send(msg, client)
    client.client:send(msg .. "\n")
end

return message