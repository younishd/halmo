require "env"

-- test engine
local e = Engine(Board())
e:move({ x=1, y=5 }, { x=1, y=4 })
e:move({ x=1, y=4 }, { x=1, y=5 })
e:move({ x=3, y=5 }, { x=2, y=4 })

-- read protobuf file
local f = assert(io.open("../halmo.proto", "r"))
local content = f:read("*all")
f:close()

protoc:load(content)

local bytes = assert(pb.encode("Message", {move = {from = {x = 13, y = 37}, to = {x = 14, y = 48}}}))
print(pb.tohex(bytes))

local data2 = assert(pb.decode("Message", bytes))
print(serpent.block(data2))

-- test sending data to server
local tcp = assert(socket.tcp())
tcp:connect("localhost", 33333)
tcp:close()
