using Plots; pythonplot()
using LaTeXStrings

function goldstein_price(x::Float64, y::Float64)::Float64
    return (1 + (x + y + 1)^2 * (19 - 14x + 3x^2 - 14y + 6x * y + 3y^2)) * 
        (30 + (2x - 3y)^2 * (18 - 32x + 12x^2 + 48y - 36x * y + 27y^2))
end

x = range(-2, 2, length=100)
y = range(-2, 2, length=100)
log_z = @. log(goldstein_price(x', y))

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
scatter!([0], [-1], color=:red, ms=6, legend=false)
xlabel!(L"$x$")
ylabel!(L"$y$")
display(plot!())
png("img/test_functions/goldstein_price_contour.png")

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
png("img/test_functions/goldstein_price_surface.png")