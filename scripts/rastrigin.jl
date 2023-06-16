using Plots; pythonplot()
using LaTeXStrings

A = 10
f(x_1, x_2) = 2A + x_1^2 - A * cos(2π * x_1) + x_2^2 - A * cos(2π*x_2)

x_1 = range(-5.12, 5.12, length=100)
x_2 = range(-5.12, 5.12, length=50)
z = @. f(x_1', x_2)

contour(x_1, x_2, f, levels=20, lw=1, fill=true, color=:batlowK50)
xlabel!(L"$x_1$")
ylabel!(L"$x_2$")
png("img/test_functions/rastrigin_contour.png")

surface(x_1, x_2, z, color=:batlowK50)
xlabel!(L"$x_1$")
ylabel!(L"$x_2$")
zlabel!(L"$f(x)$")
png("img/test_functions/rastrigin_surface.png")