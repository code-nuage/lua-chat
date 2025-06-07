local base = (...):gsub("init", "")

local boxes = {}

boxes.manager = require(base .. "manager")
boxes.frame = require(base .. "frame")
boxes.label = require(base .. "label")
boxes.text_input = require(base .. "textinput")

lui.boxes = boxes

return boxes
