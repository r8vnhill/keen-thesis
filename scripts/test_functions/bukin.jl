using Plots; pythonplot()
using LaTeXStrings
include("../commons/draw.jl")

"""
    bukin(x::Float64, y::Float64)::Float64

Calculate the Bukin function, which is commonly used as a performance test problem
  for optimization algorithms.

# Arguments
  - `x::Float64`: the first dimension value
  - `y::Float64`: the second dimension value

# Returns
  The calculated Bukin function value as a Float64.
"""
bukin(x::Float64, y::Float64)::Float64 = 
  100 * sqrt(abs(y - 0.01 * x^2)) + 0.01 * abs(x + 10)

draw(
  x_range = -15 => -5,
  y_range = -3 => 3,
  f = bukin,
  minima = [-10 => 1],
  name = "bukin",
  log_scale = true
)