include("../commons/draw.jl")

"""
    ackley(x::Float64, y::Float64)::Float64

Compute the Ackley function for given `x` and `y` inputs.

The Ackley function is a common optimization test function that contains many
local minima. It's generally used in the context of genetic algorithms or 
similar optimization algorithms.

# Arguments
- `x` - The x-coordinate at which to evaluate the Ackley function.
- `y` - The y-coordinate at which to evaluate the Ackley function.
"""
ackley(x::Number, y::Number)::Number = 
  -20 * exp(-0.2 * sqrt(0.5 * (x^2 + y^2))) - 
  exp(0.5 * (cos(2π * x) + cos(2π * y))) + 
  exp(1) + 
  20

draw(
  x_range = -5 => 5,
  y_range = -5 => 5,
  f = ackley,
  minima = [0 => 0],
  name = "ackley"
)
