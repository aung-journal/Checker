StartState = Class{__includes = BaseState}

function StartState:init()
    self.menu = {
        "Play First",
        "Play Second"
    }
    self.currentMenuItem = 1
end

function StartState:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    -- if love.keyboard.wasPressed('down') then
    --     self.currentMenuItem = math.min(#self.menu, self.currentMenuItem + 1)
    
    -- elseif love.keyboard.wasPressed('up') then
    --     self.currentMenuItem = math.max(1, self.currentMenuItem - 1)
    
    -- end

    for i, option in ipairs(self.menu) do
        local optionX = VIRTUAL_WIDTH / 2 - gFonts['large']:getWidth(option) / 2
        local optionY = 198 + (i - 1) * 102

        local mouseX, mouseY = push:toGame(love.mouse.getPosition())

        if mouseX and mouseY then
            if mouseX >= optionX and mouseX <= optionX + gFonts['large']:getWidth(option) and
            mouseY >= optionY and mouseY <= optionY + gFonts['large']:getHeight() then
                self.currentMenuItem = i
                break
            else
                self.currentMenuItem = 0
            end
        end
    end

    if love.mouse.isDown(1) then
        for i, option in ipairs(self.menu) do
            if self.currentMenuItem == i then
                self.user = self.currentMenuItem == 1 and checker.X or checker.O
                gStateMachine:change('play', {
                    user = self.user
                })
            end
        end
    end
end

function StartState:render()
    -- love.graphics.setFont(gFonts['gothic-large'])
    -- love.graphics.printf('Legend of', 0, VIRTUAL_HEIGHT / 2 - 32, VIRTUAL_WIDTH, 'center')

    -- love.graphics.setFont(gFonts['gothic-large'])
    -- love.graphics.printf('Azimuth', 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['title'])
    love.graphics.setColor(34/255, 34/255, 34/255, 1)
    love.graphics.printf('Checker Bot', 2, 0, VIRTUAL_WIDTH, 'center')

    love.graphics.setColor(175/255, 53/255, 42/255, 1)
    love.graphics.printf('Checker Bot', 0, 2, VIRTUAL_WIDTH, 'center')

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(gFonts['large'])

    for i, option in ipairs(self.menu) do
        -- draw option text shadow
        self:drawTextShadow(option, 198 + (i - 1) * 102)

        -- set color based on current menu item
        if self.currentMenuItem == i then
            love.graphics.setColor(99/255, 155/255, 1, 1)
        else
            love.graphics.setColor(1, 1, 1, 1)
        end

        -- draw option text
        love.graphics.printf(option, 0, 198 + (i - 1) * 102, VIRTUAL_WIDTH, 'center')
    end
end

--love.graphics.printf('Press Enter', 0, VIRTUAL_HEIGHT / 2 + 64, VIRTUAL_WIDTH, 'center')
--[[
    Helper function for drawing just text backgrounds; draws several layers of the same text, in
    black, over top of one another for a thicker shadow.
]]
function StartState:drawTextShadow(text, y)
    love.graphics.setColor(34/255, 32/255, 52/255, 1)
    love.graphics.printf(text, 2, y + 1, VIRTUAL_WIDTH, 'center')
    love.graphics.printf(text, 1, y + 1, VIRTUAL_WIDTH, 'center')
    love.graphics.printf(text, 0, y + 1, VIRTUAL_WIDTH, 'center')
    love.graphics.printf(text, 1, y + 2, VIRTUAL_WIDTH, 'center')
end