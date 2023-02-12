--[[
--
-- Halmö
--
-- (c) 2015-2023 Younis Bensalah <younis.bensalah@gmail.com>
--
--]]
local MenuUI = class("MenuUI", Drawable)

function MenuUI:initialize(items)
    assert(items and next(items))

    self.items = items

    -- set defaults
    for _, v in ipairs(self.items) do
        v.r, v.g, v.b, v.a = 1, 1, 1, 1
        v.x, v.y, v.w, v.h = -1, -1, -1, -1
        v.active = true
    end

    self.font = love.graphics.newFont("assets/fonts/Azonix.otf", 48)

    self:init_events(
        {
            "on_select"
        }
    )
end

function MenuUI:draw()
    local max_width = 0
    local y_offset = 0
    for _, v in ipairs(self.items) do
        local width = self.font:getWidth(v.text)
        local height = self.font:getHeight(v.text)
        v.w = width
        v.h = height
        v.x = 0
        v.y = y_offset
        if max_width < width then
            max_width = width
        end
        y_offset = y_offset + height
    end

    local canvas = love.graphics.newCanvas(max_width, y_offset)
    for _, v in ipairs(self.items) do
        canvas:renderTo(
            function()
                love.graphics.push()
                if v.active then
                    love.graphics.setColor(160 / 255, 224 / 255, 63 / 255, 1)
                else
                    love.graphics.setColor(1, 1, 1, 1)
                end
                love.graphics.print(v.text, self.font, v.x, v.y)
                love.graphics.pop()
            end
        )
        love.graphics.setColor(1, 1, 1, 1)
    end
    return canvas
end

function MenuUI:on_mouse_update(x, y)
    for _, v in ipairs(self.items) do
        if v.x <= x and x <= v.x + v.w and v.y <= y and y <= v.y + v.h then
            v.active = true
        else
            v.active = false
        end
    end
end

function MenuUI:on_mouse_pressed(x, y, button)
end

function MenuUI:on_mouse_released(x, y, button)
    if button == 1 then
        for _, v in ipairs(self.items) do
            if v.x <= x and x <= v.x + v.w and v.y <= y and y <= v.y + v.h then
                self:notify("on_select", v.id)
            end
        end
    end
end

return MenuUI
