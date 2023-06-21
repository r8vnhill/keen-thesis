using Plots; pythonplot()
using LaTeXStrings
using Statistics

function mse(observed::Vector{Float64}, prediction::Vector{Float64})
  return sum((observed - prediction).^2) / length(observed)
end

xs = [
  -0.889160069272859
  -0.8561029711395651
  -0.8212951850355155
  -0.8181934125983823
  -0.4298586689110253
  -0.3523275114715019
  -0.0357759083395397
  0.017449673577553337
  0.5290096774879465
  0.8211010511234629
]

f(x) = 5x^3 - 2x^2 + sin(x) - 7
I_1(_) = 3 / sin(2) * 5^3
I_2(x) = 7 - (5 + sin(x))
I_3(_) = 7.0 + 2
I_4(x) = 5 * x.^2

plot(f, label=L"$f(x)$", lw=2)
plot!(I_1, label=L"$I_1(x)$", lw=1)
plot!(I_2, label=L"$I_2(x)$", lw=2, ls=:dot)
plot!(I_3, label=L"$I_3(x)$", lw=2, ls=:dashdot)
plot!(I_4, label=L"$I_4(x)$", lw=2, ls=:dash)
title!("Individuals of the population and the target function")
xlabel!(L"$x$")
ylabel!(L"$f(x)$")

png("img/theoretical_framework/gp_pop_1.png")

open("mse_1.txt", "w") do io
  println(io, "mse(f(x), I_1(x)) = ", mse(f.(xs), I_1.(xs)))
  println(io, "mse(f(x), I_2(x)) = ", mse(f.(xs), I_2.(xs)))
  println(io, "mse(f(x), I_3(x)) = ", mse(f.(xs), I_3.(xs)))
  println(io, "mse(f(x), I_4(x)) = ", mse(f.(xs), I_4.(xs)))
  println(io, "average = ", (mse(f.(xs), I_1.(xs)) + mse(f.(xs), I_2.(xs)) + mse(f.(xs), I_3.(xs)) + mse(f.(xs), I_4.(xs))) / 4)
  println(io, "std = ", std([mse(f.(xs), I_1.(xs)), mse(f.(xs), I_2.(xs)), mse(f.(xs), I_3.(xs)), mse(f.(xs), I_4.(xs))]))
end
