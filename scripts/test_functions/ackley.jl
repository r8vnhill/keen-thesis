using Plots; pythonplot()
using LaTeXStrings

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
function ackley(x::Float64, y::Float64)::Float64
  return -20 * 
    exp(-0.2 * sqrt(0.5 * (x^2 + y^2))) - 
    exp(0.5 * (cos(2π * x) + cos(2π * y))) + 
    exp(1) + 
    20
end

# Define a range of x and y values from -5 to 5, with 100 points in each range.
x = range(-5, 5, length=100)
y = range(-5, 5, length=100)

# Calculate the z values (Ackley function values) for each pair of x and y values.
z = @. ackley(x', y)

# Generate a filled contour plot of the Ackley function.
contour(
  x, y, z, 
  levels=100, 
  fill=true, 
  color=:batlowK50, 
  tickfontsize=12, 
  guidefontsize=14, 
  colorbar_tickfontsize=12
)
contour!(x, y, z, levels=10, lw=1, color=:black, legend=false)
# Highlight the global minimum of the Ackley function at (0,0) with a red dot.
scatter!([0], [0], color=:red, ms=6, legend=false)

# Set the labels for the x and y axes.
xlabel!(L"$x$")
ylabel!(L"$y$")

# Display the plot and save it as a PNG file.
display(plot!())
png("img/test_functions/ackley_contour.png")

# Generate a surface plot of the Ackley function.
surface(x, y, z, color=:batlowK50, colorbar=false, tickfontsize=12, guidefontsize=14)

# Set the labels for the x, y, and z axes.
xlabel!(L"$x$")
ylabel!(L"$y$")

# Display the plot and save it as a PNG file.
display(plot!())
png("img/test_functions/ackley_surface.png")
