local function generate(edge)
    local function _generate(i, j, k, l)
        local function __generate(i, j, k, l)
            if i > j then return k end

            k[#k+1] = {}
            for _=1, math.abs(i) do
                k[#k][#(k[#k])+1] = l[1]
                l[1] = l[1] + 1
            end

            return __generate(i+1, j, k, l)
        end

        k = k or {}
        l = {l or 1}

        if i > j then
            return __generate(-i, -j, k, l)
        end
        return __generate(i, j, k, l)
    end

    edge = edge or 4

    local board = _generate(1, edge)
    _generate(edge*3+1, edge*2+1, board, board[#board][#board[#board]]+1)
    _generate(edge*2+2, edge*3+1, board, board[#board][#board[#board]]+1)
    _generate(edge, 1, board, board[#board][#board[#board]]+1)

    return board
end

return generate
