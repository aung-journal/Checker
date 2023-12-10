StartState = Class{__includes = BaseState}

function StartState:init()
    self.user = None
end

function StartState:update(dt)

end

function StartState:draw()
    love.graphics.setFont(gFonts['title'])
    love.graphics.printf("Play Checker", VIRTUAL_WIDTH / 2, 108, "center")
end