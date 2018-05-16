local stompable = class("misc.stompable")

function stompable:initialize(actor, args)
    self.actor = actor
    self.args = args

    self:setup()
end

function stompable:setup()
    self.actor.stompAble = true
    self.actor.stompAbleLevel = self.args.level or 1
end

function stompable:getStomped()
    print(self.args.loadActorTemplate)
    if self.args.loadActorTemplate then
        self.actor:loadActorTemplate(actorTemplates[self.args.loadActorTemplate])
    end
end

return stompable
