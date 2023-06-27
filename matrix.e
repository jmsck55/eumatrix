-- Copyright (c) 2023 James Cook
-- Matrix multiplication

namespace matrix

public function NewMatrix(integer rows, integer cols)
    return repeat(repeat(0, cols), rows)
end function

public function rows(sequence a)
    return length(a)
end function

public function cols(sequence a)
    return length(a[1])
end function

public function IsMatrixMultiply(sequence a, sequence b)
    return cols(a) = rows(b)
end function

public function MatrixMultiplication(sequence a, sequence b)
    sequence c
    integer m
    object sum
    m = cols(a)
    if m != rows(b) then
        abort(1/0)
    end if
    c = repeat(0, rows(a))
    for i = 1 to rows(a) do
        sum = repeat(0, m)
        for k = 1 to m do
            sum += b[k] * a[i][k]
            -- c[i][j] = a[i][k] * b[k][j]
        end for
        c[i] = sum
    end for
    return c
end function

public function MatrixTransformation(sequence a)
    sequence ret, tmp
    integer aRows, aCols
    aRows = rows(a)
    aCols = cols(a)
    ret = repeat(0, aCols)
    for col = 1 to aCols do
        tmp = repeat(0, aRows)
        for row = 1 to aRows do
            tmp[row] = a[row][col]
        end for
        ret[col] = tmp
    end for
    return ret
end function
