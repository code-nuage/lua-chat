local chatserver = require("chatserver.init")

chatserver.core.set_config(require("config"))

chatserver.commands:new("/list", function(body)
    local message = ""
    for _, c in ipairs(chatserver.core.get_clients()) do
        message = message .. " - " .. tostring(c.name) .. " " .. tostring(c) .. "\n"
    end
    body.client.client:send("[LIST]" .. message)
end)

chatserver.commands:new("/nick", function(body)
    local last_name = tostring(body.client.name)
    body.client.name = body.params[1]
    body.client.client:send("[NICK] " .. last_name .. " -> " .. body.client.name .. "\n")
end)

function chatserver.callbacks.on_message(client, message)
    print(tostring(client.name) .. " (" .. tostring(client) .. ") > " .. message)

    if not chatserver.commands:parse(client, message) then
        local pretty_message = tostring(client.name) .. " > " .. message
        chatserver.message.broadcast_exclude(pretty_message, client)
    end
end

function chatserver.callbacks.on_join(client)
    print("[JOIN] " ..  tostring(client.name) .. " (" .. tostring(client) .. ") ")
    chatserver.message.broadcast("[JOIN] " .. tostring(client.name))
end

function chatserver.callbacks.on_quit(client)
    print("[JOIN] " ..  tostring(client.name) .. " (" .. tostring(client) .. ") ")
    chatserver.message.broadcast("[QUIT] " .. tostring(client.name))
end

chatserver.core.run()