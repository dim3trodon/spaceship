local global = require 'Global'
local physics = require("physics")
local Obstacle = require(global.getGVElementSrcPath("Obstacle"))
local ShipGVElement = require(global.getGVElementSrcPath("ShipGVElement"))
local ShipUpdateControl = require(global.
        getUpdateControlSrcPath("ShipUpdateControl"))
local ObstacleUpdateControl = require(global.
        getUpdateControlSrcPath("ObstacleUpdateControl"))
local GVElement = require(global.
        getGVElementSrcPath("GVElement"))
local UpdateControl = require(global.
        getUpdateControlSrcPath("ShipUpdateControl"))
        
local BasicBullet = require(global.
        getGVElementSrcPath("BasicBullet"))

local GameView = {}
GameView.__index = GameView
setmetatable(GameView, {
    __call = function (cls, ...)
        local self = setmetatable({}, cls)
        self:new(...)
        return self
    end,
})

-- Constants
local DEFAULT_BACKGROUND = 'bg.png'
local BACKGROUND_DEFAULT_X = display.contentWidth
local BACKGROUND_DEFAULT_Y = display.contentHeight * 0.5

local DEFAULT_WIDTH = display.contentWidth * 2
local DEFAULT_HEIGHT = 20

local BOTTOM_DEFAULT_WIDTH = DEFAULT_WIDTH
local BOTTOM_DEFAULT_HEIGHT = DEFAULT_HEIGHT
local BOTTOM_DEFAULT_X = display.contentWidth * 0.5
local BOTTOM_DEFAULT_Y = display.contentHeight + BOTTOM_DEFAULT_HEIGHT * 0.5

local TOP_DEFAULT_WIDTH = DEFAULT_WIDTH
local TOP_DEFAULT_HEIGHT = DEFAULT_HEIGHT
local TOP_DEFAULT_X = display.contentWidth * 0.5
local TOP_DEFAULT_Y = - TOP_DEFAULT_HEIGHT * 0.5

local G_X = 0
local G_Y = 0
local DRAW_MODE = "hybrid"


-- Attributes
local ship
local shipSprite
local background
local bottom
local top
local farBackgroundGroup
local backgroundGroup
local foreGroundGroup
-- Elements on the screen to update
local updateableElements
-- Functions
--local show = {}
local setTouchEvent = {}
local initialize = {}
local update = {}

local function setTouchEvent(action)
    assert(action ~= nil, "action is nil")
    assert(type(action) == "function", "action is not a function")
    Runtime:addEventListener('touch', action)
end

--------------------------------------------------------------------------------
-- Firing
--------------------------------------------------------------------------------
local haveToFire = false

local function changeHaveToFire()
    haveToFire = true
end

local function fireUpdate()
    if(haveToFire == true) then
        haveToFire = false
        for k,v in pairs(updateableElements) do
            if(v.fire ~= nil) then
                --print("firing!")
                local bullet
            end
        end
        
    else
        
        timer.performWithDelay(2000000, changeHaveToFire(), 1)
    end
    
end

local function update()
    -- For each gameViewElements, update
    for k,v in pairs(updateableElements) do
        v:update()
    end
end



--------------------------------------------------------------------------------

local function pruebas()

    local params = {name="prueba", 
        typeOfSprite="img", 
        spritePath="ship-sh-90.png", 
        x=30, y=50, 
        targetUpdateControl=UpdateControl.new(), 
        speed=0.2}
    local prueba = GVElement.new(params)
    --prueba:setMoving(false)
    physics.addBody(prueba:getSprite(), 'kinematic')
    updateableElements.prueba = prueba--
    
    local params2 = {name = "moving-box", 
            typeOfSprite = "rect", 
            x = 80, 
            y = 80, 
            width = BOTTOM_DEFAULT_WIDTH,
            height = BOTTOM_DEFAULT_HEIGHT,
            speed = 0.05
            --,targetUpdateControl = ObstacleUpdateControl.new() 
            } 
    local prueba2 = Obstacle.new (params2)
    prueba2:setMoving(false)
    physics.addBody(prueba2:getSprite(), 'dynamic')
    local prueba2physic = prueba2:getSprite()
    prueba2physic.isSensor = true
    prueba2physic.isFixedRotation = true
    prueba2physic.gravityScale = 0
    updateableElements.prueba2 = prueba2
