--[[
--
-- Halmö
--
-- (c) 2015-2021 Younis Bensalah <younis.bensalah@gmail.com>
--
--]]

local BoardUI = class('BoardUI')

BoardUI:include(mixins.hooks)

function BoardUI:initialize(board)
    assert(board and board:isInstanceOf(Board))
    self.board = board
    self.matrix = board:get_matrix(1)

    self:init_hooks({
        'on_move',
        'on_finish'
    })

    self.assets = {
        blue = love.graphics.newImage('assets/blue.png'),
        empty = love.graphics.newImage('assets/empty.png'),
        green = love.graphics.newImage('assets/green.png'),
        purple = love.graphics.newImage('assets/purple.png'),
        red = love.graphics.newImage('assets/red.png'),
        white = love.graphics.newImage('assets/white.png'),
        yellow = love.graphics.newImage('assets/yellow.png')
    }

    self.style = {
        tile = {
            width = 44,
            height = 44,
            margin = {
                x = 6,
                y = 0
            },
            radius = 22
        }
    }

    self.x_step = self.style.tile.width + self.style.tile.margin.x
    self.y_step = self.style.tile.height + self.style.tile.margin.y
    self.width = (3 * self.board.edge + 1) * self.x_step - self.style.tile.margin.x
    self.height = (4 * self.board.edge + 1) * self.y_step - self.style.tile.margin.y
    self.canvas = love.graphics.newCanvas(self.width, self.height)
    self.dirty = true

    self.color_map = {
        [0] = 'empty',
        [1] = 'green',
        [2] = 'blue',
        [3] = 'purple',
        [4] = 'yellow',
        [5] = 'white',
        [6] = 'red'
    }

    self.drag = {
        active = false,
        tile = {},
        x = 0,
        y = 0
    }
end

function BoardUI:update()
    self.matrix = self.board:get_matrix(1)
    self.dirty = true
end

function BoardUI:draw()
    if not self.dirty then return self.canvas end

    self:clear()

    local y = 0
    for i, row in pairs(self.matrix) do
        local row_width = #row * self.x_step - self.style.tile.margin.x
        local x = (self.width - row_width) / 2
        for j, tile in pairs(row) do
            if self.drag.active and
                    self.drag.tile.x == tile.x and
                    self.drag.tile.y == tile.y then
                self:draw_tile(x, y, 0)
            else
                self:draw_tile(x, y, tile.color)
            end
            self.matrix[i][j].draw_x = x
            self.matrix[i][j].draw_y = y
            if self.drag.active then
                self:draw_tile(
                        self.drag.x - self.style.tile.radius,
                        self.drag.y - self.style.tile.radius,
                        self.drag.tile.color)
            end
            x = x + self.x_step
        end
        y = y + self.y_step
    end

    self.dirty = false
    return self.canvas
end

function BoardUI:draw_tile(x, y, color)
    love.graphics.setColor(1, 1, 1, 1)
    self.canvas:renderTo(function() love.graphics.draw(self.assets[self.color_map[color]], x, y) end)
end

function BoardUI:clear()
    self.canvas:renderTo(function() love.graphics.clear() end)
end

function BoardUI:update_mouse(x, y)
    if self.drag.active then
        self.dirty = true
        self.drag.x = x
        self.drag.y = y
    end
end

function BoardUI:mousepressed(x, y, button)
    if button == 1 then
        for i, row in pairs(self.matrix) do
            for j, tile in pairs(row) do
                if tile.color ~= 0 and
                        BoardUI:radial_collision(tile.draw_x, tile.draw_y, x, y, self.style.tile.radius) then
                    self.dirty = true
                    self.drag.active = true
                    self.drag.tile = tile
                    self.drag.x = x
                    self.drag.y = y
                    return
                end
            end
        end
    end
end

function BoardUI:mousereleased(x, y, button)
    if button == 1 then
        if not self.drag.active then return end
        for i, row in pairs(self.matrix) do
            for j, tile in pairs(row) do
                if BoardUI:radial_collision(tile.draw_x, tile.draw_y, x, y, self.style.tile.radius) then
                    self.dirty = true
                    self.drag.active = false
                    if self.drag.tile.x == tile.x and self.drag.tile.y == tile.y then return false end
                    self:notify_hooks('on_move', self.drag.tile, tile)
                    return
                end
            end
        end
    end
end

function BoardUI.static:radial_collision(mouse_x, mouse_y, x, y, r)
    x = x - mouse_x - r
    y = y - mouse_y - r
    return x * x + y * y <= r * r
end

return BoardUI
