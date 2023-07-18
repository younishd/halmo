require "env"

-- -- test engine
-- local e = Engine(Board())
-- e:move({ x=1, y=5 }, { x=1, y=4 })
-- e:move({ x=1, y=4 }, { x=1, y=5 })
-- e:move({ x=3, y=5 }, { x=2, y=4 })

-- -- read protobuf file


-- local bytes = assert(pb.encode("Message", {move = {from = {x = 13, y = 37}, to = {x = 14, y = 48}}}))
-- print(pb.tohex(bytes))

-- local data2 = assert(pb.decode("Message", bytes))
-- print(serpent.block(data2))

function send(sock, payload)
    local buf = assert(pb.encode("Message", payload), "failed to encode protobuf message!")
    sock:send(struct.pack(">I", #buf) .. buf)
end

function recv(sock)
    local header = ""
    while #header < 4 do
        local buf, status = sock:receive(4 - #header)
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
        local buf, status = sock:receive(length - #payload)
        if buf then
            payload = payload .. buf
        end
        if status == "closed" or status == "timeout" then
            return
        end
    end
    return assert(pb.decode("Message", payload), "failed to decode protobuf message!")
end

local f = assert(io.open("../halmo.proto", "r"))
local content = f:read("*all")
f:close()
protoc:load(content)

local sock = assert(socket.tcp())
sock:connect("localhost", 33333)

local player = {player = {name = "Neo"}}
send(sock, player)

local msg = recv(sock)
assert(msg and msg.type == "status")
print(serpent.block(msg))
assert(msg.status.code == "OK")

sock:close()
