using Plots; pythonplot()
using LaTeXStrings
include("../commons/draw.jl")

"""
    beale(x::Number, y::Number)::Number

Compute the Beale function for given `x` and `y`.

The Beale function is a multimodal function, which is often used as a performance 
test problem for optimization algorithms.

# Arguments
- `x` - The x-coordinate.
- `y` - The y-coordinate.
"""
beale(x::Number, y::Number)::Number = 
  (1.5 - x + x * y)^2 + (2.25 - x + x * y^2)^2 + (2.625 - x + x * y^3)^2

draw(
  x_range = -4.5 => 4.5,
  y_range = -4.5 => 4.5,
  f = beale,
  minima = [3] => [0.5],
  name = "beale",
  log_scale = true
)