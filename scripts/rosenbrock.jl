using Plots; pythonplot()
using LaTeXStrings

"""
    rosenbrock(x::Float64, y::Float64)

Calculate the Rosenbrock function, which is commonly used as a performance test 
  problem for optimization algorithms.

# Arguments
- `x::Float64`: the first dimension value
- `y::Float64`: the second dimension value

# Returns
- The calculated Rosenbrock function value as a Float64.
"""
function rosenbrock(x::Float64, y::Float64)::Float64
    return (1 - x)^2 + 100 * (y - x^2)^2
end

x = range(-5, 5, length=100)
y = range(-5, 5, length=100)
z = @. rosenbrock(x', y)

println("Creating contour plot...")
contour(x, y, z, levels=20, lw=1, fill=true, color=:batlowK50)
xlabel!(L"$x$")
ylabel!(L"$y$")
# png("img/test_functions/rosenbrock_contour.png")

# println("Creating surface plot...")
# surface(x, y, z, color=:batlowK50)
# xlabel!(L"$x$")
# ylabel!(L"$y$")
# png("img/test_functions/rosenbrock_surface.png")