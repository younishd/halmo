----
---
-- Halmö
--
-- (c) 2015-2023 Younis Bensalah <younis.bensalah@gmail.com>
---
----
local ListUI = class("ListUI", Drawable)

function ListUI:initialize(items)
    assert(items)

    self.items = items
    self.selected = math.min(1, #items)

    -- set defaults
    for _, v in ipairs(self.items) do
        v.x, v.y, v.w, v.h = -1, -1, -1, -1
    end

    self.font = love.graphics.newFont("assets/fonts/Azonix.otf", 48)
end

function ListUI:draw()
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

    -- reset if out of bounds
    if #self.items < self.selected then
        self.selected = 1
    end

    local canvas = love.graphics.newCanvas(max_width, y_offset)
    for i, v in ipairs(self.items) do
        canvas:renderTo(
            function()
                if i == self.selected then
                    love.graphics.setColor(160 / 255, 224 / 255, 63 / 255, 1)
                else
                    love.graphics.setColor(1, 1, 1, 1)
                end
                love.graphics.print(v.text, self.font, v.x, v.y)
            end
        )
    end
    return canvas
end

function ListUI:get_selected_item()
    if #self.items == 0 then
        return nil
    end

    -- reset if out of bounds
    if #self.items < self.selected then
        self.selected = 1
    end

    return self.items[self.selected]
end

function ListUI:on_mouse_released(x, y, button)
    if button == 1 then
        for i, v in ipairs(self.items) do
            if v.x <= x and x <= v.x + v.w and v.y <= y and y <= v.y + v.h then
                self.selected = i
            end
        end
    end
end

return ListUI
