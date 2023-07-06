using Plots; pythonplot()
using LaTeXStrings

beale(x::Real, y::Real) = (1.5 - x + x * y)^2 + (2.25 - x + x * y^2)^2 + (2.625 - x + x * y^3)^2


x = range(-4.5, 4.5, length=100)
y = range(-4.5, 4.5, length=100)
z = @. beale(x', y)

contour(x, y, log.(z), levels=100, lw=2, fill=true, color=:batlowK50)
xlabel!(L"$x$")
ylabel!(L"$y$")
# png("img/test_functions/ackley_contour.png")

surface(x, y, log.(z), color=:batlowK50)
xlabel!(L"$x$")
ylabel!(L"$y$")
zlabel!(L"$f(x, y)$")
# png("img/test_functions/ackley_surface.png")