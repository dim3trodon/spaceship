local global = require 'Global'
local super = require(global.getUpdateControlSrcPath("UpdateControl"))
local ObstacleUpdateControl = {}
ObstacleUpdateControl.__index = ObstacleUpdateControl
-- Inherithance
setmetatable(ObstacleUpdateControl, {
  __index = super, -- this is what makes the inheritance work
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:new(...)
    return self
  end,
})

function ObstacleUpdateControl.new(params)
    local self = setmetatable({}, ObstacleUpdateControl)
    self.parseParams(params)
    return self
end

function ObstacleUpdateControl:parseParams(params)
    super.parseParams(self)
end

function ObstacleUpdateControl:refresh()
    self:setY(self:getY() + 5000)
end

return ObstacleUpdateControl