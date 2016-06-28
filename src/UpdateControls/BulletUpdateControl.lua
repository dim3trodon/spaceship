local global = require 'Global'
local super = require(global.getUpdateControlSrcPath("UpdateControl"))
local BulletUpdateControl = {}
BulletUpdateControl.__index = BulletUpdateControl
-- Inherithance
setmetatable(BulletUpdateControl, {
  __index = super, -- this is what makes the inheritance work
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:new(...)
    return self
  end,
})

function BulletUpdateControl.new()
    local self = setmetatable({}, BulletUpdateControl)
    return self
end

function BulletUpdateControl:refresh()
    self:setY(self:getY() + self:getTargetGVElement():getDirection() 
        * display.contentHeight )
end

return BulletUpdateControl