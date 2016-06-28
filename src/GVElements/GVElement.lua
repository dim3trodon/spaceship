--------------------------------------------------------------------------------
--                                                                            --
-- Class which all the elements of the GameView inherits from.                --
--                                                                            --
-- All of the elements of the GameView have a management class and a          --
-- UpdateControl class. The first one is in charge of the basic management of --
-- the GVElement (storing the attributes of the object and calling the        --
-- UpdateControl) and the UpdateControl is the class that updates the         --
-- position of the object in the GameView. When this update is done, the      --
-- "management class" reads the value of the x and y position from the        --
-- UpdateControl and moves the object.                                        --
--                                                                            --
--------------------------------------------------------------------------------
local global = require 'Global'
local GVElement = {}
GVElement.__index = GVElement
setmetatable(GVElement, {
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
-- Types of sprites
local RECT = "rect" -- A sprite of type "rect" is a rectangle of one colour 
                    -- (use only for debugging)
GVElement.RECT = RECT
local IMAGE = "img" -- A sprite of type "img" is a external image
GVElement.IMAGE = IMAGE
-- Movement constants
local NO_MOVEMENT = "-" -- When a GVelement has movement "-", it means it won't
                        -- move
GVElement.NO_MOVEMENT = NO_MOVEMENT

--------------------------------------------------------------------------------
--                                                                            --
-- Attributes                                                                 --
--                                                                            --
--------------------------------------------------------------------------------
local name
local typeOfSprite -- "rect" or "img"
local sprite -- The object that is the visual representation of the GVElement
local targetUpdateControl   -- Class that is in charge of controlling updates of 
                            -- the GVElement 
local speed
local moving -- A boolean that checks if the GVElement is moving

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
function GVElement.new(params)
    local self = setmetatable({}, GVElement)
    self:parseParams(params)
    return self
end

-- This functions is in charge of parsing all the parameters of the GVElement
function GVElement:parseParams(params)
    self:setTypeOfSprite(params.typeOfSprite)
    self:setName(params.name)
    self:setTargetUpdateControl(params.targetUpdateControl)
    self:show(params)
    if(self:getTargetUpdateControl() ~= nil) then
        self:getTargetUpdateControl():setTargetGVElement(self)
    end
    self:setSpeed(params.speed)
end

function GVElement:show(params)
    local x = params.x
    local y = params.y
    local typeOfSprite = params.typeOfSprite
    local name = params.name
    local speedString
    
    assert(sprite == nil,  name .. " has been already showed.")
    assert(type(x) == "number", "x (.."..x.." is not a number, is a "..
    type(x))
    assert(type(y) == "number", "y is not a number, is a "..type(y))
    assert(type(typeOfSprite) == "string", "typeOfSprite ("..typeOfSprite..
    ") is not a string, is a "..type(typeOfSprite))

    if(self:getTypeOfSprite() == RECT) then
        local width = params.width
        local height = params.height
        local colour = params.colour
        assert(type(width) == "number", "width ("..width..") is not a"..
        " number, is a "..type(width))
        assert(type(height) == "number", "height (.."..height.." is "..
        "not a number, is a "..type(height))
        --assert(type(colour) == "string", "colour ("..colour..") 
        --is not a string, is a "..type(colour))
        -- TODO Change colour
        self:setSprite(display.newRect(x, y, width, height))
    elseif(self:getTypeOfSprite() == IMAGE) then
        local spritePath = params.spritePath
        assert(type(spritePath) == "string", "spritePath ("..
        spritePath..") is not a string, is a "..
        type(spritePath))
        -- TODO width and height for image?
        self:setSprite(display.newImage(spritePath, x, y))
    else
        assert(false, "\""..params.typeOfSprite.."\" is not a valid "..
        "typeOfSprite")
    end
    if(self:getSpeed()~= nil) then
        speedString = self:getSpeed()
    else
        speedString = "nil"
    end
    print("Creation of a "..self:getTypeOfSprite().." named "..
    self:getName().." in "..x..", "..y)
    return self:getSprite()
end

function GVElement:hide()
    if(self:getSprite() ~= nil) then
        self:getSprite():removeSelf()
        self.sprite = nil
    else
        print("Trying to hide a nil sprite")
    end
end

--------------------------------------------------------------------------------
--                                                                            --
-- Movement and updating                                                      --
--                                                                            --
--------------------------------------------------------------------------------
local function distBetween(x1, y1, x2, y2)
    local xFactor = x2 - x1
    local yFactor = y2 - y1
    local dist = math.sqrt((xFactor*xFactor) + (yFactor*yFactor))
    return dist
end

function GVElement:update()
    if(self:getTargetUpdateControl() ~= nil) then
        -- Ship's update control is not refreshed each frame but only when the
        -- user touches the screen.
        if(self:getName() ~= "ship") then
            self:refreshUpdateControl()
        end
        local x = self:getTargetUpdateControl():getX()
        local y = self:getTargetUpdateControl():getY()
        if(x ~= NO_MOVEMENT) and (x ~= self:getX()) or (y ~= self:getY()) then
            self:moveTo(x, y)
        else
            self:setMoving(false)
        end
    end
end

function GVElement:moveTo(x, y)
    assert(x ~= nil, "x is nil")
    assert(y ~= nil, "y is nil")
    assert(type(x) == "number", "x is not a number, is a "..type(x).." \""..
    x.."\"")
    assert(type(y) == "number", "y is not a number")
    
    if(self:isMoving() == false) then        
        local d = distBetween(x, y, self:getX(), self:getY())
        local v = self:getSpeed()
        local t = d / v
        transition.to(self:getSprite(), {x=x, y=y, time=t})
        --self:applyForce(self:getX() - x, self:getY() - y, 0, 0)
        self:setMoving(true)
    end
    
end

function GVElement:moveToLinearImpulse(x, y)
    assert(x ~= nil, "x is nil")
    assert(y ~= nil, "y is nil")
    assert(type(x) == "number", "x is not a number, is a "..type(x).." \""..
    x.."\"")
    assert(type(y) == "number", "y is not a number")

    
    if(self:isMoving() == false) then        
        local d = distBetween(x, y, self:getX(), self:getY())
        local v = self:getSpeed()
        local t = d / v
        --transition.to(self:getSprite(), {x=x, y=y, time=t})
        
        local ax = self:getX()
        local ay = self:getY()
        local bx = x
        local by = y
        
        self:getSprite():applyLinearImpulse(bx - ax, by - ay, self:getX(),
                self:getY())
        
        self:setMoving(true)
    end
    
end

function GVElement:refreshUpdateControl()
    if(self:getTargetUpdateControl() ~= nil and not self:isMoving()) then
        self:getTargetUpdateControl():refresh()
    end
end

--------------------------------------------------------------------------------
--                                                                            --
-- Getters and setters                                                        --
--                                                                            --
--------------------------------------------------------------------------------
-- X Position of the GVElement
function GVElement:getX()
    return self:getSprite().x
end

-- Y Position of the GVElement
function GVElement:getY()
    return self:getSprite().y
end

function GVElement:getName()
    return self.name
end

function GVElement:setName(name)
    if(name ~= nil) then
        assert(type(name) == "string", "name ("..name..") is not a "..
        "string, is a "..type(name))
        self.name = name
    else
        print("Warning: name has not been setted, using \"unnamed\" instead.")
        self.name = "unnamed"
    end
end

function GVElement:getTypeOfSprite()
    return self.typeOfSprite
end

function GVElement:setTypeOfSprite(typeOfSprite)
    assert(type(typeOfSprite) == "string", "typeOfSprite is not a string,"..
    " is a "..type(typeOfSprite))
    self.typeOfSprite = typeOfSprite
end

function GVElement:getSprite()
    return self.sprite
end

function GVElement:setSprite(sprite)
    assert(type(sprite) == "table", "sprite is not a table, is a "..
    type(sprite))
    self.sprite = sprite
end

function GVElement:isMoving()
    return self.moving
end

function GVElement:setMoving(moving)
    self.moving = moving
end

function GVElement:getTargetUpdateControl()
    return self.targetUpdateControl
end

function GVElement:setTargetUpdateControl(targetUpdateControl)
    if(targetUpdateControl == nil) then
        print("Warning: targetUpdateControl of \""..self:getName().."\" is nil")
    else
        assert(type(targetUpdateControl) == "table", "targetUpdateControl of "..
            self:getName().. "is not a table, is a "..type(targetUpdateControl))
        self.targetUpdateControl = targetUpdateControl
    end
end

function GVElement:getSpeed()
    return self.speed
end

function GVElement:setSpeed(speed)
    if(speed == nil) then
        speed = global.getWorldSpeed()
    end
    assert(type(speed) == "number", "speed (" .. speed .. ") is not a number" ..
    ", is a " .. type(speed))
    self.speed = speed
end

-- The porcentual speed is what is used to move the sprite
function GVElement:getPorcentualSpeed()
    return self:getSpeed() * 0.1
end

function GVElement:isMoving()
    return self.moving
end

function GVElement:setMoving(moving)
    self.moving = moving
end

return GVElement