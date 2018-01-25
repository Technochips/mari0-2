--Mari3 - MIT License.
require "loop"

function love.load()
    require "util"
    
    love.window.setMode(400*VAR("scale"), 224*VAR("scale"), {
        vsync = VAR("vsync"),
        resizable = true,
        msaa = msaa,
        minwidth = 232*VAR("scale"),
        minheight = 165*VAR("scale"),
    })

    love.window.setTitle("Definitely not Mari0 2")
    
    love.graphics.setDefaultFilter("nearest", "nearest")
    
    sandbox = require "lib.sandbox"
    JSON = require "lib.JSON"
    class = require "lib.middleclass"
    Camera = require "lib.Camera"
    Color = require "lib.Color"
    Easing = require "lib.Easing"
    GameStateManager = require "lib.GameStateManager"
    Font3 = require "lib.Font3"
    require "lib.Physics3"
    require "lib.Gui3"
    prof = require "lib.jprof.jprof"

    require "class.CharacterState"
    require "class.Character"
    require "enemyLoader"

    require "class.Level"
    require "class.Mario"
    require "class.BlockBounce"
    require "class.Enemy"
    require "class.Portal"
    require "class.PortalParticle"
    require "class.PortalThing"
    require "class.Smb3Ui"
    require "class.Crosshair"
    require "class.EditorState"
    require "class.Selection"
    require "class.FloatingSelection"
    require "class.StampMap"
    
    require "cheats"
    
    require "state.Game"
    require "state.Editor"
    
    fontOutlined = love.graphics.newImageFont("img/font-outlined.png", " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789$.,:;!?_-<>=+*\\/'%^~")
    love.graphics.setFont(fontOutlined)

    -- font = Font3:new(love.graphics.newImage("img/font.png"), [[
    --     ABCDEFGHIJKLMNOPQRSTUVWXYZ
    --     abcdefghijklmnopqrstuvwxyz
    --     0123456789
    --     &Space;
    --     .;:;!?_-<>=+*/\'%
    --     &Intersect;
    --     &Move;
    -- ]])

    debugCandyImg = love.graphics.newImage("img/debug-candy.png")
    debugCandyImg:setWrap("repeat")

    if love.math.random() > 0.9 then
        funkyImg = love.graphics.newImage("img/funky.png")
    end
    
    defaultUI = Gui3:new("img/gui/default")
    
    gameStateManager = GameStateManager:new()
    
    love.resize(400*VAR("scale"), 224*VAR("scale"))

    game = Game:new()

    gameStateManager:loadState(game)
    gameStateManager:addState(Editor:new(game.level))
end

function love.update(dt)
    prof.enabled(true)
    prof.push("frame")
    prof.push("update")
    dt = math.min(1/30, dt)

	if VAR("ffKeys") then
        for _, v in ipairs(VAR("ffKeys")) do
			if love.keyboard.isDown(v.key) then
				dt = dt * v.val
			end
		end
    end

    gameStateManager:event("update", dt)
    prof.pop()
end

local function setColorBasedOn(key)
    if cmdDown(key) then
        love.graphics.setColor(1, 1, 1)
    else
        love.graphics.setColor(0.2, 0.2, 0.2)
    end
end

function love.draw()
    prof.push("draw")
    if VAR("scale") ~= 1 then
        love.graphics.scale(VAR("scale"), VAR("scale"))
    end
    
    gameStateManager:event("draw")
    
    if VAR("characterStateDebug") then
        love.graphics.print(game.level.marios[1].state.name, 8, 8)
    end
    
    -- For the stream
    if VAR("inputDebug") then
        setColorBasedOn("up")
        love.graphics.rectangle("fill", 16, SCREENHEIGHT-32, 8, 8)
        setColorBasedOn("left")
        love.graphics.rectangle("fill", 8, SCREENHEIGHT-24, 8, 8)
        setColorBasedOn("right")
        love.graphics.rectangle("fill", 24, SCREENHEIGHT-24, 8, 8)
        setColorBasedOn("down")
        love.graphics.rectangle("fill", 16, SCREENHEIGHT-16, 8, 8)
        
        setColorBasedOn("run")
        love.graphics.rectangle("fill", 60, SCREENHEIGHT-20, 8, 8)
        setColorBasedOn("jump")
        love.graphics.rectangle("fill", 72, SCREENHEIGHT-20, 8, 8)
        
        
        love.graphics.setColor(1, 1, 1)
    end

    if VAR("memoryDebug") then
        love.graphics.print(tostring(collectgarbage("count")*1024), 10, 10)
    end

    if VAR("scale") ~= 1 then
        love.graphics.scale(1/VAR("scale"), 1/VAR("scale"))
    end

    if funkyImg then
        love.graphics.draw(funkyImg, love.graphics.getWidth(), 0, 0, 1, 1, 340)
    end
    prof.pop()
    prof.pop()
    prof.enabled(false)
end

function appendCmds(cmds, t)
    if type(t) == "string" then
        cmds[t] = true
    elseif type(t) == "table" then
        for _, v in ipairs(t) do
            cmds[v] = true
        end
    end
