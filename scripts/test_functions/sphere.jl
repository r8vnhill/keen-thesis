using Plots; pythonplot()
using LaTeXStrings
include("../commons/draw.jl")

"""
    sphere(x::Number, y::Number)::Number

Calculate the Sphere function, which is commonly used as a performance test problem
    for optimization algorithms.

# Arguments
- `x::Number`: the first dimension value
- `y::Number`: the second dimension value

# Returns
- The calculated Sphere function value as a Number.
"""
sphere(x::Number, y::Number)::Number = x^2 + y^2

draw(
    x_range = -10 => 10,
    y_range = -10 => 10,
    f = sphere,
    minima = [0 => 0],
    name = "sphere"
)
