local global = require 'Global'
local super = require(global.getUpdateControlSrcPath("UpdateControl"))
local ShipUpdateControl = {}
ShipUpdateControl.__index = ShipUpdateControl
-- Inherithance
setmetatable(ShipUpdateControl, {
  __index = super, -- this is what makes the inheritance work
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:new(...)
    return self
  end,
})

function ShipUpdateControl.new()
	local self = setmetatable({}, ShipUpdateControl)
        self:setX(super.NO_MOVEMENT)
        self:setY(super.NO_MOVEMENT)
	return self
end

return ShipUpdateControl
