--[[
--
-- Halmö
--
-- (c) 2015-2020 Younis Bensalah <younis.bensalah@gmail.com>
--
--]]

local Engine = class('Engine')

function Engine:initialize(board, turn)
    turn = turn or 1
    assert(board and board:isInstanceOf(Board))
    assert(1 <= turn and turn <= board:get_colors())

    self.board = board
    self.turn = turn
    self.move = { src = { x=0, y=0 }, dst = { x=0, y=0 }, step = false }
    self.winner = false
end

function Engine:move(from, to)
    log.debug("move " .. from.x .. " " .. from.y .. " to " .. to.x .. " " .. to.y)
    -- TODO
end

function Engine:finish()
    if self.move.src.x == self.move.dst.x and self.move.src.y == self.move.dst.y then
        return false
    end

    if self.winner then
        return false
    end

    self.move = { src = { x=0, y=0 }, dst = { x=0, y=0 }, step = false }

    self:calculate_winner()
    if not self:get_winner() then
        self:next_turn()
    end

    return true
end

function Engine:reset()
    log.debug("resetting...")
    self.board:reset()
    self.turn = 1
    self.move = { src = { x=0, y=0 }, dst = { x=0, y=0 }, step = false }
    self.winner = false
end

function Engine:get_winner()
    return self.winner
end

function Engine:calculate_winner()
    -- TODO
end

function Engine:next_turn()
    self.turn = 1 + self.turn % self.board:get_colors()
    log.debug("turn: " .. self.turn)
end

return Engine
