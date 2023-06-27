-- Copyright (c) 2023 James Cook
-- Deep learning using matrix multiplication.

namespace deeplearning

public include matrix.e

-- input layer, x
-- hidden layers
-- output layer, y
-- weights and biases, W and b
-- activation function, sigma (such as Sigmoid activation function)

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
    s[WEIGHTS] = weights
    s[Y] = y
    s[OUTPUT] = 0
    s[LAYERS] = {}
    return s
end function

public function ReLU(object x)
    if atom(x) then
        if x <= 0 then
            return 0
        else
            return x
        end if
    end if
    for i = 1 to length(x) do
        x[i] = ReLU(x[i])
    end for
    return x
    -- return max(0, x)
end function
public constant ReLU_id = routine_id("ReLU")

public function ReLU_derivative(object x)
    if atom(x) then
        if x <= 0 then
            return 0
        else
            return 1
        end if
    end if
    for i = 1 to length(x) do
        x[i] = ReLU_derivative(x[i])
    end for
    return x
end function
public constant ReLU_derivative_id = routine_id("ReLU_derivative")

public function FeedForward1(object x, object W, object b = 0, integer func_sigma = ReLU_id)
    -- Call this function once for every layer, replacing the first argument with the output of the previous function call.
    object a, z
    a = MatrixMultiplication(W, x) -- (W * x), or (x * W) ???
    a += b
    z = call_func(func_sigma, {a})
    return z
end function

public function FeedForward(sequence self, integer func_sigma = ReLU_id)
    sequence layers, layer
    integer len
    len = length(self[WEIGHTS])
    layers = repeat(0, len)
    layer = self[INPUT]
    for i = 1 to len do
        layer = FeedForward1(layer, self[WEIGHTS][i], 0, ReLU_id)
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

--public function BackPropagation1(sequence self, integer func_sigma_derivative = ReLU_derivative_id, object private = 0)
--    
--    return self
--end function

public function BackPropagation(sequence self, integer func_sigma_derivative = ReLU_derivative_id)
-- Currently, it only works for two (2) hidden layers.
    sequence s, d_weights1, d_weights2

    s = 2 * (self[Y] - self[OUTPUT]) * call_func(func_sigma_derivative, {self[OUTPUT]})
    -- # application of the chain rule to find derivative of the loss function with respect to weights2 and weights1
    -- d_weights2 = np.dot(self.layer1.T, (2*(self.y - self.output) * sigmoid_derivative(self.output)))
    d_weights2 = MatrixMultiplication(MatrixTransformation(self[LAYERS][1]), s)
    -- d_weights1 = np.dot(self.input.T,  (np.dot(2*(self.y - self.output) * sigmoid_derivative(self.output), self.weights2.T) * sigmoid_derivative(self.layer1)))
    d_weights1 = MatrixMultiplication(MatrixTransformation(self[INPUT]), MatrixMultiplication(s, MatrixTransformation(self[WEIGHTS][2]) * call_func(func_sigma_derivative, {self[LAYERS[1]]})))
    -- # update the weights with the derivative (slope) of the loss function
    -- self.weights1 += d_weights1
    self[WEIGHTS][1] += d_weights1
    -- self.weights2 += d_weights2
    self[WEIGHTS][2] += d_weights2
    return self
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