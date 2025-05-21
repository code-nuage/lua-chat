local commands = {}
commands.registered = {}
local command = {}
command.__index = command

--+ CONSTRUCTOR +--
function commands:new(text, action)
    local i = setmetatable({}, command)

    i.text = text
    i.action = action

    table.insert(commands.registered, i)
end

--+ SETTERS +--
function command:set_text(text)
    self.text = text
    return self
end

function command:set_action(action)
    self.action = action
    return self
end

--+ GETTERS +--
function command:get_text()
    return self.text
end

function command:get_name()
    return self:get_text():match("^/(%w+)")
end

function command:get_action()
    return self.action
end

--+ PARSE +--
function commands:parse(client, text)
    local command_name, param_str = string.match(text, "^/(%S+)%s*(.*)$")

    if not command_name then
        return false, "Commande invalide"
    end

    local params = {}
    for param in string.gmatch(param_str, "%S+") do
        table.insert(params, param)
    end

    for _, c in ipairs(self.registered) do
        if c:get_name() == command_name then
            local action = c:get_action()
            if type(action) == "function" then
                local command_body = {
                    params = params,
                    client = client,
                }
                action(command_body)
                return true
            end
        end
    end
end

return commands