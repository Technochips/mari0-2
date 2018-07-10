local Tile = class("Physics3.Tile")

function Tile:initialize(tileMap, img, x, y, num, props, path)
	self.tileMap = tileMap
	self.tileSize = self.tileMap and self.tileMap.tileSize or 16
	self.x = x
	self.y = y
	self.num = num
	self.props = props or {}
	self.path = path

	self.type = self.props.type or "normal"
	self.angle = self.props.angle or 0

	self.collision = self.props.collision or false

	self:cacheCollisions()

	if self.props.img then
		self.img = love.graphics.newImage(self.path .. self.props.img)

		self.quads = {}

		for qx = 1, (self.img:getWidth()+1)/self.tileSize do
			table.insert(self.quads, love.graphics.newQuad((qx-1)*17, 0, 16, 16, self.img:getWidth(), self.img:getHeight()))
		end

		self.timer = 0
		self.frame = 1

		self.quad = self.quads[self.frame]
	elseif img then
		self.img = img
		self.quad = love.graphics.newQuad(
			(self.x-1)*(self.tileMap.tileSize+self.tileMap.tileMargin),
			(self.y-1)*(self.tileMap.tileSize+self.tileMap.tileMargin),
			self.tileMap.tileSize,
			self.tileMap.tileSize,
			self.img:getWidth(),
			self.img:getHeight()
		)
	end
end

function Tile:getDelay()
	return self.props.delays[(self.frame-1)%#self.props.delays+1]
end

function Tile:update(dt)
	self.timer = self.timer + dt

	while self.timer >= self:getDelay() do
		self.timer = self.timer - self:getDelay()

		self.frame = self.frame + 1

		if self.frame > #self.quads then
			self.frame = 1
		end

		self.quad = self.quads[self.frame]
	end
end

function Tile:cacheCollisions()
	if not self.collision or self.collision == VAR("tileTemplates").cube then
		-- don't need to calculate collisions for this
		return
	end

	if self.collision and type(self.collision) == "table" then
		self.collisionTriangulated = love.math.triangulate(self.collision)
	end

	self.collisionCache = {}

	for x = 0, 15 do
		self.collisionCache[x] = {}
		for y = 0, 15 do
			local col = false

			for _, points in ipairs(self.collisionTriangulated) do
				if pointInTriangle(x+0.5, y+0.5, points) then
					col = true
					break
				end
			end

			self.collisionCache[x][y] = col
		end
	end
end

function Tile:checkCollision(x, y, obj, vector, cellX, cellY)
	if not self.collision then
		return false
	end

	if self.props.exclusiveCollision and vector then -- override collision with a false maybe
		if self.props.exclusiveCollision == 1 then
			if  obj.prevY+obj.height > (cellY-1)*16 or
				vector.x ~= 0 or
				vector.y ~= 1 then
				return false
			end
		elseif self.props.exclusiveCollision == 2 then
			if  obj.prevX < (cellX)*16 or
				vector.x ~= -1 or
				vector.y ~= 0 then
				return false
			end
		elseif self.props.exclusiveCollision == 3 then
			if  obj.prevY < (cellY)*16 or
				vector.x ~= 0 or
				vector.y ~= -1 then
				return false
			end
		elseif self.props.exclusiveCollision == 4 then
			if  obj.prevX+obj.width > (cellX-1)*16 or
				vector.x ~= 1 or
				vector.y ~= 0 then
				return false
			end
		end
    end

	if self.collision == VAR("tileTemplates").cube then -- optimization for cubes
		return true
	else
		x = math.floor(x)
		y = math.floor(y)

		return self.collisionCache[x][y]
	end
end

function Tile:draw(x, y)
	love.graphics.draw(self.img, self.quad, x, y)
end

function Tile:getAverageColor()
	if not self.averageColor then
		local tr, tg, tb = 0, 0, 0

		for y = 0, 15 do
			for x = 0, 15 do
				local r, g, b, a = self.tileMap.imgData:getPixel((self.x-1)*17+x, (self.y-1)*17+y)

				if a == 0 then -- use level background color if transparent
					tr = tr + game.level.backgroundColor[1]
					tg = tg + game.level.backgroundColor[2]
					tb = tb + game.level.backgroundColor[3]
				else
					tr = tr + r
					tg = tg + g
					tb = tb + b
				end
			end
		end

		local pixels = 16*16

		self.averageColor = {
			tr/pixels,
			tg/pixels,
			tb/pixels,
			1,--ta/pixels,
		}
	end

	return self.averageColor
end

function Tile:getSideAngle(side)
	local point = side*2-1
	local nextPoint = point+2

	if nextPoint > #self.collision then
		nextPoint = 1
	end

	return math.atan2(self.collision[nextPoint+1] - self.collision[point+1], self.collision[nextPoint] - self.collision[point])
end

function Tile:sidePortalable(side)
	if not self.props.nonPortalable then
		return true

	elseif type(self.props.nonPortalable) == "boolean" then
		return not self.props.nonPortalable

	elseif type(self.props.nonPortalable) == "table" then
		return not self.props.nonPortalable[side]

	end
end

return Tile