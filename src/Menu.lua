local Menu = {}
Menu.__index = Menu
setmetatable(Menu, {
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:new(...)
    return self
  end,
})
-- Constants
local DEF_X = display.contentWidth * 0.5
local DEF_Y = display.contentHeight * 0.5
local DEF_FONT = native.systemFont
local DEF_SIZE = 50
local DEF_TEXT = "Start"
-- Attributes
local startText

local function getStartText()
	return startText
end

local function setStartText(_startText)
	startText = _startText
end

function Menu:show()
	setStartText(display.newText(DEF_TEXT, DEF_X, DEF_Y, DEF_FONT, DEF_SIZE))
end

function Menu:hide()
	if(startText ~= nil) then
		getStartText():removeSelf()
		setStartText(nil)
	end
end

function Menu:setStartListener(action)
	assert(action ~= nil, "action is nil")
	assert(type(action) == "function", "action is not a function")
	if(getStartText() ~= nil) then
		getStartText():addEventListener("tap", action)
	else
		print("startText has not been initialized")
	end
end

return Menu