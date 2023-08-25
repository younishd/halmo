----
---
-- Halmö
--
-- (c) 2015-2023 Younis Bensalah <younis.bensalah@gmail.com>
---
----
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

    self.finish_button =
        self:add(ButtonUI({text = "Finish", disabled = true}), 24, 24, Scene.bottom_right):on_event(
            "on_press",
            partial(self.engine.finish, self.engine)
    )

    self.quit_button =
        self:add(ButtonUI({text = "Quit"}), 24, 24, Scene.bottom_left):on_event(
        "on_press",
        function()
        self:notify("on_quit")
        end
    )

    -- relay moves from ui to engine
    local board_ui =
        self:add(BoardUI(self.board, player_pov), 0, 0, Scene.center):on_event(
        "on_move",
        partial(self.engine.move, self.engine)):on_event(
        "on_finish",
        partial(self.engine.finish, self.engine)
    )

    -- update ui when board state changes
    self.board:on_event("on_update", partial(board_ui.update, board_ui))
end

function InGame:update(dt)
    self.finish_button:set_disabled(not self.engine:is_finishable())
end

return InGame
