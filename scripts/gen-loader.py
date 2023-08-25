#!/usr/bin/env python3

import os

if __name__ == "__main__":
    print("[+]  generating loader... ⚙️")
    src_dir = os.path.realpath(os.path.join(os.path.dirname(
        os.path.realpath(__file__)), "..", "app", "src"))
    loader_file = os.path.realpath(os.path.join(os.path.dirname(
        os.path.realpath(__file__)), "..", "app", "loader.lua"))
    items = []
    for root, dirs, files in os.walk(src_dir):
        for f in files:
            if f.endswith(".lua") and f[0].isupper():
                items += [(f[:-4], os.path.relpath(
                    os.path.abspath(os.path.join(root, f[:-4])), os.path.abspath(src_dir)).replace("/", "."))]
    with open(loader_file, "a") as f:
        f.truncate(0)
        f.write("""
----
---
-- Halmö
--
-- (c) 2015-2023 Younis Bensalah <younis.bensalah@gmail.com>
---
----
""")
        for i in items:
            f.write("{} = require \"{}\"\n".format(*i))
            print("[*]  {} ✅".format(i[1]))
    print("[+]  loader is ready! 🦄")
