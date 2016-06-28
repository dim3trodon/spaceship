--------------------------------------------------------------------------------
--                                                                            --
-- Class in charge of the Bullets.      --
--                                                                            --
--------------------------------------------------------------------------------
local global = require 'Global'
local super = require(global.getGVElementSrcPath("GVElement"))
local Bullet = {}
Bullet.__index = Bullet

setmetatable(Bullet, {
    __index = super, -- this is what makes the inheritance work
    __call = function (cls, ...)
        local self = setmetatable({}, cls)
        self:new(...)
        return self
    end,
})
--------------------------------------------------------------------------------
--                                                                            --
-- Variables                                                                  --
--                                                                            --
--------------------------------------------------------------------------------
local direction
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
function Bullet.new(params)
    local self = setmetatable({}, Bullet)
    self:parseParams(params)
    self:setMoving(false)
    return self
end

function Bullet:parseParams(params)
    if(params.direction ~= nil) then
        self:setDirection(params.direction)
    else
        self:setDirection(-1)
    end
    super.parseParams(self, params)
end

--------------------------------------------------------------------------------
--                                                                            --
-- Updating                                                                   --
--                                                                            --
--------------------------------------------------------------------------------
function Bullet:update() 
    super.update(self)
end

--------------------------------------------------------------------------------
--                                                                            --
-- Getters and setters                                                        --
--                                                                            --
--------------------------------------------------------------------------------

function Bullet:getDirection()
    return self.direction
end

function Bullet:setDirection(direction)
    print("setting direction as "..tostring(direction))
    assert(type(direction)~= nil, "direction is nil")
    assert(type(direction) == "number", "direction is not a number, is a "..
    type(direction))
    self.direction = direction
end

return Bullet