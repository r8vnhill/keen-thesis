using Plots; pythonplot()
using LaTeXStrings
include("../commons/draw.jl")

"""
    goldstein_price(x::Float64, y::Float64)::Float64

Calculate the Goldstein-Price function, which is commonly used as a performance test problem
  for optimization algorithms.

# Arguments
  - `x::Float64`: the first dimension value
  - `y::Float64`: the second dimension value

# Returns
  The calculated Goldstein-Price function value as a Float64.
"""
goldstein_price(x::Float64, y::Float64)::Float64 = 
  (1 + (x + y + 1)^2 * (19 - 14x + 3x^2 - 14y + 6x * y + 3y^2)) * 
    (30 + (2x - 3y)^2 * (18 - 32x + 12x^2 + 48y - 36x * y + 27y^2))

draw(
  x_range = -2 => 2,
  y_range = -2 => 2,
  f = goldstein_price,
  minima = [0] => [-1],
  name = "goldstein_price",
  log_scale = true
)
