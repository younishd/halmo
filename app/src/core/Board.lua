----
---
-- Halmö
--
-- (c) 2015-2023 Younis Bensalah <younis.bensalah@gmail.com>
---
----
local Board = class('Board')

Board:include(mixins.hooks)

function Board:initialize(colors, edge)
    colors = colors or 2
    edge = edge or 4

    assert(2 <= colors and colors <= 6)
    assert(2 <= edge)

    self.matrix = {}
    self.colors = colors
    self.edge = edge

    self:init_events({
        'on_update'
    })

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

function Board:get_matrix(as)
    assert(1 <= as and as <= self.colors)

    local rot = function(pos) return times(partial(Board.rotate, Board), - self.pov[as] % 6, pos) end

    local rotated_matrix = {}
    for i, v in pairs(self.matrix) do
        for j, w in pairs(v) do
            local pos = rot({ x=j, y=i })
            if not rotated_matrix[pos.y] then rotated_matrix[pos.y] = {} end
            rotated_matrix[pos.y][pos.x] = { x=j, y=i, color=w }
        end
    end

    local final_matrix = {}
    for i, v in kpairs(rotated_matrix) do
        local r = {}
        for j, w in kpairs(v) do
            table.append(r, w)
        end
        table.append(final_matrix, r)
    end
    return final_matrix
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

    self:notify('on_update')
end

function Board:place(pos, color)
    assert(pos.x and pos.y)
    assert(1 <= color and color <= self.colors)
    assert(self.matrix[pos.y][pos.x])

    self.matrix[pos.y][pos.x] = color

    self:notify('on_update')
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

    self:notify('on_update')
end

function Board:generate()
    log.info(string.format("generating %d,%d-board...", self.edge, self.colors))

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
    return math.max(math.abs(pos.x), math.abs(pos.y))
end

function Board.static:dist(a, b)
    return self:maxnorm({ x = b.x - a.x, y = b.y - a.y })
end

return Board
