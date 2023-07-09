using Plots; pythonplot()
using LaTeXStrings
include("../commons/draw.jl")

"""
    levi(x::Number, y::Number)::Number

Calculate the Levi function, which is commonly used as a performance test problem
  for optimization algorithms.

# Arguments
  - `x::Number`: the first dimension value
  - `y::Number`: the second dimension value

# Returns
  The calculated Levi function value as a Number.
"""
levi(x::Number, y::Number)::Number = 
  sin(3 * pi * x)^2 + 
    (x - 1)^2 * (1 + sin(3 * pi * y)^2) + 
    (y - 1)^2 * (1 + sin(2 * pi * y)^2)

draw(
  x_range = -10 => 10,
  y_range = -10 => 10,
  f = levi,
  minima = [1, 1] => [1, 1],
  name = "levi",
)
