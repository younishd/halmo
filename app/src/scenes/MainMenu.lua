----
---
-- Halmö
--
-- (c) 2015-2023 Younis Bensalah <younis.bensalah@gmail.com>
---
----
local MainMenu = class("MainMenu", Scene)

function MainMenu:initialize(ver, ...)
    Scene.initialize(self, ...)

    self:init_events(
        {
            "on_play",
            "on_quit"
        }
    )

    self.version = ver
end

function MainMenu:on_enter()
    self:add(
        MenuUI(
            {
                {id = "play", text = "Play"},
                {id = "quit", text = "Quit"}
            }
        ),
        0,
        0,
        Scene.center
    ):on_event("on_select", partial(self.on_select, self))

    self:add(LabelUI({text = "Halmö", size = 80}), 0, 80, Scene.center_h)
    self:add(LabelUI({text = self.version}), 8, 8, Scene.bottom_right)
end

function MainMenu:on_select(id)
    if id == "play" then
        self:notify("on_play")
    elseif id == "quit" then
        self:notify("on_quit")
    end
end

return MainMenu
