-- Copyright (c) 2023 James Cook
-- Deep learning using matrix multiplication.

namespace deeplearning

public include std/math.e
public include matrix.e

export function GetUseObjectNum()
    return OBJECT_NUM
end function

export procedure SetUseObjectNum(integer i)
    OBJECT_NUM = i
end procedure

-- input layer, x
-- hidden layers
-- output layer, y
-- weights and biases, W and b
-- activation function, sigma (as in a Sigmoid activation function)

public constant
    INPUT = 1,
    OUTPUT = 2,
    Y = 3,
    WEIGHTS = 4,
    LAYERS = 5,
$

public function NewNetwork(object x, object y, sequence weights)
--    def __init__(self, x, y):
--        self.input      = x
--        self.weights1   = np.random.rand(self.input.shape[1],4) 
--        self.weights2   = np.random.rand(4,1)                 
--        self.y          = y
--        self.output     = np.zeros(self.y.shape)
    sequence s
    s = repeat(0, 5)

    s[INPUT] = x
    s[WEIGHTS] = weights -- NOTE: You have to come up with the weights yourself.
    s[Y] = y
    s[OUTPUT] = 0
    s[LAYERS] = {}
    return s
end function

-- sigmoid function, and derivative
-- f(x) = 1 / (1 + exp(- (x)))
-- f'(x) = exp(- (x)) / power(1 + exp(- (x)), 2)
-- f'(x) = f(x) * (1 - f(x))

public function sigmoid(object x)
    return 1 / (1 + math:exp(- (x)))
end function

public function sigmoid_derivativeA(object x)
    object tmp1, tmp
    tmp1 = math:exp(- (x))
    tmp = tmp1 + 1
    tmp = tmp * tmp
    return tmp1 / tmp
end function

public function sigmoid_derivative(object x)
    object tmp
    tmp = sigmoid(x)
    return tmp * (1 - (tmp))
end function

public function FeedForward1(object x, object W, object b = 0)
    -- Call this function once for every layer, replacing the first argument with the output of the previous function call.
    object a, z
    a = MatrixMultiplication(W, x) -- (W * x), or (x * W) ???
    if not equal(0, b) then
        a += b
    end if
    z = sigmoid(a)
    return z
end function

public function FeedForward(sequence self)
    sequence layers, layer
    integer len
    len = length(self[WEIGHTS])
    layers = repeat(0, len)
    layer = self[INPUT]
    for i = 1 to len do
        layer = FeedForward1(layer, self[WEIGHTS][i], 0)
        layers[i] = layer
    end for
    self[OUTPUT] = layer
    layers = layers[1..$ - 1]
    self[LAYERS] = layers
    return self
end function

public function SumOfSquares(object wanted, object got)
-- A loss function, Sum of Squares.
-- "Our goal in training is to find the best set of weights and biases that minimizes the loss function."
-- "If we have the derivative, we can simply update the weights and biases by increasing/reducing with it(refer to the diagram above). This is known as gradient descent."
-- "However, we can’t directly calculate the derivative of the loss function with respect to the weights and biases because the equation of the loss function does not contain the weights and biases. Therefore, we need the chain rule to help us calculate it."
-- - from: https://towardsdatascience.com/how-to-build-your-own-neural-network-from-scratch-in-python-68998a08e4f6
    object a, sum
    sum = 0
    for i = 1 to 1 do
        a = wanted - got
        a *= a
        sum += a
    end for
    return sum
end function


public function BackPropagation(sequence self)
    sequence s, d

    -- # application of the chain rule to find derivative of the loss function with respect to weights2 and weights1
    -- d_weights2 = np.dot(self.layer1.T, (2*(self.y - self.output) * sigmoid_derivative(self.output)))


    d = repeat(0, length(self[WEIGHTS]))
    self[LAYERS] = {self[INPUT]} & self[LAYERS]

    s = 2 * (self[Y] - self[OUTPUT]) * sigmoid_derivative(self[OUTPUT])

    d[$] = MatrixMultiplication(MatrixTransformation(self[LAYERS][$]), s)
    for i = length(d) - 1 to 1 by -1 do
        s = ( MatrixMultiplication( s, MatrixTransformation(self[WEIGHTS][i + 1]) ) * sigmoid_derivative(self[LAYERS][i]) )

        d[i] = MatrixMultiplication(MatrixTransformation(self[LAYERS][i]), s)
    end for
    self[LAYERS] = self[LAYERS][2..$]
    self[WEIGHTS] += d
    return self


    -- d_weights1 = np.dot(self.input.T,  (np.dot(2*(self.y - self.output) * sigmoid_derivative(self.output), self.weights2.T) * sigmoid_derivative(self.layer1)))
    -- # update the weights with the derivative (slope) of the loss function
    -- self.weights1 += d_weights1
    -- self.weights2 += d_weights2

end function

/*
class NeuralNetwork:
    def __init__(self, x, y):
        self.input      = x
        self.weights1   = np.random.rand(self.input.shape[1],4) 
        self.weights2   = np.random.rand(4,1)                 
        self.y          = y
        self.output     = np.zeros(self.y.shape)

    def feedforward(self):
        self.layer1 = sigmoid(np.dot(self.input, self.weights1))
        self.output = sigmoid(np.dot(self.layer1, self.weights2))

    def backprop(self):
        # application of the chain rule to find derivative of the loss function with respect to weights2 and weights1
        d_weights2 = np.dot(self.layer1.T, (2*(self.y - self.output) * sigmoid_derivative(self.output)))
        d_weights1 = np.dot(self.input.T,  (np.dot(2*(self.y - self.output) * sigmoid_derivative(self.output), self.weights2.T) * sigmoid_derivative(self.layer1)))

        # update the weights with the derivative (slope) of the loss function
        self.weights1 += d_weights1
        self.weights2 += d_weights2
*/
