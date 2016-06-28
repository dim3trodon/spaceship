--------------------------------------------------------------------------------
--                                                                            --
-- Class in charge of the management of the static elements of the game.      --
--                                                                            --
--------------------------------------------------------------------------------
local global = require 'Global'
local super = require(global.getGVElementSrcPath("GVElement"))
local ObstacleUpdateControl = require(global.
        getUpdateControlSrcPath("ObstacleUpdateControl"))
local Obstacle = {}
Obstacle.__index = Obstacle
-- Inherithance
setmetatable(Obstacle, {
    __index = super, -- this is what makes the inheritance work
    __call = function (cls, ...)
        local self = setmetatable({}, cls)
        self:new(...)
        return self
    end,
})
--------------------------------------------------------------------------------
--                                                                            --
-- Functions                                                                  --
--                                                                            --
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--                                                                            --
-- Initialization                                                             --
--                                                                            --
--------------------------------------------------------------------------------
-- Constructor
function Obstacle.new(params)
    local self = setmetatable({}, Obstacle)
    params.targetUpdateControl = ObstacleUpdateControl.new()
    self:parseParams(params)
    return self
end
--------------------------------------------------------------------------------
--                                                                            --
-- Updating                                                                   --
--                                                                            --
--------------------------------------------------------------------------------
function Obstacle:update() 
    super.update(self)
end

return Obstacle