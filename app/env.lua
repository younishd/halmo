--[[
--
-- Halmö
--
-- (c) 2015-2021 Younis Bensalah <younis.bensalah@gmail.com>
--
--]]

package.path                = package.path .. ';src/?.lua;lib/?.lua'
version                     = (function() for v in io.lines('VERSION') do return v end end)()
platform                    = function() return string.format("%s | %s | %s\n%s %s | %s", love.system.getOS(), _VERSION, string.format("LÖVE %d.%d.%d (%s)", love.getVersion()), ({love.graphics.getRendererInfo()})[1], ({love.graphics.getRendererInfo()})[2], ({love.graphics.getRendererInfo()})[4]) end
class                       = require 'middleclass.middleclass'
local _table                = require 'helpers.table'
table.explode               = _table.explode
table.contains              = _table.contains
table.append                = _table.append
local _math                 = require 'helpers.math'
math.sign                   = _math.sign
math.isint                  = _math.isint
mixins                      = {}
mixins.hooks                = require 'mixins.hooks'
log                         = require 'helpers.log'
map                         = require 'helpers.map'
imap                        = require 'helpers.imap'
partial                     = require 'helpers.partial'
times                       = require 'helpers.times'
kpairs                      = require 'helpers.kpairs'
Game                        = require 'Game'
Engine                      = require 'core.Engine'
Board                       = require 'core.Board'
Player                      = require 'core.Player'
BoardUI                     = require 'ui.BoardUI'
