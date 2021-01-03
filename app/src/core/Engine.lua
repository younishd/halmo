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

    local result = (function()
        from.color = self.board:get(from)
        to.color = self.board:get(to)
        if from.color ~= self.turn then return false end
        if to.color ~= 0 then return false end
        if from.x == to.x and from.y == to.y then return false end

        local direction = { x = to.x - from.x, y = to.y - from.y }
        log.debug(string.format("direction: %d %d", direction.x, direction.y))

        if direction.x ~= 0 and direction.y ~= 0 and direction.x ~= direction.y then return false end

        if self.current_move.src.x ~= self.current_move.dst.x and
                self.current_move.src.y ~= self.current_move.dst.y and
                self.current_move.dst.x ~= from.x and
                self.current_move.dst.y ~= from.y then
            return false
        end

        local distance = Board:maxnorm(direction)
        if distance == 1 and
                self.current_move.src.x == self.current_move.dst.x and
                self.current_move.src.y == self.current_move.dst.y then
            self:update_move(from, to, true)
            return true
        end

        if self.current_move.step and
                self.current_move.src.x == to.x and
                self.current_move.src.y == to.y and
                self.current_move.dst.x == from.x and
                self.current_move.dst.y == from.y then
            self:update_move(from, to, false)
            return true
        end

        if distance % 2 == 1 then return false end

        local pivot = { x = from.x + direction.x / 2, y = from.y + direction.y / 2 }
        assert(math.isint(pivot.x) and math.isint(pivot.y))
        log.debug(string.format("pivot: %d %d", pivot.x, pivot.y))
        if self.board:get(pivot) == 0 then return false end

        local gap_iter = function(from, to, direction, pivot)
            local i = map(math.sign, direction)
            local inc = function(v, n) return { x = v.x + n.x, y = v.y + n.y } end
            local v = inc({ x=0, y=0 }, from)
            return function()
                v = inc(v, i)
                if v.x == pivot.x and v.y == pivot.y then v = inc(v, i) end
                if v.x == to.x and v.y == to.y then return nil end
                return v
            end
        end
        for v in gap_iter(from, to, direction, pivot) do
            if self.board:get(v) ~= 0 then return false end
        end

        self:update_move(from, to, false)
        return true
    end)()

    if not result then
        log.warn(string.format("invalid move %d %d to %d %d", from.x, from.y, to.x, to.y))
        return false
    end
    log.info(string.format("move %d %d to %d %d", from.x, from.y, to.x, to.y))
    self.board:remove(from)
    self.board:place(to, self.turn)
    return true
end

function Engine:update_move(from, to, step)
    if self.current_move.src.x == self.current_move.dst.x and
            self.current_move.src.y == self.current_move.dst.y then
        self.current_move.src.x = from.x
        self.current_move.src.y = from.y
    end
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
