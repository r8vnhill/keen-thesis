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
log_z = @. log(rosenbrock(x', y))

println("Creating contour plot...")
contour(
  x, 
  y, 
  log_z, 
  levels=100, 
  fill=true,
  tickfontsize=14,
  color=:batlowK50, 
  colorbar_ticks=(-3:2:12, [latexstring("\$10^{$i}\$") for i in -3:2:12]),
  colorbar_tickfontsize=14
)
xlabel!(L"$x$")
ylabel!(L"$y$")
# png("img/test_functions/rosenbrock_contour.png")

# println("Creating surface plot...")
# surface(
#   x, 
#   y, 
#   log_z, 
#   color=:batlowK50,
#   colorbar_ticks=(-3:2:12, [latexstring("\$10^{$i}\$") for i in -3:2:12]),
#   colorbar_tickfontsize=14
# )
# xlabel!(L"$x$")
# ylabel!(L"$y$")
# # png("img/test_functions/rosenbrock_surface.png")