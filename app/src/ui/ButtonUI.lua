--[[
--
-- Halmö
--
-- (c) 2015-2023 Younis Bensalah <younis.bensalah@gmail.com>
--
--]]
local ButtonUI = class("ButtonUI", Drawable)

function ButtonUI:initialize(button)
    assert(button and button.text)

    self.id = button.id or button.text
    self.text = button.text

    self.r = button.r or 160 / 255
    self.g = button.g or 224 / 255
    self.b = button.b or 63 / 255
    self.a = button.a or 1
    self.x = -1
    self.y = -1
    self.w = -1
    self.h = -1
    self.disabled = button.disabled or false
    self.active = false

    self.font = love.graphics.newFont("assets/fonts/Azonix.otf", 48)

    self:init_events(
        {
            "on_press"
        }
    )
end

function ButtonUI:draw()
    self.w = self.font:getWidth(self.text)
    self.h = self.font:getHeight(self.text)
    self.x = 0
    self.y = 0
    local canvas = love.graphics.newCanvas(self.w, self.h)
    canvas:renderTo(
        function()
            if self.disabled then
                love.graphics.setColor(20 / 255, 20 / 255, 20 / 255, 1)
            else
                if self.active then
                    love.graphics.setColor(self.r, self.g, self.b, self.a)
                else
                    love.graphics.setColor(1, 1, 1, 1)
                end
            end
            love.graphics.print(self.text, self.font, self.x, self.y)
        end
    )
    return canvas
end

function ButtonUI:on_mouse_update(x, y)
    if
        self.x <= x and x <= self.x + self.w and self.y <= y and
            y <= self.y + self.h
     then
        self.active = true
    else
        self.active = false
    end
end

function ButtonUI:on_mouse_pressed(x, y, button)
end

function ButtonUI:on_mouse_released(x, y, button)
    if button == 1 then
        if
            self.x <= x and x <= self.x + self.w and self.y <= y and
                y <= self.y + self.h
         then
            self:notify("on_press", self)
        end
    end
end

function ButtonUI:set_disabled(flag)
    self.disabled = flag
end

return ButtonUI
