-- Copyright (c) 2023 James Cook

with trace
trace(1)

include matrix.e

object c, d

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
? MatrixMultiplication(d, c)
