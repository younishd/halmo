----
---
-- Halmö
--
-- (c) 2015-2023 Younis Bensalah <younis.bensalah@gmail.com>
---
----
local Connection = class("Connection")

function Connection:initialize(host, port)
    self.sock = assert(socket.tcp())
    self.sock:connect(host, port)
end

function Connection:send(msg)
    local buf = assert(pb.encode("Message", msg), "failed to encode protobuf message!")
    self.sock:send(struct.pack(">I", #buf) .. buf)
end

function Connection:recv()
    local header = ""
    while #header < 4 do
        local buf, status = self.sock:receive(4 - #header)
        if buf then
            header = header .. buf
        end
        if status == "closed" or status == "timeout" then
            return
        end
    end
    local length = struct.unpack(">I", header)
    local payload = ""
    while #payload < length do
        local buf, status = self.sock:receive(length - #payload)
        if buf then
            payload = payload .. buf
        end
        if status == "closed" or status == "timeout" then
            return
        end
    end
    return assert(pb.decode("Message", payload), "failed to decode protobuf message!")
end

return Connection
