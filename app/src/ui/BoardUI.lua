--[[
--
-- Halmö
--
-- (c) 2015-2020 Younis Bensalah <younis.bensalah@gmail.com>
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
    local x_increment = self.style.tile.width + self.style.tile.margin.x
    local y_increment = self.style.tile.height + self.style.tile.margin.y
    local row_height = (4 * self.board.edge + 1) * y_increment - self.style.tile.margin.y
    local y = (800 - row_height) / 2
    log.debug("x_increment: " .. x_increment)
    log.debug("y_increment: " .. y_increment)
    log.debug("row_height: " .. row_height)
    log.debug("y: " .. y)
    for _, row in pairs(board2d) do
        local row_width = #row * x_increment - self.style.tile.margin.x
        local x = (1024 - row_width) / 2
        log.debug("row_width: " .. row_width)
        log.debug("x: " .. x)
        for _, col in pairs(row) do
            love.graphics.draw(self.assets[self.color_map[col]], x, y, 0, 1, 1, 0, 0)
            x = x + x_increment
        end
        y = y + y_increment
    end
end

function BoardUI:draw_row(row)
    -- TODO: return drawable

end

function BoardUI:register_callback(event, callback)
    assert(self.callbacks[event])
    table.append(self.callbacks[event], callback)
end

return BoardUI
