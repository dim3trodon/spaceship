--------------------------------------------------------------------------------
--                                                                            --
-- Basic Bullet.      --
--                                                                            --
--------------------------------------------------------------------------------
local global = require 'Global'
local super = require(global.getGVElementSrcPath("Bullet"))
local BulletUpdateControl = require(global.
        getUpdateControlSrcPath("BulletUpdateControl"))
local BasicBullet = {}
BasicBullet.__index = BasicBullet

setmetatable(BasicBullet, {
    __index = super, -- this is what makes the inheritance work
    __call = function (cls, ...)
        local self = setmetatable({}, cls)
        self:new(...)
        return self
    end,
})
--------------------------------------------------------------------------------
--                                                                            --
-- Constants                                                                  --
--                                                                            --
--------------------------------------------------------------------------------
local SPEED = 0.3
local HEIGHT = 5
local WIDTH = 3


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
function BasicBullet.new(params)
    local self = setmetatable({}, BasicBullet)
    local updateControlParams = {targetGVElement = self}
    params.name = "basicBullet"
    params.typeOfSprite = "rect"
    params.width = WIDTH
    params.height = HEIGHT
    params.speed = SPEED
    params.targetUpdateControl = BulletUpdateControl.new(updateControlParams)
    self:parseParams(params)
    return self
end

function BasicBullet:parseParams(params)
    super.parseParams(self, params)
end

--------------------------------------------------------------------------------
--                                                                            --
-- Updating                                                                   --
--                                                                            --
--------------------------------------------------------------------------------
function BasicBullet:update() 
    super.update(self)
end

return BasicBullet