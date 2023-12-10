Control = Class{}

function Control:init()

end

function Control:update(dt)
    if love.keyboard.wasPressed('escape') or love.keyboard.wasPressed('return') then
        love.event.quit()
    end
end