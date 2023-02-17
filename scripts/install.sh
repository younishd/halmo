#!/usr/bin/env bash
luarocks --lua-dir="$(brew --prefix)/opt/lua@5.1" --lua-version=5.1 install --tree .luarocks middleclass
luarocks --lua-dir="$(brew --prefix)/opt/lua@5.1" --lua-version=5.1 install --tree .luarocks lua-protobuf
luarocks --lua-dir="$(brew --prefix)/opt/lua@5.1" --lua-version=5.1 install --tree .luarocks luasocket
luarocks --lua-dir="$(brew --prefix)/opt/lua@5.1" --lua-version=5.1 install --tree .luarocks serpent
luarocks --lua-dir="$(brew --prefix)/opt/lua@5.1" --lua-version=5.1 install --tree .luarocks lua-struct
