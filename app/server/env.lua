----
---
-- Halmö
--
-- (c) 2015-2023 Younis Bensalah <younis.bensalah@gmail.com>
---
----
local lua_version = "5.1"
package.path = package.path .. ";src/?.lua;lib/?/?.lua"
package.path =
    "../.luarocks/share/lua/" ..
    lua_version .. "/?.lua;../.luarocks/share/lua/" .. lua_version .. "/?/init.lua;" .. package.path
package.cpath = "../.luarocks/lib/lua/" .. lua_version .. "/?.so;" .. package.cpath
version = require "version"
class = require "middleclass"
json = require "json"
local _table = require "helpers.table"
table.explode = _table.explode
table.contains = _table.contains
table.append = _table.append
local _math = require "helpers.math"
math.sign = _math.sign
math.isint = _math.isint
mixins = {}
mixins.hooks = require "mixins.hooks"
map = require "helpers.map"
imap = require "helpers.imap"
partial = require "helpers.partial"
times = require "helpers.times"
kpairs = require "helpers.kpairs"
file_exists = require "helpers.file_exists"
serpent = require "serpent"
require "loader"
logo = function()
    log.info(
        [[


                             ,,                    ,,  ,,
    `7MMF'  `7MMF'         `7MM                    db  db
      MM      MM             MM
      MM      MM   ,6"Yb.    MM  `7MMpMMMb.pMMMb.  ,pW"Wq.
      MMmmmmmmMM  8)   MM    MM    MM    MM    MM 6W'   `Wb
      MM      MM   ,pm9MM    MM    MM    MM    MM 8M     M8
      MM      MM  8M   MM    MM    MM    MM    MM YA.   ,A9
    .JMML.  .JMML.`Moo9^Yo..JMML..JMML  JMML  JMML.`Ybmd9'


]]
    )
end
