--[[
--
-- Halmö
--
-- (c) 2015-2023 Younis Bensalah <younis.bensalah@gmail.com>
--
--]]
local TextBoxUI = class("TextBoxUI", Drawable)

function TextBoxUI:initialize(v)
    assert(v and v.text)
    self.text = v.text
    self.r, self.g, self.b, self.a = 1, 1, 1, 1
    self.x, self.y = -1, -1
    self.w, self.h = -1, -1
    self.disabled = false
    self.active = false
    self.font = love.graphics.newFont("assets/fonts/Azonix.otf", 24)
end

function TextBoxUI:get_text()
    return self.text
end

function TextBoxUI:draw()
    self.w = math.max(self.font:getWidth(self.text), 10)
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

function TextBoxUI:on_text_input(t)
    self.text = self.text .. t
end

function TextBoxUI:on_key_pressed(key)
    if key == "backspace" then
        local byteoffset = utf8.offset(self.text, -1)
        if byteoffset then
            self.text = string.sub(self.text, 1, byteoffset - 1)
        end
    end
end

function TextBoxUI:on_mouse_update(x, y)
end

function TextBoxUI:on_mouse_pressed(x, y, button)
end

function TextBoxUI:on_mouse_released(x, y, button)
end

return TextBoxUI
