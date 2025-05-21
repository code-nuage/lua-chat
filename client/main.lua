require("libs.lui.init")

lui.themes = require("libs.lui-themes.themes")
lui.boxes = require("libs.lui-boxes.init")

local theme = lui.themes:new(require("theme"))

local frames = lui.boxes.frames:new()
frames:add(5, 4, 10, 6)

function lui.update()
    if lui.keyboard.is_key_down("q") then
        lui.exit()
    end
end

function lui.draw()
    lui.graphics.draw(theme:apply("{{positive}}Positive{{reset}}"), 2, 2)
    lui.graphics.draw(theme:apply("{{negative}}Negative{{reset}}"), 2, 3)
    frames:draw()
end

lui.run()