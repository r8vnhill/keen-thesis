using Plots; pythonplot()
using LaTeXStrings
include("../commons/draw.jl")

"""
    easom(x::Float64, y::Float64)

Calculate the Easom function, which is commonly used as a performance test
    problem for optimization algorithms.

# Arguments
- `x::Float64`: the first dimension value
- `y::Float64`: the second dimension value

# Returns
- The calculated Easom function value as a Float64.
"""
function easom(x::Float64, y::Float64)::Float64
    return -cos(x) * cos(y) * exp(-((x - pi)^2 + (y - pi)^2))
end

x = range(-100, 100, length=100)
y = range(-100, 100, length=100)
z = @. easom(x', y)

println("Creating contour plot...")
draw_contour(x, y, z, [pi; pi], "img/test_functions/easom_contour.png")

println("Creating surface plot...")
draw_surface(x, y, z, "img/test_functions/easom_surface.png")

x = range(0, 2 * pi, length=100)
y = range(0, 2 * pi, length=100)
z = @. easom(x', y)
println("Creating close-up contour plot...")
draw_contour(x, y, z, [pi; pi], "img/test_functions/easom_contour_closeup.png")

println("Creating close-up surface plot...")
draw_surface(x, y, z, "img/test_functions/easom_surface_closeup.png")
