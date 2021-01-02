--[[
--
-- Halmö
--
-- (c) 2015-2021 Younis Bensalah <younis.bensalah@gmail.com>
--
--]]

local Board = class('Board')

function Board:initialize(colors, edge)
    colors = colors or 2
    edge = edge or 4

    assert(2 <= colors and colors <= 6)
    assert(2 <= edge)

    self.matrix = {}
    self.colors = colors
    self.edge = edge

    if colors == 2 then
        self.pov = { [1] = 0, [2] = 3 }
    elseif colors == 3 then
        self.pov = { [1] = 0, [2] = 2, [3] = 4 }
    elseif colors == 4 then
        self.pov = { [1] = 0, [2] = 1, [3] = 3, [4] = 4 }
    elseif colors == 5 then
        self.pov = { [1] = 0, [2] = 1, [3] = 2, [4] = 3, [5] = 4 }
    elseif colors == 6 then
        self.pov = { [1] = 0, [2] = 1, [3] = 2, [4] = 3, [5] = 4, [6] = 5 }
    end

    self:generate()
end

function Board:get_2d_board()
    t = {}
    for _, j in kpairs(self.matrix) do
        row = {}
        for _, i in kpairs(j) do
            table.append(row, i)
        end
        table.append(t, row)
    end
    return t
end

function Board:as(pos, color)
    assert(pos.x and pos.y)
    assert(1 <= color and color <= self.colors)

    return times(partial(Board.rotate, Board), self.pov[color], pos)
end

function Board:remove(pos)
    assert(pos.x and pos.y)
    assert(self.matrix[pos.y][pos.x])

    self.matrix[pos.y][pos.x] = 0
end

function Board:place(pos, color)
    assert(pos.x and pos.y)
    assert(1 <= color and color <= self.colors)
    assert(self.matrix[pos.y][pos.x])

    self.matrix[pos.y][pos.x] = color
end

function Board:get(pos)
    assert(pos.x and pos.y)
    if self.matrix[pos.y] then
        return self.matrix[pos.y][pos.x]
    end
end

function Board:get_colors()
    return self.colors
end

function Board:reset()
    self.matrix = {}
    self:generate()
end

function Board:generate()
    log.debug("generating board...")

    local set = function(pos, color)
        if not self.matrix[pos.y] then self.matrix[pos.y] = {} end
        self.matrix[pos.y][pos.x] = color
    end

    set({ x=0, y=0 }, 0)
    for i=1, self.edge do
        for j=1, i do
            for k=0, 5 do set(times(partial(Board.rotate, Board), k, { x=i, y=j }), 0) end
            for k=0, 5 do set(times(partial(Board.rotate, Board), k, { x=i, y=j+self.edge }), 0) end
            for k=1, self.colors do set(self:as({ x=i, y=j+self.edge }, k), k) end
        end
    end
end

function Board.static:rotate(pos)
    return {
        x = pos.x - pos.y,
        y = pos.x
    }
end

function Board.static:maxnorm(pos)
    return math.abs(math.max(pos.x, pos.y))
end

function Board.static:dist(a, b)
    return self:maxnorm({ x = b.x - a.x, y = b.y - a.y })
end

return Board
