using Plots; pythonplot()
using LaTeXStrings
include("../commons/draw.jl")

"""
    holder_table(x::Number, y::Number)::Number

Calculate the Holder table function, which is commonly used as a performance test
  problem for optimization algorithms.

# Arguments
  - `x::Number`: the first dimension value
  - `y::Number`: the second dimension value

# Returns
  The calculated Holder table function value as a Number.
"""
holder_table(x::Number, y::Number)::Number = 
  -abs(sin(x) * cos(y) * exp(abs(1 - sqrt(x^2 + y^2) / π)))

draw(
  x_range = -10 => 10,
  y_range = -10 => 10,
  f = holder_table,
  minima = [8.05502 => 9.66459,  -8.05502 => 9.66459, 8.05502 => -9.66459, -8.05502 => -9.66459],
  name = "holder_table",
)
