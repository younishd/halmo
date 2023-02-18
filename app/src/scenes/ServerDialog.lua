--[[
--
-- Halmö
--
-- (c) 2015-2023 Younis Bensalah <younis.bensalah@gmail.com>
--
--]]
local ServerDialog = class("ServerDialog", Scene)

function ServerDialog:initialize(...)
    Scene.initialize(self, ...)

    self:init_events(
        {
            "on_connect",
            "on_back"
        }
    )
end

function ServerDialog:on_enter()
    self.back_button =
        self:add(ButtonUI({text = "Back"}), 24, 24, Scene.bottom_left):on_event(
        "on_press",
        function()
            self:notify("on_back")
        end
    )
    self.connect_button =
        self:add(ButtonUI({text = "Connect"}), 24, 24, Scene.bottom_right):on_event(
        "on_press",
        function()
            self:notify("on_connect") -- TODO: pass text as argument
        end
    )
    --self.server_input = self:add(TextInput({text = "Server..."}), 0, 0, Scene.center)
end

return ServerDialog
