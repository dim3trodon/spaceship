--------------------------------------------------------------------------------
--                                                                            --
-- Class in charge of the releasing of Bullets.                               --
--                                                                            --
--------------------------------------------------------------------------------

local global = require 'Global'
local Cannon = {}
Cannon.__index = Cannon
--------------------------------------------------------------------------------
--                                                                            --
-- Variables                                                                  --
--                                                                            --
--------------------------------------------------------------------------------
local bulletConstructor
local bulletParams

setmetatable(Cannon, {
    __call = function (cls, ...)
        local self = setmetatable({}, cls)
        self:new(...)
        return self
    end,
})

function Cannon.new(params)
    local self = setmetatable({}, Cannon)
    -- Poner tipo de bullet
    self:parseParams(params)
    return self
end

function Cannon:parseParams(params)
    self:setBulletConstructor(params.bulletConstructor)
    self:setBulletParams(params.bulletParams)
    self:setTargetGVElement(params.targetGVElement)
end

function Cannon:fire()
    local x = self:getX()
    local y = self:getY()
    return(self:getBulletConstructor().new({x=x, y=y}))
end

function Cannon:getTargetGVElement()
    return self.targetGVElement
end

function Cannon:setTargetGVElement(targetGVElement)
    assert(targetGVElement ~= nil, "targetGVElement is nil")
    assert(type(targetGVElement) == "table", "targetGVElement is not a "
    .."table, is a "..type(targetGVElement)..tostring(targetGVElement))
    self.targetGVElement = targetGVElement
end

function Cannon:getX()
    return self:getTargetGVElement():getX()
end

function Cannon:getY()
    return self:getTargetGVElement():getY() - 
        self:getTargetGVElement():getSprite().height / 2
end

function Cannon:getBulletConstructor()
    return self.bulletConstructor
end

function Cannon:setBulletConstructor(bulletConstructor)
    assert(bulletConstructor ~= nil, "bullet is nil")
    assert(type(bulletConstructor) == "table", 
        "bullet is not a table, is a "..type(bulletConstructor))
    self.bulletConstructor = bulletConstructor
end

function Cannon:getBulletParams()
    return self.bulletParams
end

function Cannon:setBulletParams(bulletParams)
    if(bulletParams ~= nil) then
        assert(type(bulletParams) == "table", 
            "bullet is not a table, is a "..type(bulletParams))
        self.bulletParams = bulletParams
    end
end

return Cannon