end

function love.keypressed(key)
    -- Convert the key to its binding
    -- ^ctrl !alt +shift
    
    local cmds = {}
    local sendCmds = false
    if CONTROLS(key) then
        appendCmds(cmds, CONTROLS(key))
        sendCmds = true
    end

    appendCmds(cmds, CONTROLS(key))

    local keyModified = key

    if key ~= "lshift" and key ~= "rshift" and key ~= "lalt" and key ~= "ralt" and key ~= "lctrl" and key ~= "rctrl" then
        if love.keyboard.isDown({"lshift", "rshift"}) then
            keyModified = "+" .. keyModified
        end

        if love.keyboard.isDown({"lalt", "ralt"}) then
            keyModified = "!" .. keyModified
        end

        if love.keyboard.isDown({"lctrl", "rctrl"}) then
            keyModified = "^" .. keyModified
        end
    end
    
    if keyModified ~= key then
        if CONTROLS(keyModified) then
            appendCmds(cmds, CONTROLS(keyModified))
            sendCmds = true
        end
    end
    
    if cmds["quit"] then
        love.event.quit()
        return
    end

    if sendCmds then
        gameStateManager:event("cmdpressed", cmds)
    end
    
    gameStateManager:event("keypressed", key)
end

function getWorldMouse()
    return love.mouse.getX()/VAR("scale"), love.mouse.getY()/VAR("scale")
end

function love.mousepressed(x, y, button)
    x, y = getWorldMouse()
    
    gameStateManager:event("mousepressed", x, y, button)
end

function love.mousereleased(x, y, button)
    x, y = getWorldMouse()
    
    gameStateManager:event("mousereleased", x, y, button)
end

function love.mousemoved(x, y, dx, dy)
    dx, dy = dx/VAR("scale"), dy/VAR("scale")
    
    gameStateManager:event("mousemoved", dx, dy)
end

function love.resize(w, h)
    SCREENWIDTH = w/VAR("scale")
    SCREENHEIGHT = h/VAR("scale")
    
    updateSizes()
    
    gameStateManager:event("resize", SCREENWIDTH, SCREENHEIGHT)
end

function love.quit()
    if PROF_CAPTURE then
        prof.write("lastrun.prof")
    end
end

function updateSizes()
    CAMERAWIDTH = SCREENWIDTH
    CAMERAHEIGHT = SCREENHEIGHT
    
    if not game or game.uiVisible then
        CAMERAHEIGHT = CAMERAHEIGHT-VAR("uiLineHeight")-VAR("uiHeight")
    end

    WIDTH = math.ceil(CAMERAWIDTH/VAR("tileSize"))
    HEIGHT = math.ceil(CAMERAHEIGHT/VAR("tileSize"))
    
    RIGHTSCROLLBORDER = VAR("cameraScrollRightBorder")
    LEFTSCROLLBORDER = VAR("cameraScrollLeftBorder")
    
    DOWNSCROLLBORDER = VAR("cameraScrollDownBorder")
    UPSCROLLBORDER = VAR("cameraScrollUpBorder")

    debugCandyQuad = love.graphics.newQuad(0, 0, SCREENWIDTH, SCREENHEIGHT, 8, 8)
end

function love.wheelmoved(x, y)
    gameStateManager:event("wheelmoved", x, y)
end

function updateGroup(group, dt)
	for i = #group, 1, -1 do
		if group[i]:update(dt) or group[i].deleteMe then
			table.remove(group, i)
		end
	end
end

function playMusic(music)
    playSound(music)
end

function playSound(sound)
    if not sound then
        print("Error playing some sound")
        return
    end
    
    sound:stop()
    sound:play()
end

-- function love.graphics.print(s, x, y, align)
--     local len = string.len(tostring(s))
    
--     if align == "center" then
--         x = x - len*4
--     elseif align == "right" then
--         x = x - len*8
--     end
    
-- 	for i = 1, len do
-- 		local quad = fontQuad[string.sub(s, i, i)]
        
-- 		if quad then
-- 			love.graphics.draw(fontImg, quad, (x+(i-1)*8), y, 0, 1, 1)
-- 		end
-- 	end
-- end

function worldArrow(x, y, xDir, yDir)
    local scale = math.sqrt(xDir^2+yDir^2)/8
    local angle = math.atan2(yDir, xDir)
    local arrowTipScale = 0.2
    
    --body
    local x2, y2 = x+math.cos(angle)*scale, y+math.sin(angle)*scale
    
    love.graphics.line(x, y, x2, y2)
    
    --tipleft
    local x3, y3 = x2+math.cos(angle-math.pi*0.75)*scale*arrowTipScale, y2+math.sin(angle-math.pi*0.75)*scale*arrowTipScale
    love.graphics.line(x2, y2, x3, y3)
    
    --tipright
    local x4, y4 = x2+math.cos(angle+math.pi*0.75)*scale*arrowTipScale, y2+math.sin(angle+math.pi*0.75)*scale*arrowTipScale
    love.graphics.line(x2, y2, x4, y4)
end
