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

max = maximum(log_z)
min = minimum(log_z)
step = (max - min) / 4

println("Creating contour plot...")
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
contour!(x, y, log_z, levels=10, lw=1, color=:black, legend=false)
scatter!([1], [1], color=:red, ms=6, legend=false)
xlabel!(L"$x$")
ylabel!(L"$y$")
display(plot!())
png("img/test_functions/rosenbrock_contour.png")

println("Creating surface plot...")
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
xlabel!(L"$x$")
ylabel!(L"$y$")
display(plot!())
png("img/test_functions/rosenbrock_surface.png")