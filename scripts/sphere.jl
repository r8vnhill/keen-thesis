using Plots; pythonplot()
using LaTeXStrings

function sphere(x::Float64, y::Float64)
    return x^2 + y^2
end

x = range(-5, 5, length=100)
y = range(-5, 5, length=100)
z = @. sphere(x', y)

contour(x, y, z, levels=20, lw=1, fill=true, color=:batlowK50)
xlabel!(L"$x$")
ylabel!(L"$y$")
png("img/test_functions/sphere_contour.png")

surface(x, y, z, color=:batlowK50)
xlabel!(L"$x$")
ylabel!(L"$y$")
zlabel!(L"$f(x, y)$")
png("img/test_functions/sphere_surface.png")