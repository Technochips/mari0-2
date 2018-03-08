local component = {}



local MAXSPEEDS = {90, 150, 210}

local FLYANIMATIONTIME = 4/60
local FLOATANIMATIONTIME = 4/60

local SPINTIME = 19/60
local SPINFRAMETIME = 4/60

local STARTIME = 7.5
local STARFRAMETIME = 4/60
local SOMERSAULTTIME = 2/60

local SHOOTTIME = 12/60

local RUNANIMATIONTIME = 1.2

local STARPALETTES = {
    {
        {252/255, 252/255, 252/255},
        {  0/255,   0/255,   0/255},
        {216/255,  40/255,   0/255},
    },
    
    {
        {252/255, 252/255, 252/255},
        {  0/255,   0/255,   0/255},
        { 76/255, 220/255,  72/255},
    },
    
    {
        {252/255/255, 188/255, 176/255},
        {  0/255/255,   0/255,   0/255},
        {252/255/255, 152/255,  56/255},
    }
}

local powerUpStates = {
    small = {
        colors = {
            {252/255, 188/255, 176/255},
            {216/255,  40/255,   0/255},
            {  0/255,   0/255,   0/255},
        },
        width = 24,
        height = 24,
        centerX = 12,
        centerY = 15,
        frames = {
            "idle",
            
            "run",
            "run",
            
            "sprint",
            "sprint",
            
            "skid",
            
            "jump",
            
            "fall",
            
            "fly",
            
            "die",
            
            "buttSlide",
            
            "swim",
            "swim",
            "swim",
            "swim",
            
            "pipe",
            
            "holdIdle",
            
            "holdRun",
            "holdRun",
            
            "kick",
            
            "climb",
            "climb",
        },
    },
    
    big = {
        colors = {
            {252/255, 188/255, 176/255},
            {216/255,  40/255,   0/255},
            {  0/255,   0/255,   0/255},
        },
        width = 40,
        height = 40,
        centerX = 23,
        centerY = 24,
        canDuck = true,
        frames = {
            "idle",
            
            "run",
            "run",
            "run",
            "run",
            
            "sprint",
            "sprint",
            "sprint",
            "sprint",
            
            "skid",
            
            "jump",
            
            "fall",
            
            "fly",
            
            "die",
            
            "duck",
            
            "buttSlide",
            
            "swim",
            "swim",
            "swim",
            "swim",
            
            "swimUp",
            "swimUp",
            "swimUp",
            
            "pipe",
            "useless",
            
            "holdIdle",
            
            "holdRun",
            "holdRun",
            "holdRun",
            "holdRun",
            
            "kick",
            
            "climb",
            "climb",
            
            "somerSault",
            "somerSault",
            "somerSault",
            "somerSault",
            "somerSault",
            "somerSault",
            "somerSault",
            "somerSault",
            
            "shoot",
            "shoot",
            "shoot",
            
            "shootAir",
            "shootAir",
            "shootAir",
        },
    },
    
    fire = {
        colors = {
            {252/255, 188/255, 176/255},
            {252/255, 152/255,  56/255},
            {216/255,  40/255,   0/255},
        },
        width = 40,
        height = 40,
        centerX = 23,
        centerY = 24,
        canDuck = true,
        canShoot = true,
        frames = {
            "idle",
            
            "run",
            "run",
            "run",
            "run",
            
            "sprint",
            "sprint",
            "sprint",
            "sprint",
            
            "skid",
            
            "jump",
            
            "fall",
            
            "fly",
            
            "die",
            
            "duck",
            
            "buttSlide",
            
            "swim",
            "swim",
            "swim",
            "swim",
            
            "swimUp",
            "swimUp",
            "swimUp",
            
            "pipe",
            "useless",
            
            "holdIdle",
            
            "holdRun",
            "holdRun",
            "holdRun",
            "holdRun",
            
            "kick",
            
            "climb",
            "climb",
            
            "somerSault",
            "somerSault",
            "somerSault",
            "somerSault",
            "somerSault",
            "somerSault",
            "somerSault",
            "somerSault",
            
            "shoot",
            "shoot",
            "shoot",
            
            "shootAir",
            "shootAir",
            "shootAir",
        },
    },
    
    hammer = {
        colors = {
            {252/255, 188/255, 176/255},
            {216/255,  40/255,   0/255},
            {  0/255,   0/255,   0/255},
        },
        width = 40,
        height = 40,
        centerX = 23,
        centerY = 24,
        canDuck = true,
        canShoot = true,
        frames = {
            "idle",
            
            "run",
            "run",
            "run",
            "run",
            
            "sprint",
            "sprint",
            "sprint",
            "sprint",
            
            "skid",
            
            "jump",
            
            "fall",
            
            "fly",
            
            "die",
            
            "duck",
            
            "buttSlide",
            
            "swim",
            "swim",
            "swim",
            "swim",
            
            "swimUp",
            "swimUp",
            "swimUp",
            
            "pipe",
            "useless",
            
            "holdIdle",
            
            "holdRun",
            "holdRun",
            "holdRun",
            "holdRun",
            
            "kick",
            
            "climb",
            "climb",
            
            "somerSault",
            "somerSault",
            "somerSault",
            "somerSault",
            "somerSault",
            "somerSault",
            "somerSault",
            "somerSault",
            
            "shoot",
            "shoot",
            "shoot",
            
            "shootAir",
            "shootAir",
            "shootAir",
        },
    },
    
    raccoon = {
        colors = {
            {252/255, 188/255, 176/255},
            {216/255,  40/255,   0/255},
            {  0/255,   0/255,   0/255},
        },
        width = 40,
        height = 40,
        centerX = 23,
        centerY = 24,
        canSpin = true,
        canFly = true,
        canFloat = true,
        canDuck = true,
        frames = {
            "idle",
            
            "run",
            "run",
            "run",
            "run",
            
            "sprint",
            "sprint",
            "sprint",
            "sprint",
            
            "skid",
            
            "jump",
            
            "fall",
            
            "fly",
            "fly",
            "fly",
            
            "float",
            "float",
            "float",
            
            "die",
            
            "duck",
            
            "buttSlide",
            
            "swim",
            "swim",
            "swim",
            "swim",
            
            "swimUp",
            "swimUp",
            "swimUp",
            
            "spin",
            "spin",
            "spin",
            "spin",
            
            "spinAir",
            "spinAir",
            "spinAir",
            "spinAir",
            
            "holdIdle",
            
            "holdRun",
            "holdRun",
            "holdRun",
            "holdRun",
            
            "kick",
            
            "climb",
            "climb",
            
            "somerSault",
            "somerSault",
            "somerSault",
            "somerSault",
            "somerSault",
            "somerSault",
            "somerSault",
            "somerSault",
        },
    },
    
    tanooki = {
        colors = {
            {252/255, 188/255, 176},
            {200/255,  76/255,  12},
            {  0/255,   0/255,   0},
        },
        width = 40,
        height = 40,
        centerX = 23,
        centerY = 24,
        canSpin = true,
        canFly = true,
        canFloat = true,
        canDuck = true,
        frames = {
            "idle",
            
            "run",
            "run",
            "run",
            "run",
            
            "sprint",
            "sprint",
            "sprint",
            "sprint",
            
            "skid",
            
            "jump",
            
            "fall",
            
            "fly",
            "fly",
            "fly",
            
            "float",
            "float",
            "float",
            
            "die",
            
            "duck",
            
            "buttSlide",
            
            "swim",
            "swim",
            "swim",
            "swim",
            
            "swimUp",
            "swimUp",
            "swimUp",
            
            "spin",
            "spin",
            "spin",
            "spin",
            
            "spinAir",
            "spinAir",
            "spinAir",
            "spinAir",
            
            "holdIdle",
            
            "holdRun",
            "holdRun",
            "holdRun",
            "holdRun",
            
            "kick",
            
            "climb",
            "climb",
            
            "somerSault",
            "somerSault",
            "somerSault",
            "somerSault",
            "somerSault",
            "somerSault",
            "somerSault",
            "somerSault",
            
            "statue",
        },
    }
}