end


-- Event called when the user touches the screen.
local function shipEvent(event)
    if event.phase == "began" or event.phase == "moved" then
	ship:getTargetUpdateControl():setX(event.x)
	ship:getTargetUpdateControl():setY(event.y)
    elseif event.phase == 'ended' then
	ship:getTargetUpdateControl():setX("-")
	ship:getTargetUpdateControl():setY("-")
    end
end

local function addBullet()
    local bullet = ship:fire()
    bullet:setMoving(false)
    local bulletSprite = bullet:getSprite()
    physics.addBody(bulletSprite, 'dynamic')
    bulletSprite.isFixedRotation = true
    bulletSprite.isBullet = true
    updateableElements.basicBulletPrueba = bullet
end

local fireTimer = {}

local function touchFireBullet(event)
    if(event.phase == "began") then
        addBullet()
        fireTimer = timer.performWithDelay(500, addBullet, 0)
    elseif(event.phase == "ended") then
        timer.cancel(fireTimer)
    end
    return true
end


function GameView.initialize()
    print("Initialization of GameView")
    print("--------------------------\r\n")
    local shipControl = ShipUpdateControl.new()
    local staticUpdateControl = ObstacleUpdateControl.new()
    updateableElements = {}
    
    -- Physics initialization
    physics.start()
    physics.setGravity(G_X, G_Y)
    physics.setDrawMode(DRAW_MODE)
    print("Initialization of physics")
    print("-------------------------")
    print("Gravity = "..G_X..", "..G_Y)
    print("Draw mode = "..DRAW_MODE.."\r\n")
    print("Initialization of GVElements")
    print("----------------------------")
    
    -- Static elements initialization
    background = Obstacle.new(
            {name = "background", 
            typeOfSprite = "img", 
            x = BACKGROUND_DEFAULT_X, 
            y = BACKGROUND_DEFAULT_X, 
            spritePath = DEFAULT_BACKGROUND })
    bottom = Obstacle.new(
            {name = "bottom", 
            typeOfSprite = "rect", 
            x = BOTTOM_DEFAULT_X, 
            y = BOTTOM_DEFAULT_Y, 
            width = BOTTOM_DEFAULT_WIDTH,
            height = BOTTOM_DEFAULT_HEIGHT })
    top = Obstacle.new(
            {name = "top", 
            typeOfSprite = "rect", 
            x = TOP_DEFAULT_X, 
            y = TOP_DEFAULT_Y,
            width = TOP_DEFAULT_WIDTH,
            height = TOP_DEFAULT_HEIGHT })

    -- Display groups initialization
    farBackgroundGroup = display.newGroup()
    backgroundGroup = display.newGroup()
    foreGroundGroup = display.newGroup()
    farBackgroundGroup:insert(background:getSprite())
    backgroundGroup:insert(bottom:getSprite())
    backgroundGroup:insert(top:getSprite())
    
    -- Ship initialization
    ship = ShipGVElement.new({ 
            name="ship", 
            x=display.contentWidth * 0.5, 
            y=display.contentHeight - 30, 
            typeOfSprite="img", 
            spritePath="ship-sh-90.png",
            targetUpdateControl=shipControl,
            speed=ShipGVElement.SPEED,
            cannonParams={bulletConstructor=BasicBullet}
            })
    shipSprite = ship:getSprite()
    
    shipSprite.gravityScale = 0
    foreGroundGroup:insert(shipSprite)
    updateableElements.ship = ship
    global.setTargetShipSprite(shipSprite) --[[ This make the ship's sprite 
                                                avalaible for all classes. This
                                                allows enemies to know where is
                                                the ship.]]
    
    -- Addition of the graphic objects to the physic engine
    physics.addBody(shipSprite, 'dynamic', {bounce=1, friction=1})
    
    shipSprite.isFixedRotation = true
    
    -- Tests
    pruebas()

    -- Initialization of the event that happens when the user touches the screen
    -- (move the ship)
    setTouchEvent(shipEvent)
    
    -- Initialization of the update events every frame
    Runtime:addEventListener('enterFrame', update)
    
end




return GameView