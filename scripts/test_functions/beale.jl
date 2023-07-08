using Plots; pythonplot()
using LaTeXStrings

"""
    beale(x::Float64, y::Float64)::Float64

Compute the Beale function for given `x` and `y`.

The Beale function is a multimodal function, which is often used as a performance 
test problem for optimization algorithms.

# Arguments
- `x` - The x-coordinate.
- `y` - The y-coordinate.
"""
function beale(x::Float64, y::Float64)::Float64
  return (1.5 - x + x * y)^2 + (2.25 - x + x * y^2)^2 + (2.625 - x + x * y^3)^2
end

# Define the range of x and y values over which the function will be evaluated.
x = range(-4.5, 4.5, length=100)
y = range(-4.5, 4.5, length=100)

# Compute the function values in a 2D grid, taking the logarithm of the function.
log_z = @. log(beale(x', y))

max = maximum(log_z)
min = minimum(log_z)
step = (max - min) / 4

println("Creating contour plot...")
# Create a filled contour plot of the Beale function.
contour(
  x, y, log_z, 
  levels=100, 
  fill=true, 
  color=:batlowK50,
  tickfontsize=12, 
  guidefontsize=14, 
  colorbar_tickfontsize=12,
  colorbar_ticks=(min:step:max, [latexstring(
    if trunc(Int, i) == 0
      "\$1\$"
    else
      "\$10^{$(trunc(Int, i))}\$"
    end
  ) for i in min:step:max])
)
# Add a line contour plot over the filled contour.
contour!(x, y, log_z, levels=10, lw=1, color=:black, legend=false)
# Add a red dot to mark the global minimum of the Beale function.
scatter!([3], [0.5], color=:red, ms=6, legend=false)
# Add labels for the x and y axes.
xlabel!(L"$x$")
ylabel!(L"$y$")
# Display the plot and save it to a PNG file.
display(plot!())
png("img/test_functions/beale_contour.png")

println("Creating surface plot...")
# Create a surface plot of the Beale function.
surface(
  x, y, log_z, 
  color=:batlowK50, 
  colorbar=false, 
  tickfontsize=12, 
  guidefontsize=14, 
  zticks=ticks=(min:step:max, [latexstring(
    if trunc(Int, i) == 0
      "\$1\$"
    else
      "\$10^{$(trunc(Int, i))}\$"
    end
  ) for i in min:step:max])
)
# Add labels for the x, y, and z axes.
xlabel!(L"$x$")
ylabel!(L"$y$")
# Display the plot and save it to a PNG file.
display(plot!())
png("img/test_functions/beale_surface.png")