local graphics = {}

local function getPath(i, j)
    return "characters/smb3-mario/graphics/" .. i .. "-" .. j .. ".png"
end

for i, v in pairs(powerUpStates) do
    graphics[i] = {}
    local char = graphics[i]
    
    for j, w in pairs(v) do
        char[j] = w
    end
    
    char.img = {}
    local imgWidth, imgHeight
    
    local j = 1
    local fileInfo = love.filesystem.getInfo(getPath(i, j))
    
    while fileInfo and fileInfo.type == "file" do
        char.img[j] = love.graphics.newImage(getPath(i, j))
        
        imgWidth = char.img[j]:getWidth()
        imgHeight = char.img[j]:getHeight()
        
        j = j + 1
        fileInfo = love.filesystem.getInfo(getPath(i, j))
    end
    
    local fileInfo = love.filesystem.getInfo(getPath(i, "static"))
    if fileInfo and fileInfo.type == "file" then
        char.img["static"] = love.graphics.newImage(getPath(i, "static"))
        
        imgWidth = char.img["static"]:getWidth()
        imgHeight = char.img["static"]:getHeight()
    end
    
    assert(imgWidth, "I couldn't load a single image for powerUpState \"" .. i .. "\", this is illegal and you're going to jail")
    
    char.quad = {}
    char.frames = {}
    
    for y = 1, 5 do
        char.quad[y] = {}
        local x = 0
        
        for _, name in ipairs(v.frames) do
            local quad = love.graphics.newQuad(x*v.width, (y-1)*v.height, v.width, v.height, imgWidth, imgHeight)
            
            if char.quad[y][name] then
                if type(char.quad[y][name]) ~= "table" then
                    char.quad[y][name] = {char.quad[y][name]}
                end
                
                table.insert(char.quad[y][name], quad)
                char.frames[name] = char.frames[name] + 1
            else
                char.quad[y][name] = quad
                char.frames[name] = 1
            end
                
            x = x + 1
        end
    end
