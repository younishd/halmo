----
---
-- Halmö
--
-- (c) 2015-2023 Younis Bensalah <younis.bensalah@gmail.com>
---
----
local Game = class("Game")

function Game:initialize()
    -- TODO: hard-coded values
    self.width = 1280
    self.height = 800
    self.number_players = 3
    self.player_pov = 1

    self.scenes = {
        main_menu = MainMenu(self.height, self.width),
        server_dialog = ServerDialog(self.height, self.width),
        in_game = InGame(self.height, self.width),
        lobby = Lobby(self.height, self.width)
    }

    self.scenes.main_menu:on_event("on_play", self:transition(self.scenes.server_dialog)):on_event("on_quit", partial(
        self.on_quit, self))

    self.scenes.server_dialog:on_event("on_connect", partial(self.on_connect, self)):on_event("on_back",
        self:transition(self.scenes.main_menu))

    self.scenes.in_game:on_event("on_quit", self:transition(self.scenes.main_menu))

    self.active_scene = self.scenes.main_menu
    self.active_scene:on_enter()
end

function Game:transition(next_scene, ...)
    assert(next_scene:isInstanceOf(Scene))
    local argv = {...}
    return function()
        self.active_scene:on_leave()
        self.active_scene = next_scene
        self.active_scene:on_enter(unpack(argv))
    end
end

function Game:load()
    log.info("loading game...")

    love.window.setMode(self.width, self.height)
    love.window.setTitle("Halmö (" .. version() .. ")")

    love.keyboard.setKeyRepeat(true)
end

function Game:update(dt)
    local x, y = love.mouse.getPosition()
    self.active_scene:on_mouse_update(x, y)
    self.active_scene:update(dt)
end

function Game:draw()
    self.active_scene:draw()
end

function Game:on_text_input(t)
    self.active_scene:on_text_input(t)
end

function Game:on_key_pressed(key)
    self.active_scene:on_key_pressed(key)
end

function Game:on_mouse_pressed(x, y, button)
    if button == 1 or button == "l" then
        self.active_scene:on_mouse_pressed(x, y, 1)
    elseif button == 2 or button == "r" then
        self.active_scene:on_mouse_pressed(x, y, 2)
    end
end

function Game:on_mouse_released(x, y, button)
    if button == 1 or button == "l" then
        self.active_scene:on_mouse_released(x, y, 1)
    elseif button == 2 or button == "r" then
        self.active_scene:on_mouse_released(x, y, 2)
    end
end

function Game:quit()
    log.info("bye!")
    return false
end

function Game:on_quit()
    love.event.quit()
end

function Game:on_connect(host, port)
    log.info("connecting...")
    self.connection = Connection(host, port)
    -- TODO: check connection status etc.
    self:transition(self.scenes.lobby)
end

function Game:on_join()
    self:transition(self.scenes.in_game, self.number_players, self.player_pov)()
end

return Game
