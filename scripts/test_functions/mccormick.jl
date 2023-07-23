include("../commons/draw.jl")

"""
    mccormick(x::Number, y::Number)::Number

Compute the McCormick function for a given pair of input values.

  The  McCormick function is a mathematical function used as a performance 
  test problem for optimization algorithms. It is defined as follows:

  ``f(x, y) = sin(x + y) + (x - y)^2 - 1.5x + 2.5y + 1``

# Arguments
  - `x` - The first input value.
  - `y` - The second input value.

# Returns
  - The value of the McCormick function at the given input values.
"""
mccormick(x::Number, y::Number)::Number = 
  sin(x + y) + (x - y)^2 - 1.5 * x + 2.5 * y + 1

draw(
  x_range = -1.5 => 4,
  y_range = -3 => 4,
  f = mccormick,
  minima = [-0.54719 => -1.54719],
  name = "mccormick",
)