end

function component.setup(actor)
    actor.img = graphics["small"].img
    actor.quad = graphics["small"].quad[3].idle
    
    actor.sizeX = graphics["small"].width
    actor.sizeY = graphics["small"].height
    
    actor.centerX = graphics["small"].centerX
    actor.centerY = graphics["small"].centerY
    
    actor.standardPalette = graphics["small"].colors
end

function component.postUpdate(actor, dt)
    animation(actor, dt)
end

function animation(actor, dt)
    -- Image updating for star
    if actor.starMan then
        -- get frame
        local palette = math.ceil(math.fmod(actor.starTimer, (#STARPALETTES+1)*STARFRAMETIME)/STARFRAMETIME)
        
        if palette == 4 then
            actor.palette = actor.standardPalette
        else
            actor.palette = STARPALETTES[palette]
        end
    end
    
    if actor.hasPortalGun then -- look towards portalGunAngle
        if math.abs(actor.portalGunAngle-actor.angle) <= math.pi*.5 then
            actor.animationDirection = 1
        else
            actor.animationDirection = -1
        end
        
    else -- look towards last pressed direction
        if cmdDown("left") then
            actor.animationDirection = -1
        elseif cmdDown("right") then
            actor.animationDirection = 1
        end
    end
    
    local frame = false
    
    if actor.spinning and (not actor.starMan or (actor.state.name ~= "jump" and actor.state.name ~= "fall"))  then
        if actor.onGround then
            actor.animationState = "spin"
        else
            actor.animationState = "spinAir"
        end
        
        actor.animationDirection = actor.spinDirection
        
        -- calculate spin frame from spinTimer
        frame = math.ceil(math.fmod(actor.spinTimer, graphics["small"].frames.spin*SPINFRAMETIME)/SPINFRAMETIME)

    elseif actor.shooting and (not actor.starMan or (actor.state.name ~= "jump" and actor.state.name ~= "fall")) then
        if actor.onGround then
            actor.animationState = "shoot"
        else
            actor.animationState = "shootAir"
        end
        
        frame = math.ceil(actor.shootTimer/SHOOTTIME*graphics["small"].frames.shoot)

    elseif actor.ducking then
        actor.animationState = "duck"
        
    elseif actor.state.name == "idle" then
        actor.animationState = "idle"
        
    elseif actor.state.name == "skid" then
        actor.animationState = "skid"
        
    elseif actor.state.name == "stop" or actor.state.name == "run" then
        if math.abs(actor.speed[1]) >= MAXSPEEDS[3] then
            actor.animationState = "sprint"
        else
            actor.animationState = "run"
        end
        
    elseif actor.flying and (actor.state.name == "jump" or actor.state.name == "fly" or actor.state.name == "fall") then
        actor.animationState = "fly"
    
    elseif actor.state.name == "buttSlide" then
        actor.animationState = "buttSlide"
        
    elseif actor.starMan and graphics["small"].frames.somerSault then
        actor.animationState = "somerSault"
        frame = actor.somerSaultFrame
        
    elseif actor.state.name == "float" then
        actor.animationState = "float"
        
    elseif actor.state.name == "jump" or actor.state.name == "fall" then
        if not graphics["small"].canFly and actor.pMeter == VAR("pMeterTicks") then
            actor.animationState = "fly"
        elseif (not graphics["small"].canFly and actor.maxSpeedJump == MAXSPEEDS[3]) or actor.flying then
            actor.animationState = "fly"
        else
            if actor.speed[2] < 0 then
                actor.animationState = "jump"
            else
                actor.animationState = "fall"
            end
        end
        
    end

    
    -- Running animation
    if (actor.animationState == "run" or actor.animationState == "sprint") then
        actor.runAnimationTimer = actor.runAnimationTimer + (math.abs(actor.speed[1])+50)/8*dt
        while actor.runAnimationTimer > RUNANIMATIONTIME do
            actor.runAnimationTimer = actor.runAnimationTimer - RUNANIMATIONTIME
            actor.runAnimationFrame = actor.runAnimationFrame + 1
            
            local runFrames = graphics["small"].frames.run

            if actor.runAnimationFrame > runFrames then
                actor.runAnimationFrame = actor.runAnimationFrame - runFrames
            end
        end
        
        frame = actor.runAnimationFrame
    end
    
    -- Flying animation
    if actor.animationState == "fly" then
        local flyFrames = graphics["small"].frames.fly
        
        if flyFrames > 1 then
            if actor.state.name == "fall" then
                actor.flyAnimationFrame = 2
            else
                actor.flyAnimationTimer = actor.flyAnimationTimer + dt
                while actor.flyAnimationTimer > FLYANIMATIONTIME do
                    actor.flyAnimationTimer = actor.flyAnimationTimer - FLYANIMATIONTIME
                    actor.flyAnimationFrame = actor.flyAnimationFrame + 1

                    if actor.flyAnimationFrame > flyFrames then
                        actor.flyAnimationFrame = flyFrames -- don't reset to the start
                    end
                end
            end
            
            frame = actor.flyAnimationFrame
        end
    end
    
    -- Float animation
    if actor.animationState == "float" then
        actor.floatAnimationTimer = actor.floatAnimationTimer + dt
        while actor.floatAnimationTimer > FLYANIMATIONTIME do
            actor.floatAnimationTimer = actor.floatAnimationTimer - FLYANIMATIONTIME
            actor.floatAnimationFrame = actor.floatAnimationFrame + 1

            local floatFrames = graphics["small"].frames.float
            if actor.floatAnimationFrame > floatFrames then
                actor.floatAnimationFrame = floatFrames -- don't reset to the start
            end
        end
        
        frame = actor.floatAnimationFrame
    end
    
    -- Make sure to properly use the tables if it's an animationState with frames
    if frame then
        actor.quad = graphics["small"].quad[getAngleFrame(actor)][actor.animationState][frame]
    else
        actor.quad = graphics["small"].quad[getAngleFrame(actor)][actor.animationState]
    end
    
    assert(type(actor.quad) == "userdata", "The state \"" .. actor.animationState .. "\" seems to not be have a quad set up correctly.")
end

function getAngleFrame(actor)
    if not actor.hasPortalGun then
        return 5
    end

    local angle = actor.portalGunAngle-actor.angle
    
    if angle > math.pi*.5 then
        angle = math.pi - angle
    elseif angle < -math.pi*.5 then
        angle = -math.pi - angle
    end
    
    if angle < -math.pi*0.375 then
        return 1
    elseif angle < -math.pi*0.125 then
        return 2
    elseif angle < math.pi*0.125  then
        return 3
    elseif angle < math.pi*0.375 then
        return 4
    else -- Downward frame looks dumb
        return 4
    end
end

return component
