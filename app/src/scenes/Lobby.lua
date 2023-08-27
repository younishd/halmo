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
            "on_join",
            "on_new"
        }
    )

    self.rooms = {}
end

function Lobby:on_enter()
    self.back_button =
        self:add(ButtonUI({text = "Back"}), 24, 24, Scene.bottom_left):on_event(
        "on_press",
        function()
            self:notify("on_back")
        end
    )
    -- TODO: start with empty room list then poll during on_update
    self.room_list = self:add(ListUI(self.rooms), 0, 0, Scene.center)
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
    self.new_button = self:add(ButtonUI({text = "New"}), self.join_button.w + 2 * 24, 24, Scene.bottom_right):on_event(
        "on_press",
        function()
            self:notify("on_new")
        end
    )
end

function Lobby:update_rooms(rooms)
    self.rooms = imap(function(v) return {text = v.name} end, rooms)
end

return Lobby
