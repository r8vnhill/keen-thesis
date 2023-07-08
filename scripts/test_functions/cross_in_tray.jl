using Plots; pythonplot()
using LaTeXStrings

function cross_in_tray(x::Float64, y::Float64)::Float64
    return -0.0001 * (abs(sin(x) * sin(y) * exp(abs(100 - sqrt(x^2 + y^2) / pi))) + 1)^0.1
end

x = range(-10, 10, length=100)
y = range(-10, 10, length=100)
log_z = @. log(cross_in_tray(x', y))

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
png("img/test_functions/cross_in_tray_contour.png")

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
png("img/test_functions/cross_in_tray_surface.png")