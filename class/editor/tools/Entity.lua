local Entity = class("Editor.Entity")

function Entity:initialize(editor)
    self.editor = editor

    self.level = self.editor.level
    self.grabbing = false
    self.grabbedObj = nil
    self.grabbedObjX = 0
    self.grabbedObjY = 0

    self.oldX = 0
    self.oldY = 0
end

function Entity:update()
    local x, y = self.level:mouseToWorld()

    if self.grabbing then
        self.grabbedObj.x = x + self.grabbedObjX
        self.grabbedObj.y = y + self.grabbedObjY
        self.grabbedObj.speed[1] = (x - self.oldX)*256
        self.grabbedObj.speed[2] = (y - self.oldY)*256
    end

    self.oldX = x
    self.oldY = y
end
function Entity:mousepressed(x, y, button)
    if button ~= 1 then return true end

    -- grab first object that's on the mouse
    local x, y = self.level:cameraToWorld(x, y)
    for _, obj in ipairs(self.level.objects) do
        if x >= obj.x and x <= obj.x+obj.width and y >= obj.y and y <= obj.y+obj.height then
            self.grabbing = true
            self.grabbedObj = obj
            self.grabbedObjX = obj.x - x
            self.grabbedObjY = obj.y - y
            break
        end
    end

    return true
end
function Entity:mousereleased(x, y, button)
    if button ~= 1 then return end

    self.grabbing = false
end

return Entity
