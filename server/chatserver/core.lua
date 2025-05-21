local base = (...):gsub("core", "")

local socket = require("socket")

local callbacks = require(base .. "callbacks")

local clients = {}

local config

local core = {}

function core.run()
    local server = assert(socket.bind(config.ip, config.port))
    server:settimeout(0)
    local server_ip, server_port = server:getsockname()
    print("Server started @ " .. server_ip .. ":" .. server_port)

    while true do
        local read_sockets = {server}
        for _, client in ipairs(clients) do
            table.insert(read_sockets, client.client)
        end

        local ready = socket.select(read_sockets, nil, 1)

        for _, sock in ipairs(ready) do
            if sock == server then
                local client, err = server:accept()
                if client then
                    client:settimeout(0)
                    table.insert(clients, {client = client})

                    if type(callbacks.on_join) == "function" then
                        local c = clients[#clients]
                        callbacks.on_join(c)
                    end
                end
            else
                local client
                for _, c in pairs(clients) do
                    if c.client == sock then
                        client = c
                    end
                end

                local message, err = sock:receive()
                if err then
                    if err == "closed" then
                        if type(callbacks.on_quit) == "function" then
                            callbacks.on_quit(client)
                        end
                        table.remove(clients, core.get_client_id(client))
                        sock:close()
                        break
                    end
                elseif message then
                    if type(callbacks.on_message) == "function" then
                        callbacks.on_message(client, message)
                    end
                end
            end
        end
    end
end

function core.set_config(conf)
    config = conf
end

function core.get_clients()
    return clients
end

function core.get_client_id(client)
    for index, c in ipairs(clients) do
        if c == client then
            return index
        end
    end
end

return core
