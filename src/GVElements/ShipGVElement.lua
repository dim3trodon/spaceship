--------------------------------------------------------------------------------
--                                                                            --
-- Class in charge of the management of the ship.                             --
--                                                                            --
--------------------------------------------------------------------------------
local global = require 'Global'
local super = require(global.getGVElementSrcPath("GVElement"))
local Cannon = require(global.getGVElementSrcPath("Cannon"))
local Ship = {}
Ship.__index = Ship
setmetatable(Ship, {
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
local SPEED = 3
Ship.SPEED = SPEED
--------------------------------------------------------------------------------
--                                                                            --
-- Variables                                                                  --
--                                                                            --
--------------------------------------------------------------------------------
local cannon

local colliding

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
function Ship.new(params)
    local self = setmetatable({}, Ship)
    self:parseParams(params)
    
    self.colliding = false
    
    return self
end

function Ship:parseParams(params)
    params.cannonParams.targetGVElement = self
    self:setCannnon(Cannon.new(params.cannonParams))
    super.parseParams(self, params)
end
--------------------------------------------------------------------------------
--                                                                            --
-- Movement and updating                                                      --
--                                                                            --
--------------------------------------------------------------------------------
function Ship:update()
    local x = self:getTargetUpdateControl():getX();
    local y = self:getTargetUpdateControl():getY();
    if(x ~= self:getTargetUpdateControl().NO_MOVEMENT) then
        -- Comprobar no solo si está colisionando, sino si va a moverse hacia
        -- un enemigo
        if(self.colliding == false) then
            self:moveTo(x, y)
            self.angularVelocity = 0
        end
    end
end

local function distBetween(x1, y1, x2, y2)
    local xFactor = x2 - x1
    local yFactor = y2 - y1
    local dist = math.sqrt((xFactor*xFactor) + (yFactor*yFactor))
    return dist
end

function Ship:moveTo(x, y)
    assert(x ~= nil, "x is nil")
    assert(y ~= nil, "y is nil")
    assert(type(x) == "number", "x is not a number, is a "..type(x)..
    " = \""..tostring(x).."\"")
    assert(type(y) == "number", "y is not a number")
    local sprite = self:getSprite()
    local porcentualSpeed = self:getPorcentualSpeed()
    
    -- ¿Usar apply-force?
    sprite:translate((x - sprite.x) * porcentualSpeed, (y - sprite.y) * 
    porcentualSpeed)
    
end

function Ship:fire()
    return(self:getCannon():fire())
end
--------------------------------------------------------------------------------
--                                                                            --
-- Getters and setters                                                        --
--                                                                            --
--------------------------------------------------------------------------------

function Ship:getCannon()
    return self.cannon
end

function Ship:setCannnon(cannon)
    assert(cannon ~= nil, "cannon is nil")
    assert(type(cannon) == "table", "cannon is not a table, is a "..
        type(cannon))
    self.cannon = cannon
end


function Ship:getColliding()
    return self.colliding
end

function Ship:setColliding(colliding)
    self.colliding = colliding
end

return Ship
