--[[
--
-- Halmö
--
-- (c) 2015-2021 Younis Bensalah <younis.bensalah@gmail.com>
--
--]]

local Engine = class('Engine')

function Engine:initialize(board, turn)
    turn = turn or 1
    assert(board and board:isInstanceOf(Board))
    assert(1 <= turn and turn <= board:get_colors())

    self.board = board
    self.turn = turn
    self.current_move = { src = { x=0, y=0 }, dst = { x=0, y=0 }, step = false }
    self.winner = false
end

function Engine:move(from, to)
    assert(from.x and from.y and to.x and to.y)

    log.debug("move " .. from.x .. " " .. from.y .. " to " .. to.x .. " " .. to.y)

    local color = self.board:get(from)
    if color ~= self.turn then return false end
    if from.x == to.x and from.y == to.y then return false end

    if self.current_move.src.x ~= self.current_move.dst.x and
            self.current_move.src.x ~= self.current_move.dst.x and
            self.current_move.dst.x ~= from.x and
            self.current_move.dst.y ~= from.y then
        return false
    end

    if Board:dist(from, to) == 1 and
            self.current_move.src.x == self.current_move.dst.x and
            self.current_move.src.y == self.current_move.dst.y then
        self.board:remove(from)
        self.board:place(to, color)
        self.update_move(from, to, true)
        return true
    end

    if self.current_move.step and
            self.current_move.src.x == to.x and
            self.current_move.src.y == to.y and
            self.current_move.dst.x == from.x and
            self.current_move.dst.x == from.y then
        self.board:remove(from)
        self.board:place(to, color)
        self.update_move(from, to, false)
        return true
    end

    local direction = { x = to.x - from.x, y = to.y - from.y }
    if direction.x ~= 0 and direction.y ~= 0 and direction.x ~= direction.y then
        return false
    end
    if Board:maxnorm(direction) % 2 == 1 then
        return false
    end

    
end

function Engine:update_move(from, to, step)
    step = step or false
    self.current_move.src.x = from.x
    self.current_move.src.y = from.y
    self.current_move.dst.x = to.x
    self.current_move.dst.y = to.y
    self.current_move.step = step
end

function Engine:finish()
    if self.current_move.src.x == self.current_move.dst.x and self.current_move.src.y == self.current_move.dst.y then
        return false
    end

    if self.winner then
        return false
    end

    self.current_move = { src = { x=0, y=0 }, dst = { x=0, y=0 }, step = false }

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
    self.current_move = { src = { x=0, y=0 }, dst = { x=0, y=0 }, step = false }
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
