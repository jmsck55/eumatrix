-- Copyright (c) 2023 James Cook
-- Matrix operations, including matrix multiplication, and matrix transformation

namespace matrix

-- NOTES:
--
-- OBJECT_NUM,
-- Set to one (1) to have object elements of matrices,
-- Otherwise, elements must be atoms.
-- Limited scope to export for now.
--
export integer OBJECT_NUM = 0 -- 1 for no type checking of num type.

public type num(object x)
    if OBJECT_NUM then
        return 1
    else
        return atom(x)
    end if
end type

public function NewMatrix(integer rows, integer cols)
    return repeat(repeat(0, cols), rows)
end function

public function rows(sequence a)
    return length(a)
end function

public function cols(sequence a)
    return length(a[1])
end function

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

public type matrix(sequence a)
-- matrix() type can be a row by column matrix of anything.
    return IsMatrix(a)
end type

public type matrixStrict(sequence a)
-- matrixStrict() type has to be a row by column matrix of atoms.
    return IsMatrix(a, 1)
end type

public function IsMatrixMultiply(matrix a, matrix b)
    return cols(a) = rows(b)
end function

public function MatrixMultiplication(matrix a, matrix b)
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

public function MatrixTranspose(matrix a)
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

public function GetRows(matrix s, integer pos, integer xpos)
    return s[pos..xpos]
end function

public function ReplaceRows(matrix s, matrix x, integer pos, integer xpos)
    matrix r
    if cols(s) != cols(x) then
        -- generates an error, even without type checking
        abort(1/0)
    end if
    r = s[1..pos - 1] & x & s[xpos + 1..$]
    return r
end function

public function GetRow(matrix s, integer pos)
    return s[pos]
end function

public function ReplaceRow(matrix s, sequence x, integer pos)
    if cols(s) != length(x) then
        abort(1/0)
    end if
    s[pos] = x
    return s
end function

public function InsertRow(matrix s, sequence x, integer pos)
    if cols(s) != length(x) then
        abort(1/0)
    end if
    return insert(s, x, pos)
end function

public function RemoveRow(matrix s, integer pos)
    return remove(s, pos)
end function

public function GetCols(matrix s, integer pos, integer xpos)
-- takes a matrix, returns a matrix
    sequence c
    c = repeat({}, length(s))
    for i = 1 to length(s) do
        c[i] = s[i][pos..xpos]
    end for
    return c
end function

public function ReplaceCols(matrix s, matrix x, integer pos, integer xpos)
-- takes two matrices, returns a matrix
    sequence c
    c = repeat({}, length(s))
    for i = 1 to length(s) do
        c[i] = s[i][1..pos - 1] & x[i] & s[i][xpos + 1..$]
    end for
    return c
end function

public function GetCol(matrix s, integer pos)
-- Get Column, return as a Row
    sequence c
    c = repeat(0, length(s))
    for i = 1 to length(s) do
        c[i] = s[i][pos]
    end for
    return c
end function

public function ReplaceCol(matrix s, sequence x, integer pos)
-- Replace Column, as a Row
    if length(s) != length(x) then
        abort(1/0)
    end if
    for i = 1 to length(s) do
        s[i][pos] = x[i]
    end for
    return s
end function

public function InsertCol(matrix s, sequence x, integer pos)
-- Insert Column, as a Row
    sequence c
    if length(s) != length(x) then
        abort(1/0)
    end if
    c = repeat({}, length(s))
    for i = 1 to length(s) do
        c[i] = insert(s[i], x[i], pos)
    end for
    return c
end function

public function RemoveCol(matrix s, integer pos)
-- Remove Column, return matrix
    sequence c
    c = repeat({}, length(s))
    for i = 1 to length(s) do
        c[i] = remove(s[i], pos)
    end for
    return c
end function

-- Operations: * + -

public function Multiply(sequence s, num x)
    -- Multiply an array or a matrix with an object.
    return s * x
end function

public function Add(sequence s, num x)
    -- Add an array or a matrix with an object.
    return s + x
end function

public function Subtract(sequence s, num x)
    -- Subtract an array or a matrix with an object.
    return s - x
end function

public function MultiplyRow(matrix s, num x, integer pos)
    s[pos] *= x
    return s
end function

public function AddRow(matrix s, num x, integer pos)
    s[pos] += x
    return s
end function

public function SubtractRow(matrix s, num x, integer pos)
    s[pos] -= x
    return s
end function

public function MultiplyCol(matrix s, num x, integer pos)
    for i = 1 to length(s) do
        s[i][pos] *= x
    end for
    return s
end function

public function AddCol(matrix s, num x, integer pos)
    for i = 1 to length(s) do
        s[i][pos] += x
    end for
    return s
end function

public function SubtractCol(matrix s, num x, integer pos)
    for i = 1 to length(s) do
        s[i][pos] -= x
    end for
    return s
end function
