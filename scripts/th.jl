using Plots; pythonplot()
using LaTeXStrings

# A([+ - * / sin cos exp log]) = [2 2 2 2 1 1 1]
arities = [2 2 2 2 1 1 2]
# |T| = |[x 1 2 3 4 5 6 7]| = 8
terminals_size = 8

"""
    t_leq(h)

Calculates the total number of trees of height less or equal to `h`.
"""
function t_leq(h::Int)::Int128
  if h == 0
    return terminals_size
  else
    c_sum = terminals_size
    for i = 0:h - 1
      c_sum = c_sum + sum(t(i) .^ arities)
    end
    return c_sum
  end
end
  
"""
    t(h)

Calculates the total number of trees of height `h`.
"""
function t(h::Int)::Int128
  if h == 0
    terminals_size
  else
    sum(t(h - 1) .^ arities) 
  end
end

x = 1:5
y = @. t_leq(x)
println(y)
plot(x, y, lw=2, legend=false, yaxis=:log)
xlabel!(L"$h$")
ylabel!(L"$|T_{\leq h}|$")
# png("img/theoretical_framework/t_leq.png")
# res = t_leq(5)
# println(res)
# clipboard("$res")