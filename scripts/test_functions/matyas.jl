using Plots; pythonplot()
using LaTeXStrings
include("../commons/draw.jl")

"""
    matyas(x::Float64, y::Float64)::Float64

Calculate the Matyas function, which is commonly used as a performance test problem
  for optimization algorithms.

# Arguments
  - `x::Float64`: the first dimension value
  - `y::Float64`: the second dimension value

# Returns
  The calculated Matyas function value as a Float64.
"""
function matyas(x::Float64, y::Float64)::Float64
    return 0.26 * (x^2 + y^2) - 0.48 * x * y
end

draw(
  x_range = -10 => 10,
  y_range = -10 => 10,
  f = matyas,
  minima = [0 => 0],
  name = "matyas",
  log_scale = true
)
