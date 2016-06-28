require "CiderDebugger";-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
local global = require 'Global'
local menu = require(global.getSrcPath("Menu"))
local GameView = require(global.getSrcPath("GameView"))

local start = {}
local main = {}

-- Actions when the Start button is touched
function start()
	menu:hide()
	GameView.initialize()
end

function main()
	menu.show()
	menu:setStartListener(start)
end

main()