local chatserver = require("chatserver.init")

chatserver.core.set_config(require("config"))

--+ COMMANDS +--
chatserver.commands:new("/list", function(body)
    local message = "[\27[94mLIST\27[0m]\n"
    for _, c in ipairs(chatserver.core.get_clients()) do
        message = message .. " - \27[94m" .. tostring(c.name) .. "\27[0m\n"
    end
    body.client.client:send(message)
end)

chatserver.commands:new("/nick", function(body)
    local last_name = tostring(body.client.name)
    body.client.name = body.params[1]
    body.client.client:send("[\27[95mNICK\27[0m] \27[91m" .. last_name .. "\27[0m -> \27[92m" .. body.client.name .. "\27[0m\n")
end)

chatserver.commands:new("/help", function(body)
    body.client.client:send("[\27[92mHELP\27[0m]\n" ..
    " - \27[92m/help\27[0m: Lists all help commands\n" ..
    " - \27[95m/nick {name}\27[0m: Rename yourself\n" ..
    " - \27[94m/list\27[0m: Lists all current users\n")
end)

--+ CALLBACKS +--
function chatserver.callbacks.on_message(client, message)
    print(tostring(client.name) .. " (" .. tostring(client) .. ") > " .. message)

    if not chatserver.commands:parse(client, message) then
        local pretty_message = tostring(client.name) .. " > " .. message
        chatserver.message.broadcast_exclude(pretty_message, client)
    end
end

function chatserver.callbacks.on_join(client)
    local ip, port = client.client:getpeername()
    print("[\27[92mJOIN\27[0m] " .. tostring(client.name) .. " (" .. ip .. ":" .. port .. ") ")

    local message = "  _                        _           _   \n" ..
                    " | |_ ___ _ __         ___| |__   __ _| |_ \n" ..
                    " | __/ __| '_ \\ _____ / __| '_ \\ / _` | __|\n" ..
                    " | || (__| |_) |_____| (__| | | | (_| | |_ \n" ..
                    "  \\__\\___| .__/       \\___|_| |_|\\__,_|\\__|\n" ..
                    "         |_|                               \n"
    client.client:send(message .. "            Welcome to tcp-chat\nType \27[92m/help\27[0m to see available commands\n")
    chatserver.message.broadcast("[\27[92mJOIN\27[0m] " .. tostring(client.name))
end

function chatserver.callbacks.on_quit(client)
    local ip, port = client.client:getpeername()
    print("[\27[91mQUIT\27[0m] " .. tostring(client.name)  .. " (" .. ip .. ":" .. port .. ") ")
    chatserver.message.broadcast("[\27[91mQUIT\27[0m] " .. tostring(client.name))
end

chatserver.core.run()