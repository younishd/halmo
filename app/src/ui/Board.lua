--[[
--
-- Halmö
--
-- (c) 2015-2020 Younis Bensalah <younis.bensalah@gmail.com>
--
--]]

local Board = class('Board')

function Board:initialize()
    self.callbacks = {
        on_move = {},
        on_finish = {}
    }
end

function Board:register_callback(event, callback)
    assert(self.callbacks[event] ~= nil)
    table.append(self.callbacks[event], callback)
end

return Board
