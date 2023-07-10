using Plots; pythonplot()
using LaTeXStrings
include("../commons/draw.jl")

"""
    three_hump_camel(x::Float64, y::Float64)::Float64

Calculate the three-hump camel function, which is commonly used as a performance test problem
  for optimization algorithms.

# Arguments
  - `x::Float64`: the first dimension value
  - `y::Float64`: the second dimension value

# Returns
  The calculated three-hump camel function value as a Float64.
"""
three_hump_camel(x::Float64, y::Float64)::Float64 = 2x^2 - 1.05x^4 + x^6 / 6 + x * y + y^2

draw(
  x_range = -5 => 5,
  y_range = -5 => 5,
  f = three_hump_camel,
  minima = [0 => 0],
  name = "three_hump_camel",
  log_scale = true
)
