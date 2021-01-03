require'env'
e = Engine(Board())
e:move({ x=1, y=5 }, { x=1, y=4 })
e:move({ x=1, y=4 }, { x=1, y=5 })
e:move({ x=3, y=5 }, { x=2, y=4 })
