----
---
-- Halmö
--
-- (c) 2015-2023 Younis Bensalah <younis.bensalah@gmail.com>
---
----
local NewRoom = class("NewRoom", Scene)

function NewRoom:initialize(...)
    Scene.initialize(self, ...)

    self:init_events(
        {
            "on_back",
            "on_create"
        }
    )
end

function NewRoom:on_enter()
    self.back_button =
        self:add(ButtonUI({text = "Back"}), 24, 24, Scene.bottom_left):on_event(
        "on_press",
        function()
            self:notify("on_back")
        end
    )
    self.player_options = self:add(ListUI({{text = "2 players"}, {text = "3 players"}, {text = "4 players"}, {text = "5 players"}, {text = "6 players"}}), 0, 0, Scene.center)
    self.create_button =
        self:add(ButtonUI({text = "Create"}), 24, 24, Scene.bottom_right):on_event(
        "on_press",
        function()
            local option = self.player_options:get_selected_item()
            if option ~= nil then
                local number_players = 0
                if option.text:sub(1, 1) == "2" then number_players = 2
                elseif option.text:sub(1, 1) == "3" then number_players = 3
                elseif option.text:sub(1, 1) == "4" then number_players = 4
                elseif option.text:sub(1, 1) == "5" then number_players = 5
                elseif option.text:sub(1, 1) == "6" then number_players = 6
                end
                assert(number_players ~= 0)
                self:notify("on_create", number_players)
            end
        end
    )
end

return NewRoom
