--------------------------------------------------------------------------------
--                                                                            --
-- Class which all the Updatecontrols inherits from.                          --
--                                                                            --
--------------------------------------------------------------------------------
local UpdateControl = {}
UpdateControl.__index = UpdateControl
setmetatable(UpdateControl, {
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
local NO_MOVEMENT = "-"
--------------------------------------------------------------------------------
--                                                                            --
-- Attributes                                                                 --
--                                                                            --
--------------------------------------------------------------------------------
local x = NO_MOVEMENT
local y = NO_MOVEMENT
local targetGVElement -- Used by child classes, don't remove.

local showWarningMessage = true -- ?
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
function UpdateControl.new(params)
    local self = setmetatable({}, UpdateControl)
    self:parseParams(params)
    return self
end

function UpdateControl:parseParams(params)
end

--------------------------------------------------------------------------------
--                                                                            --
-- Updating                                                      --
--                                                                            --
--------------------------------------------------------------------------------
function UpdateControl:refresh()
    if(showWarningMessage) then
        print("Warning: " .. self:getTargetGVElement():getName() .. " has a " ..
        "dummy update. Check its inheritance.")
        showWarningMessage = false
    end
end

--------------------------------------------------------------------------------
--                                                                            --
-- Getters and setters                                                        --
--                                                                            --
--------------------------------------------------------------------------------
function UpdateControl:getX()
    return self.x
end

function UpdateControl:setX(x)
    assert(x ~= nil, "x is nil")
    if(x ~= NO_MOVEMENT) then
        assert(type(x) == "number", "x is not a number")
    end
    self.x = x
end

function UpdateControl:getY()
    return self.y
end

function UpdateControl:setY(y)
    assert(y ~= nil, "y is nil")
    if(y ~= NO_MOVEMENT) then
        assert(type(y) == "number", "y is not a number")
    end
    self.y = y
end

function UpdateControl:getTargetGVElement()
    return self.targetGVElement
end

function UpdateControl:setTargetGVElement(targetGVElement)
    assert(targetGVElement ~= nil, "targetGVElement is nil")
    assert(type(targetGVElement) == "table", "targetGVElement is not a "
    .."table, is a "..type(targetGVElement)..tostring(targetGVElement))
    self.targetGVElement = targetGVElement
    self:setX(self:getTargetGVElement():getX())
    self:setY(self:getTargetGVElement():getY())
end

UpdateControl.NO_MOVEMENT = NO_MOVEMENT
return UpdateControl