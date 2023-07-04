-- Copyright (c) 2023 James Cook
-- Matrix operations, including matrix multiplication, and matrix transformation

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

public function GetRows(sequence s, integer pos, integer xpos)
    return s[pos..xpos]
end function

public function ReplaceRows(sequence s, sequence x, integer pos, integer xpos)
    return s[1..pos - 1] & x & s[xpos + 1..$]
end function

public function GetRow(sequence s, integer pos)
    return s[pos]
end function

public function ReplaceRow(sequence s, sequence x, integer pos)
    if cols(s) != length(x) then
        abort(1/0)
    end if
    s[pos] = x
    return s
end function

public function InsertRow(sequence s, sequence x, integer pos)
    if cols(s) != length(x) then
        abort(1/0)
    end if
    return insert(s, x, pos)
end function

public function RemoveRow(sequence s, integer pos)
    return remove(s, pos)
end function

public function GetCols(sequence s, integer pos, integer xpos)
-- returns a matrix
    sequence c
    c = repeat(0, length(s))
    for i = 1 to length(s) do
        c[i] = s[i][pos..xpos]
    end for
    return c
end function

public function ReplaceCols(sequence s, sequence x, integer pos, integer xpos)
    sequence c
    c = repeat(0, length(s))
    for i = 1 to length(s) do
        c[i] = s[i][1..pos - 1] & x & s[i][xpos + 1..$]
    end for
    return c
end function

public function GetCol(sequence s, integer pos)
-- Get Column, return as a Row
    sequence c
    c = repeat(0, length(s))
    for i = 1 to length(s) do
        c[i] = s[i][pos]
    end for
    return c
end function

public function ReplaceCol(sequence s, sequence x, integer pos)
-- Replace Column, as a Row
    if length(s) != length(x) then
        abort(1/0)
    end if
    for i = 1 to length(s) do
        s[i][pos] = x[i]
    end for
    return s
end function

public function InsertCol(sequence s, sequence x, integer pos)
-- Insert Column, as a Row
    if length(s) != length(x) then
        abort(1/0)
    end if
    for i = 1 to length(s) do
        s[i] = insert(s[i], x[i], pos)
    end for
    return s
end function

public function RemoveCol(sequence s, integer pos)
-- Remove Column, return sequence
    for i = 1 to length(s) do
        s[i] = remove(s[i], pos)
    end for
    return s
end function

-- Operations: * + -

public function IsMatrix(sequence a, integer strictMatrix = 0)
    integer c
    if length(a) = 0 then
        return 0
    end if
    c = length(a[1])
    for i = 1 to length(a) do
        if c != length(a[i]) then
            return 0
        elsif strictMatrix then
            for j = 1 to c do
                if sequence(a[i][j]) then
                    return 0
                end if
            end for
        end if
    end for
    return 1
end function

public type Matrix(sequence a)
-- Matrix() type can be a row by column matrix of anything.
    return IsMatrix(a)
end type

public type MatrixStrict(sequence a)
-- MatrixStrict() type has to be a row by column matrix of atoms.
    return IsMatrix(a, 1)
end type

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
        sum = b[1] * a[i][1]
        for k = 2 to m do
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
