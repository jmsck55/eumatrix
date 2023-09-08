-- Copyright (c) 2023 James Cook


with trace

include matrix.e

trace(1)

object a, b, c, d

a = {
    {1, 0, -2},
    {0, 3, -1}
}
b = {
    {0, 3},
    {-2, -1},
    {0, 4}
}

c = {
    {0, -5},
    {-6, -7}
}

d = MatrixMultiplication(a, b)
? d

? equal(c, d)

c = {
    {2, -1},
    {0, 3},
    {1, 0}
}

d = {
    {0, 1, 4, -1},
    {-2, 0, 0, 2}
}

? MatrixMultiplication(c, d)
--? MatrixMultiplication(d, c)
