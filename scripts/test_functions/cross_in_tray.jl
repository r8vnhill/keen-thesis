using Plots; pythonplot()
using LaTeXStrings
include("../commons/draw.jl")

"""
    cross_in_tray(x::Float64, y::Float64)::Float64

Calculate the cross-in-tray function, which is commonly used as a performance test problem
  for optimization algorithms.

# Arguments
  - `x::Float64`: the first dimension value
  - `y::Float64`: the second dimension value

# Returns
  The calculated cross-in-tray function value as a Float64.
"""
cross_in_tray(x::Float64, y::Float64)::Float64 = 
  -0.0001 * (abs(sin(x) * sin(y) * exp(abs(100 - sqrt(x^2 + y^2) / pi))) + 1)^0.1

draw(
  x_range = -10 => 10,
  y_range = -10 => 10,
  f = cross_in_tray,
  minima = [1.34941, 1.34941, -1.34941, -1.34941] => [-1.34941, 1.34941, -1.34941, 1.34941],
  name = "cross_in_tray",
)
