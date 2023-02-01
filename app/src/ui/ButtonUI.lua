--[[
--
-- Halmö
--
-- (c) 2015-2023 Younis Bensalah <younis.bensalah@gmail.com>
--
--]]
local ButtonUI = class("ButtonUI")

ButtonUI:include(mixins.hooks)

function ButtonUI:initialize(button)
    assert(button and button.text and button.id)

    self.button = {
        id = button.id,
        text = button.text,
        r = button.r or 160 / 255,
        g = button.g or 224 / 255,
        b = button.b or 63 / 255,
        a = button.a or 1,
        x = -1,
        y = -1,
        w = -1,
        h = -1,
        disabled = button.disabled or false,
        active = false
    }

    self.font = love.graphics.newFont("assets/fonts/Azonix.otf", 48)

    self:init_hooks(
        {
            "on_press"
        }
    )
end

function ButtonUI:draw()
    self.button.w = self.font:getWidth(self.button.text)
    self.button.h = self.font:getHeight(self.button.text)
    self.button.x = 0
    self.button.y = 0
    local canvas = love.graphics.newCanvas(self.button.w, self.button.h)
    canvas:renderTo(
        function()
            love.graphics.push()
            if self.button.disabled then
                love.graphics.setColor(20 / 255, 20 / 255, 20 / 255, 1)
            else
                if self.button.active then
                    love.graphics.setColor(self.button.r, self.button.g, self.button.b, self.button.a)
                else
                    love.graphics.setColor(1, 1, 1, 1)
                end
            end
            love.graphics.print(self.button.text, self.font, self.button.x, self.button.y)
            love.graphics.pop()
        end
    )
    return canvas
end

function ButtonUI:update_mouse(x, y)
    if
        self.button.x <= x and x <= self.button.x + self.button.w and self.button.y <= y and
            y <= self.button.y + self.button.h
     then
        self.button.active = true
    else
        self.button.active = false
    end
end

function ButtonUI:mouse_pressed(x, y, button)
end

function ButtonUI:mouse_released(x, y, button)
    if button == 1 then
        if
            self.button.x <= x and x <= self.button.x + self.button.w and self.button.y <= y and
                y <= self.button.y + self.button.h
         then
            self:notify_hooks("on_press", self.button)
        end
    end
end

function ButtonUI:set_disabled(flag)
    self.button.disabled = flag
end

return ButtonUI
