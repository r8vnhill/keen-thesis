using Plots; pythonplot()
using LaTeXStrings

f(x, y) = -20 * exp(-0.2 * sqrt(0.5 * (x^2 + y^2))) - exp(0.5 * (cos(2π * x) + cos(2π * y))) + exp(1) + 20

x = range(-5, 5, length=100)
y = range(-5, 5, length=100)
z = @. f(x', y)

contour(x, y, f, levels=20, lw=1, fill=true, color=:batlowK50)
xlabel!(L"$x$")
ylabel!(L"$y$")
png("img/test_functions/ackley_contour.png")

surface(x, y, z, color=:batlowK50)
xlabel!(L"$x$")
ylabel!(L"$y$")
zlabel!(L"$f(x, y)$")
png("img/test_functions/ackley_surface.png")