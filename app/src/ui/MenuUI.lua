--[[
--
-- Halmö
--
-- (c) 2015-2023 Younis Bensalah <younis.bensalah@gmail.com>
--
--]]

local MenuUI = class("MenuUI")

MenuUI:include(mixins.hooks)

function MenuUI:initialize(items)
    assert(items and #items > 0)

    self.items = items

    self.font = love.graphics.newFont("assets/fonts/Azonix.otf", 48)

    self:init_hooks({
        "on_select"
    })

    self.entries = {}
end

function MenuUI:draw()
    self.entries = {}
    local max_width = 0
    local y_offset = 0
    for _, text in ipairs(self.items) do
        local width = self.font:getWidth(text)
        local height = self.font:getHeight(text)
        table.append(self.entries, {text = text, width = width, height = height, y = y_offset})
        if max_width < width then
            max_width = width
        end
        y_offset = y_offset + height
    end

    local canvas = love.graphics.newCanvas(max_width, y_offset)
    for _, v in ipairs(self.entries) do
        canvas:renderTo(function() love.graphics.print(v.text, self.font, 0, v.y) end)
    end
    return canvas
end

function MenuUI:update_mouse(x, y)
end

function MenuUI:mouse_pressed(x, y, button)
end

function MenuUI:mouse_released(x, y, button)
end

return MenuUI
