using Plots; pythonplot()
using LaTeXStrings

f(x) = 5x^3 - 2x^2 + sin(x) - 7

# 10 random points in the interval x = [-1, 1]
xs = sort(rand(10) * 2 .- 1)
ys = f.(xs)

# Plot the function
plot(f, -1, 1, label="f(x)", lw=2)
plot!(xs, ys, seriestype=:scatter, label="data")
xlabel!(L"x")
ylabel!(L"f(x)")
title!(L"f(x) = 5x^3 - 2x^2 + \sin(x) - 7")


png("img/theoretical_framework/symbolic.png")

# Save the points to a file
open("data.txt", "w") do io
    for (x, y) in zip(xs, ys)
        println(io, "f($x) = $y")
    end
end