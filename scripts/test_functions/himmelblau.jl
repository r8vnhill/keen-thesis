using Plots; pythonplot()
using LaTeXStrings

function himmelblau(x::Float64, y::Float64)::Float64
    return (x^2 + y - 11)^2 + (x + y^2 - 7)^2
end

x = range(-5, 5, length=100)
y = range(-5, 5, length=100)
log_z = @. log(himmelblau(x', y))

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
scatter!(
  [3, -2.805118, -3.779310, 3.584428], 
  [2, 3.131312, -3.283186, -1.848126], 
  color=:red, 
  ms=6, 
  legend=false
)
xlabel!(L"$x$")
ylabel!(L"$y$")
display(plot!())
png("img/test_functions/himmelblau_contour.png")

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
png("img/test_functions/himmelblau_surface.png")