local Global = {}

-- requires wizard
local PREFIX = ''
local SRC_FOLDER = PREFIX..'src'
local GV_ELEMENT_FOLDER = SRC_FOLDER..'.'..'GVElements'
local UPDATE_CONTROL_FOLDER = SRC_FOLDER..'.'..'UpdateControls'

local targetShipSprite

local function getSrcPath(class)
    assert(type(class) == "string", "class is not a class name")
    return PREFIX..'.'..SRC_FOLDER..'.'..class
end

local function getGVElementSrcPath(class)
    assert(type(class) == "string", "class is not a class name")
    return GV_ELEMENT_FOLDER..'.'..class
end

local function getUpdateControlSrcPath(class)
    assert(type(class) == "string", "class is not a class name")
    return UPDATE_CONTROL_FOLDER..'.'..class
end

local function getShipX()
    return targetShipSprite.x
end

local function getShipY()
    return targetShipSprite.y
end

local function setTargetShipSprite(_targetShipSprite)
    assert(_targetShipSprite ~= nil, "_targetShipSprite is nil")
    assert(type(_targetShipSprite) == "table", "_targetShipSprite is not a table")
    targetShipSprite = _targetShipSprite
end
	
Global.getSrcPath = getSrcPath
Global.getGVElementSrcPath = getGVElementSrcPath
Global.getUpdateControlSrcPath = getUpdateControlSrcPath
Global.getShipX = getShipX
Global.getShipY = getShipY
Global.setTargetShipSprite = setTargetShipSprite

-- Global constants
local worldSpeed = 0.001

local function getWorldSpeed()
    return worldSpeed
end

Global.getWorldSpeed = getWorldSpeed

return Global