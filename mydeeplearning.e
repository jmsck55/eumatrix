-- Copyright (c) 2023 James Cook
-- mydeeplearning.e, an extension to deeplearning.e

namespace mydeeplearning

public include std/mathcons.e
public include deeplearning.e

public function sigmoidtwo(object x)
    return 1.0/(1 + power(2, - (x)))
end function
public constant sigmoidtwo_id = routine_id("sigmoidtwo")

public function sigmoidtwo_derivative(object x)
    object tmp1, tmp
    tmp1 = power(2, - (x))
    tmp = tmp1 + 1
    tmp = tmp * tmp
    tmp1 *= LN2
    return tmp1 / tmp
end function
public constant sigmoidtwo_derivative_id = routine_id("sigmoidtwo_derivative")
