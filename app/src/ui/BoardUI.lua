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
end

function BoardUI:draw()
    love.graphics.draw(self.assets.blue, 100, 200, 0, 1, 1, 0, 0)
end

function BoardUI:register_callback(event, callback)
    assert(self.callbacks[event])
    table.append(self.callbacks[event], callback)
end

return BoardUI
