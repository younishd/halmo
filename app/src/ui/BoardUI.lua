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
            }
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
        [3] = 'magenta',
        [4] = 'yellow',
        [5] = 'white',
        [6] = 'red'
    }
end

function BoardUI:draw()
    local board2d = self.board:get_2d_board()
    local y = 0
    self.canvas:renderTo(function() love.graphics.clear() end)
    for _, row in pairs(board2d) do
        local row_width = #row * self.x_step - self.style.tile.margin.x
        local x = (self.width - row_width) / 2
        for _, col in pairs(row) do
            love.graphics.setColor(1, 1, 1, 1)
            self.canvas:renderTo(function() love.graphics.draw(self.assets[self.color_map[col]], x, y) end)
            x = x + self.x_step
        end
        y = y + self.y_step
    end
    return self.canvas
end

function BoardUI:register_callback(event, callback)
    assert(self.callbacks[event])
    table.append(self.callbacks[event], callback)
end

return BoardUI
