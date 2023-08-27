----
---
-- Halmö
--
-- (c) 2015-2023 Younis Bensalah <younis.bensalah@gmail.com>
---
----
local LabelUI = class("LabelUI", Drawable)

function LabelUI:initialize(v)
    assert(v and v.text)
    self.text = v.text
    self.font = love.graphics.newFont("assets/fonts/Quicksand.otf", 24)
    self.r, self.g, self.b, self.a = 1, 1, 1, 1
    self.x = 0
    self.y = 0
    self.w = math.max(self.font:getWidth(self.text), 10)
    self.h = self.font:getHeight(self.text)
    self.disabled = false
end

function LabelUI:get_text()
    return self.text
end

function LabelUI:draw()
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
                love.graphics.setColor(1, 1, 1, 1)
            end
            love.graphics.print(self.text, self.font, self.x, self.y)
        end
    )
    return canvas
end

return LabelUI
