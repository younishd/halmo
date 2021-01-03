--[[
--
-- Halmö
--
-- (c) 2015-2021 Younis Bensalah <younis.bensalah@gmail.com>
--
--]]

local BoardUI = class('BoardUI')

function BoardUI:initialize(board)
    assert(board and board:isInstanceOf(Board))
    self.board = board

    self.callbacks = {
        on_move = {},
        on_finish = {}
    }

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
        tile = false,
        x = 0,
        y = 0
    }
    self.saved_tiles = {}
end

function BoardUI:draw()
    local board2d = self.board:get_2d_board()
    local y = 0
    self.canvas:renderTo(function() love.graphics.clear() end)
    for i, row in pairs(board2d) do
        local row_width = #row * self.x_step - self.style.tile.margin.x
        local x = (self.width - row_width) / 2
        for j, tile in pairs(row) do
            love.graphics.setColor(1, 1, 1, 1)
            self.canvas:renderTo(function() love.graphics.draw(self.assets[self.color_map[tile.color]], x, y) end)
            self:save_tile(x, y, tile)
            x = x + self.x_step
        end
        y = y + self.y_step
    end

    if self.drag.active then
        love.graphics.setColor(1, 1, 1, 1)
        self.canvas:renderTo(function() love.graphics.draw(self.assets[self.color_map[self.drag.tile.color]], self.drag.x, self.drag.y) end)
    end

    return self.canvas
end

function BoardUI:save_tile(x, y, tile)
    if not self.saved_tiles[x] then self.saved_tiles[x] = {} end
    self.saved_tiles[x][y] = tile
end

function BoardUI:update_mouse(x, y)
    if self.drag.active then
        self.drag.x = x
        self.drag.y = y
    end
end

function BoardUI:mousepressed(x, y, button)
    if button == 1 then
        for xx, v in pairs(self.saved_tiles) do
            for yy, tile in pairs(v) do
                if BoardUI:radial_collision(xx, yy, x, y, self.style.tile.radius) then
                    log.debug("collision!")
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

        for xx, v in pairs(self.saved_tiles) do
            for yy, tile in pairs(v) do
                if BoardUI:radial_collision(xx, yy, x, y, self.style.tile.radius) then
                    log.debug("collision!")
                    self.drag.active = false
                    if self.drag.tile.x == tile.x and self.drag.tile.y == tile.y then return false end
                    self:notify_callback('on_move', self.drag.tile, tile)
                    return
                end
            end
        end
    end
end

function BoardUI.static:radial_collision(xx, yy, x, y, r)
    x = x - xx - r
    y = y - yy - r
    return x * x + y * y <= r * r
end

function BoardUI:register_callback(event, callback)
    assert(self.callbacks[event])
    table.append(self.callbacks[event], callback)
end

function BoardUI:notify_callback(event, ...)
    assert(self.callbacks[event])
    for _, f in pairs(self.callbacks[event]) do
        f(...)
    end
end

return BoardUI
