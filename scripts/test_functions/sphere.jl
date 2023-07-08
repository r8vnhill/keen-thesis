using Plots; pythonplot()
using LaTeXStrings

function sphere(x::Float64, y::Float64)
    return x^2 + y^2
end

x = range(-5, 5, length=100)
y = range(-5, 5, length=100)
z = @. sphere(x', y)

max = maximum(z)
min = minimum(z)
step = (max - min) / 8

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
png("img/test_functions/sphere_contour.png")

surface(
    x, y, z,
    color=:batlowK50,
    colorbar=false,
    tickfontsize=12, 
    guidefontsize=14
)
xlabel!(L"$x$")
ylabel!(L"$y$")
display(plot!())
png("img/test_functions/sphere_surface.png")