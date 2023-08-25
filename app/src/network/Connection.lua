----
---
-- Halmö
--
-- (c) 2015-2023 Younis Bensalah <younis.bensalah@gmail.com>
---
----

local Connection = class("Connection")

function Connection:initialize(host, port)
    local f = assert(io.open("../halmo.proto", "r"))
    local content = f:read("*all")
    f:close()

    self.protoc = protoc.new(content)

    self.sock = assert(socket.tcp())
    self.sock:connect(host, port)
end

return Connection
