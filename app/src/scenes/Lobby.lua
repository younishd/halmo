----
---
-- Halmö
--
-- (c) 2015-2023 Younis Bensalah <younis.bensalah@gmail.com>
---
----
local Lobby = class("Lobby", Scene)

function Lobby:initialize(...)
    Scene.initialize(self, ...)

    self:init_events(
        {
            "on_back",
            "on_join"
        }
    )
end

function Lobby:on_enter()
    self.back_button =
        self:add(ButtonUI({text = "Back"}), 24, 24, Scene.bottom_left):on_event(
        "on_press",
        function()
            self:notify("on_back")
        end
    )
    --self.server_input = self:add(TextBoxUI({text = "localhost:33333"}), 0, 0, Scene.center)
    -- TODO
    self.room_list = self:add(ListUI({{text = "room 1"}, {text = "room 2"}, {text = "room 3"}}), 0, 0, Scene.center)
    self.join_button =
        self:add(ButtonUI({text = "Join"}), 24, 24, Scene.bottom_right):on_event(
        "on_press",
        function()
            local room = self.room_list:get_selected_item()
            if room ~= nil then
                self:notify("on_join", room.text)
            end
        end
    )
end

return Lobby
