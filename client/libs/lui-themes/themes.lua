local themes = {}
themes.__index = themes

function themes:new(theme)
    local i = setmetatable({}, themes)

    i.colors = {
        reset = "\27[0m"
    }

    for color, value in pairs(theme) do
        local r, g, b
        local place

        if not value["type"] or value["type"] == "foreground" then
            place = 38
        elseif value["type"] == "background" then
            place = 48
        else
            place = 38
        end

        if value["color"]:match("^#(%x%x%x%x%x%x)$") then
            r, g, b = value["color"]:match("^#(%x%x)(%x%x)(%x%x)$")
            r, g, b = tonumber(r, 16), tonumber(g, 16), tonumber(b, 16)
        elseif value["color"]:match("^%d+,%s*%d+,%s*%d+$") then
            r, g, b = value["color"]:match("^(%d+),%s*(%d+),%s*(%d+)$")
            r, g, b = tonumber(r), tonumber(g), tonumber(b)
        end

        print(r, g, b)
        i.colors[color] = string.format("\27[%d;2;%d;%d;%dm", place, r, g, b)
    end

    return i
end

function themes:apply(text)
    return text:gsub("{{(.-)}}", function(key)
        return self.colors[key] or ""
    end)
end

return themes
