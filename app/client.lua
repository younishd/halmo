require "env"

-- read protobuf file
file = "src/net/halmo.proto"
local f = assert(io.open(file, "r"))
local content = f:read("*all")
f:close()

protoc:load(content)

local bytes = assert(pb.encode("Message", {move = {from = {x = 13, y = 37}, to = {x = 14, y = 48}}}))
print(pb.tohex(bytes))

local data2 = assert(pb.decode("Message", bytes))
print(serpent.block(data2))
