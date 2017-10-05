World = class("World")

function World:initialize()
	self.objects = {}
	self.activeObjects = {}
	self.staticObjects = {}
	
	self.blockLookup = {}
end

function World:addObject(obj)
	if obj.block then -- add to lookup table
		if not self.blockLookup[obj.blockX] then
			self.blockLookup[obj.blockX] = {}
		end
		
		self.blockLookup[obj.blockX][obj.blockY] = obj

	elseif obj.static then -- add to static list (don't have move code or check for their own collision)
		table.insert(self.staticObjects, obj)

	else -- add to generic collision check table
		table.insert(self.activeObjects, obj)

	end
end

function World:draw()
	for _, obj in ipairs(self.activeObjects) do
		if game.level:objVisible(obj.x, obj.y, obj.width, obj.height) then
			self:drawObject(obj)
		end
	end

	if(PHYSICSDEBUG) then
		for _, obj in ipairs(self.activeObjects) do
			self:debugDrawObject(obj)
		end
		for _, obj in ipairs(self.staticObjects) do
			self:debugDrawObject(obj)
		end
	end
end

function World:drawObject(obj)
    mainPerformanceTracker:track("worldobjects drawn")
    worldDraw(obj.img, obj.quad, obj.x+obj.width/2, obj.y+obj.height/2, obj.r or 0, obj.animationDirection or 1, 1, obj.centerX, obj.centerY)
end

function World:debugDrawObject(obj)
	love.graphics.rectangle("line", obj.x*TILESIZE+.5, obj.y*TILESIZE+.5, obj.width*TILESIZE-1, obj.height*TILESIZE-1)
end

function World:update(dt)
    updateGroup(self.activeObjects, dt)

	mainPerformanceTracker:track("active objects", #game.level.world.activeObjects)
	mainPerformanceTracker:track("static objects", #game.level.world.staticObjects)
	
	self:physics(dt)
end

function World:physics(dt)
	for _, obj1 in ipairs(self.activeObjects) do
		-- Gravity (half of it before, half after)
		obj1.speedY = obj1.speedY + (obj1.gravity or GRAVITY)*dt*0.5
		
		if obj1.speedY > MAXYSPEED then
			obj1.speedY = MAXYSPEED
		end

		-- Precalculate nextX and nextY because I use them a lot
		obj1.nextX = obj1.x + obj1.speedX*dt
		obj1.nextY = obj1.y + obj1.speedY*dt
		
		-- Collision results
		local horcollision = false
		local vercollision = false
		
		-- Portal check
		for _, v in ipairs(game.level.portals) do
			local iX, iY = linesIntersect(obj1.x+obj1.width/2, obj1.y+obj1.height/2, obj1.nextX+obj1.width/2, obj1.nextY+obj1.height/2, v.x1, v.y1, v.x2, v.y2)
			if iX then
				doPortal(obj1, v, iX, iY)

				obj1.nextX = obj1.x + obj1.speedX*dt
				obj1.nextY = obj1.y + obj1.speedY*dt

				sameframe = true
				break
			end
		end

		local obj1Side
		local inPortal = false
		for _, v in ipairs(game.level.portals) do
			if rectangleOnLine(obj1.nextX, obj1.nextY, obj1.width, obj1.height, v.x1, v.y1, v.x2, v.y2) then
				inPortal = v

				print("!")

				obj1Side = sideOfLine(obj1.nextX+obj1.width/2, obj1.nextY+obj1.height/2, inPortal.x1, inPortal.y1, inPortal.x2, inPortal.y2)
				local prevSide = sideOfLine(obj1.x+obj1.width/2, obj1.y+obj1.height/2, inPortal.x1, inPortal.y1, inPortal.x2, inPortal.y2)
			end
		end
		
		-- VS blocks (carefuly select which blocks to check against)
		-- Don't do any of this if inside a portal!
		local xstart = math.floor(obj1.nextX-2/16)+1
		local ystart = math.floor(obj1.nextY-2/16)+1
		
		local xto = xstart+math.ceil(obj1.width)
		local dir = 1
		
		if obj1.speedX < 0 then
			xstart, xto = xto, xstart
			dir = -1
		end
		
		for x = xstart, xto, dir do
			for y = ystart, ystart+math.ceil(obj1.height) do
				local obj2 = self.blockLookup[x] and self.blockLookup[x][y]
				if obj2 then
					-- Check if on other side of portal
					local noCollision = false
					if inPortal then
						local blockSide = sideOfLine(x-.5, y-.5, inPortal.x1, inPortal.y1, inPortal.x2, inPortal.y2)

						if (blockSide > 0 and obj1Side < 0) or (blockSide < 0 and obj1Side > 0) then
							noCollision = true
						end
					end

					if not noCollision then
						local collision1, collision2 = self:checkcollision(obj1, obj2, dt)

						if collision1 then
							horcollision = collision1
						end
						if collision2 then
							vercollision = collision2
						end
					end
				end
			end
		end
		
		-- VS other, active objects
		for _, obj2 in ipairs(self.activeObjects) do
			if obj1 ~= obj2 then
				local collision1, collision2 = self:checkcollision(obj1, obj2, dt)
				if collision1 then
					horcollision = collision1
				end
				if collision2 then
					vercollision = collision2
				end
			end
		end
		
		-- VS other, static objects
		for _, obj2 in ipairs(self.staticObjects) do
			local collision1, collision2 = self:checkcollision(obj1, obj2, dt)
			if collision1 then
				horcollision = collision1
			end
			if collision2 then
				vercollision = collision2
			end
		end

		-- Move the object if no collision in that direction was noticed
		if not vercollision then
			obj1.y = obj1.nextY
			
			if obj1.onGround then
				obj1.onGround = false
				if obj1.speedY >= 0 then
					obj1:startFall()
				end
			end
		elseif vercollision == "floor" then
			obj1.onGround = true
		end
		
		if horcollision == false then
			obj1.x = obj1.nextX
		end
		
		-- Gravity
		obj1.speedY = obj1.speedY + (obj1.gravity or GRAVITY)*dt*0.5
	end
end

function World:checkcollision(obj1, obj2, dt)
	local horcollision = false
	local vercollision = false
	local updateNextPos = false
	
	if aabb(obj1.nextX, obj1.nextY, obj1.width, obj1.height, obj2.x, obj2.y, obj2.width, obj2.height) then
		if aabb(obj1.nextX, obj1.y, obj1.width, obj1.height, obj2.x, obj2.y, obj2.width, obj2.height) then -- Collision is horizontal
			horcollision = self:horcollision(obj1, obj2)
			
		elseif aabb(obj1.x, obj1.nextY, obj1.width, obj1.height, obj2.x, obj2.y, obj2.width, obj2.height) then -- Collision is vertical
			vercollision = self:vercollision(obj1, obj2)
			
		elseif aabb(obj1.x, obj1.y, obj1.width, obj1.height, obj2.x, obj2.y, obj2.width, obj2.height) then -- Passive collision
			obj1:passiveCollide(obj2)
			obj2:passiveCollide(obj1)

		else -- Diagonal collision
			if math.abs(obj1.speedX) > math.abs(obj1.speedY) then -- Mainly moving horizontally
				horcollision = self:horcollision(obj1, obj2)
			else
				vercollision = self:vercollision(obj1, obj2)
			end
		end

		-- Update projected next position because it may have been changed in callbacks and by the detection itself
		obj1.nextX = obj1.x + obj1.speedX*dt
		obj1.nextY = obj1.y + obj1.speedY*dt
	end
	
	return horcollision, vercollision
end

function World:horcollision(obj1, obj2)
	if obj1.speedX < 0 then
		--move object RIGHT (because it was moving left)
		if not obj2:rightCollide(obj1) then
			obj2.speedX = math.min(0, obj2.speedX)
		end

		if not obj1:leftCollide(obj2) then
			obj1.speedX = math.max(0, obj1.speedX)
			obj1.x = obj2.x + obj2.width
			
			return "left"
		end
	else
		--move object LEFT (because it was moving right)
		if not obj2:leftCollide(obj1) then
			obj2.speedX = math.max(0, obj2.speedX)
		end
		
		if not obj1:rightCollide(obj2) then
			obj1.speedX = math.min(0, obj1.speedX)
			obj1.x = obj2.x - obj1.width

			return "right"
		end
	end
	
	return false
end

function World:vercollision(obj1, obj2)
	if obj1.speedY < 0 then
		--move object DOWN (because it was moving up)
		if not obj2:floorCollide(obj1) then
			obj2.speedY = math.min(0, obj2.speedY)
		end
		
		if not obj1:ceilCollide(obj2) then
			obj1.speedY = math.max(0, obj1.speedY)
			obj1.y = obj2.y  + obj2.height

			return "ceil"
		end
	else					
		if not obj2:ceilCollide(obj1) then
			obj2.speedY = math.max(0, obj2.speedY)
		end

		if not obj1:floorCollide(obj2) then
			obj1.speedY = math.min(0, obj1.speedY)
			obj1.y = obj2.y - obj1.height

			return "floor"
		end
	end

	return false
end

function aabb(ax, ay, awidth, aheight, bx, by, bwidth, bheight)
	mainPerformanceTracker:track("aabb checks")
	return ax+awidth > bx and ax < bx+bwidth and ay+aheight > by and ay < by+bheight
end

function doPortal(obj, portal, iX, iY)
	-- Modify speed
	local speed = math.sqrt(obj.speedX^2 + obj.speedY^2)
	local r = portal.connectsTo.r - math.atan2(obj.speedY, obj.speedX) + portal.r

	obj.speedX = math.cos(r)*speed
	obj.speedY = math.sin(r)*speed

	-- Modify position
	-- Rotate aroun entry portal
	local newX, newY = pointAroundPoint(obj.nextX+obj.width/2, obj.nextY+obj.height/2, portal.x1, portal.y1, -portal.r)

	-- Translate by portal offset
	newX = newX + (portal.connectsTo.x1 - portal.x1)
	newY = newY + (portal.connectsTo.y1 - portal.y1)

	-- Rotate around exit portal
	newX, newY = pointAroundPoint(newX, newY, portal.connectsTo.x1, portal.connectsTo.y1, portal.connectsTo.r)

	obj.x = newX-obj.width/2
	obj.y = newY-obj.height/2
end
