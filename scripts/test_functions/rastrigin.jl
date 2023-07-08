using Plots; pythonplot()
using LaTeXStrings

A = 10
function rastrigin(x::Float64, y::Float64)::Float64
  return 2A + x^2 - A * cos(2π * x) + y^2 - A * cos(2π * y)
end
  

x = range(-5.12, 5.12, length=100)
y = range(-5.12, 5.12, length=100)
z = @. rastrigin(x', y)

println("Creating contour plot...")
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
scatter!([0], [0], color=:red, ms=6, legend=false)
xlabel!(L"$x$")
ylabel!(L"$y$")
display(plot!())
png("img/test_functions/rastrigin_contour.png")

println("Creating surface plot...")
surface(
  x, y, z, 
  color=:batlowK50,
  colorbar=false, 
  tickfontsize=12, 
  guidefontsize=14
)
xlabel!(L"$x$")
ylabel!(L"$y$")
zlabel!(L"$f(x)$")
display(plot!())
png("img/test_functions/rastrigin_surface.png")