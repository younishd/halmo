--[[
--
-- Halmö
--
-- (c) 2015-2023 Younis Bensalah <younis.bensalah@gmail.com>
--
--]]
local InGame = class("InGame", Scene)

function InGame:initialize(...)
    Scene.initialize(self, ...)

    self:init_events(
        {
            "on_quit"
        }
    )
end

function InGame:on_enter(number_players, player_pov)
    self.board = Board(number_players)
    self.engine = Engine(self.board)

    local finish_button_ui = self:add(ButtonUI({text = "Finish", disabled = true}), 24, 24, Scene.bottom_right)

    -- relay moves from ui to engine
    local board_ui =
        self:add(BoardUI(self.board, player_pov), 0, 0, Scene.center):on_event(
        "on_move",
        partial(self.engine.move, self.engine)
    ):on_event("on_move", partial(finish_button_ui.set_disabled, finish_button_ui, not self.engine:is_finishable())):on_event(
        "on_finish",
        partial(self.engine.finish, self.engine)
    )

    -- update ui when board state changes
    self.board:on_event("on_update", partial(board_ui.update, board_ui))
end

return InGame
