--[[
--
-- Halmö
--
-- (c) 2015-2020 Younis Bensalah <younis.bensalah@gmail.com>
--
--]]

package.path = require 'path'
version = require 'version'
class = require 'middleclass.middleclass'
log = require 'helpers.log'
_table = require 'helpers.table'
table.print = _table.print
table.explode = _table.explode
table.contains = _table.contains
table.append = _table.append
map = require 'helpers.map'
partial = require 'helpers.partial'
Game = require 'Game'
Engine = require 'Engine'

local game = Game()

function love.load()
    game:load()
end

function love.update(dt)
    game:update(dt)
end

function love.draw()
    game:draw()
end

function love.textinput(t)
    game:textinput(t)
end

function love.keypressed(key)
    game:keypressed(key)
end

function love.mousepressed(x, y, button)
    game:mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
    game:mousereleased(x, y, button)
end

function love.conf(t)
    game:conf(t)
end

function love.quit()
    return game:quit()
end
