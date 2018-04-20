local component = {}

local MIRRORTIME = 0.2

function component.setup(actor, dt, actorEvent, args)
    actor.img = actor.actorTemplate.img

    actor.quadWidth = actor.img:getWidth()
    actor.quadHeight = actor.img:getHeight()
    
    actor.centerX = args.centerX
    actor.centerY = args.centerY

    actor.mirrorTimer = 0
    actor.animationDirection = 1
end

function component.update(actor, dt)
    actor.mirrorTimer = actor.mirrorTimer + dt

    while actor.mirrorTimer > MIRRORTIME do
        actor.mirrorTimer = actor.mirrorTimer - MIRRORTIME
        
        actor.animationDirection = -actor.animationDirection
    end
end

return component