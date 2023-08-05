include("../commons/draw.jl")

"""
    styblinski_tang(x::Number, y::Number)::Number

Calculate the Styblinski-Tang function, which is commonly used as a performance test problem
    for optimization algorithms.

# Arguments
- `x::Number`: the first dimension value
- `y::Number`: the second dimension value

# Returns
- The calculated Styblinski-Tang function value as a Number.
"""
styblinski_tang(x::Number, y::Number)::Number = 
    0.5 * (x^4 - 16x^2 + 5x) + 0.5 * (y^4 - 16y^2 + 5y)

draw(
    x_range = -5 => 5,
    y_range = -5 => 5,
    f = styblinski_tang,
    minima = [-2.903534 => -2.903534],
    name = "styblinski_tang",
)
