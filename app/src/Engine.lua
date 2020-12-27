--[[
--
-- Halmö
--
-- (c) 2015-2020 Younis Bensalah <younis.bensalah@gmail.com>
--
--]]

local Engine = class('Engine')

function Engine:initialize(board, turn)
    assert(board:isInstanceOf(Board))

    self.board = board
    self.turn = turn or 1
    self.move = {
        source = 0,
        target = 0,
        simple = false
    }
    self.winner = false
end

function Engine:move(from, to)
end

function Engine:finish()
    if self.move.source == self.move.target then
        return false
    end

    if self.winner then
        return false
    end

    self.move.source = 0
    self.move.target = 0
    self.move.simple = false

    self:calculate_winner()
    self:get_winner() or self:next_turn()

    return true
end

function Engine:reset()
    self.board:reset()
    self.turn = 1
    self.move = {
        source = 0,
        target = 0,
        simple = false
    }
    self.winner = false
end

function Engine:get_winner()
    return self.winner
end

function Engine:calculate_winner()
end

function Engine:next_turn()
end






---


-- TODO reset is done by board
function Engine:reset_board()
    for i, player in pairs(self.players) do
        for j, target in pairs(player:get_targets()) do
            local color = target:get_color()
            for k, tile in pairs(target:get_home()) do
                self.board:place(tile, color)
            end
        end
    end
end

-- TODO get rid of player - use colors only (i.e. numbers 1-6)
function Engine:move(from, to)
    local marble = self.board:get_color_by_pos(from)

    if from == to then
        return false
    end
    if not self:__get_current_player():has_color(marble) then
        return false
    end

    if self.move.source ~= self.move.target
            and self.move.target ~= from then
        return false
    end

    if self.move.source == self.move.target then
        local src_vec = Board:pos_to_xyz(from)
        local tar_vec = Board:pos_to_xyz(to)
        local delta = {
            x = tar_vec.x - src_vec.x,
            y = tar_vec.y - src_vec.y,
            z = tar_vec.z - src_vec.z
        }

        if math.abs(delta.x) + math.abs(delta.y) + math.abs(delta.z) == 2 then
            if not self:save_to_board(from, to, marble) then return false end
            self:update_current_move(from, to, true)
            return true
        end
    end

    if self.move.simple
            and from == self.move.target
            and to == self.move.source then
        if not self:save_to_board(from, to, marble) then
            return false
        end
        self:update_current_move(from, to, false)
        return true
    end

    local src_vec = Board:pos_to_xyz(from)
    local tar_vec = Board:pos_to_xyz(to)
    local jump_dir
    local pivot_dir

    if src_vec.x == tar_vec.x then
        jump_dir = 'x'
        pivot_dir = 'y'
    elseif src_vec.y == tar_vec.y then
        jump_dir = 'y'
        pivot_dir = 'x'
    elseif src_vec.z == tar_vec.z then
        jump_dir = 'z'
        pivot_dir = 'y'
    else
        return false
    end

    delta = math.abs(src_vec[pivot_dir] - tar_vec[pivot_dir])
    if delta % 2 == 1 then
        return false
    end

    local upordown = src_vec[pivot_dir] > tar_vec[pivot_dir] and -1 or 1

    local center_xyz = {}
    center_xyz[jump_dir] = src_vec[jump_dir]
    center_xyz[pivot_dir] = (src_vec[pivot_dir] + tar_vec[pivot_dir]) / 2
    local center = Board:xyz_to_pos(center_xyz)

    if self.board:get_color_by_pos(center) == Board.MARBLES.empty then
        return false
    end

    for j = src_vec[pivot_dir] + upordown, center_xyz[pivot_dir] - upordown, upordown do
        local intersection_xyz = {}
        intersection_xyz[jump_dir] = src_vec[jump_dir]
        intersection_xyz[pivot_dir] = j
        local intersection = Board:xyz_to_pos(intersection_xyz)
        if self.board:get_color_by_pos(intersection) ~= Board.MARBLES.empty then
            return false
        end
    end
    for j = center_xyz[pivot_dir] + upordown, tar_vec[pivot_dir], upordown do
        local intersection_xyz = {}
        intersection_xyz[jump_dir] = src_vec[jump_dir]
        intersection_xyz[pivot_dir] = j
        local intersection = Board:xyz_to_pos(intersection_xyz)
        if self.board:get_color_by_pos(intersection) ~= Board.MARBLES.empty then
            return false
        end
    end

    if not self:save_to_board(from, to, marble) then
        return false
    end

    self:update_current_move(from, to, false)

    return true
end

function Engine:finish()
    if self.move.source == self.move.target then
        return false
    end

    if self.winner then
        return false
    end

    self.move.source = 0
    self.move.target = 0
    self.move.simple = false

    self:look_for_win()
    self:next_turn()

    return true
end

function Engine:get_winner()
    if self.winner then
        return self.winner
    else
        return false
    end
end

function Engine:look_for_win()
    for i, player in pairs(self.players) do
        local win = true
        for j, target in pairs(player:get_targets()) do
            local target_color = target:get_color()
            for k, tile in pairs(target:get_away()) do
                local actual_color = self.board:get_color_by_pos(tile)
                if actual_color ~= target_color then
                    win = false
                    break
                end
            end
            if not win then break end
        end
        if win then
            self.winner = self.current_player_id
            return true
        end
    end
    return false
end

function Engine:next_turn()
    self.current_player_id = self.current_player_id % self.number_of_players + 1
end

function Engine:update_current_move(from, to, simple_move_flag)
    if self.move.source == self.move.target then
        self.move.source = from
    end
    self.move.target = to
    self.move.simple = simple_move_flag
end

function Engine:save_to_board(from, to, marble)
    if not self.board:remove(from) then
        return false
    end
    if not self.board:place(to, marble) then
        return false
    end
    return true
end

return Engine
