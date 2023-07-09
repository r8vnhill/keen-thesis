using Plots; pythonplot()
using LaTeXStrings
include("../commons/draw.jl")

A = 10
"""
    rastrigin(x::Number, y::Number)::Number

Calculate the Rastrigin function, which is commonly used as a performance test problem
  for optimization algorithms.  

# Arguments
  - `x::Number`: the first dimension value
  - `y::Number`: the second dimension value

# Returns
  The calculated Rastrigin function value as a Number.
"""
rastrigin(x::Number, y::Number)::Number = 2A + x^2 - A * cos(2π * x) + y^2 - A * cos(2π * y)
  
draw(
  x_range = -5.12 => 5.12,
  y_range = -5.12 => 5.12,
  f = rastrigin,
  minima = [0] => [0],
  name = "rastrigin",
)