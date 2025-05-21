local base = (...):gsub("init", "")

local chatserver = {}

chatserver.core = require(base .. "core")
chatserver.commands = require(base .. "commands")
chatserver.message = require(base .. "message")
chatserver.callbacks = require(base .. "callbacks")

return chatserver
