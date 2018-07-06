local Cell = class("Physics3.Cell")
Cell:include(Physics3collisionMixin)

Cell.bounceTime = 10/60
Cell.bounceHeight = 10

function Cell.bounceEase(a, b, c, d)
    if a < d/2 then
        return Easing.outQuad(a, b, c, d/2)
    else
        return Easing.inQuad(a-d/2, c, b-c, d/2)
    end
end

function Cell:initialize(tile)
    self.tile = tile
    self.coin = false

    self.bounceTimer = self.bounceTime
end

function Cell:update(dt)
    if self.bounceTimer < self.bounceTime then
        self.bounceTimer = math.min(self.bounceTime, self.bounceTimer + dt)

        return self.bounceTimer >= self.bounceTime
    end
end

function Cell:draw(x, y)
    if self.tile then
        local off = 0

        if self.bounceTimer < self.bounceTime then
            off = self.bounceEase(self.bounceTimer, 0, 1, self.bounceTime)
        end

        self.tile:draw(x, y-off*self.bounceHeight)
    end

    if self.coin then
        game.mappack.coinTile:draw(x, y)
    end
end

function Cell:bounce()
    self.bounceTimer = 0
end

return Cell
