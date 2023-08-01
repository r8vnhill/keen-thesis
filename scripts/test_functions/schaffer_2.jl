include("../commons/draw.jl")

schaffer_2(x::Number, y::Number)::Number = 
  0.5 + (sin(x^2 - y^2)^2 - 0.5) / (1 + 0.001 * (x^2 + y^2))^2

draw(
  f = schaffer_2,
  minima = [0 => 0],
  name = "schaffer_2",
)

draw(
  f = schaffer_2,
  minima = [0 => 0],
  name = "schaffer_2_closeup",
  x_range = -30 => 30,
  y_range = -30 => 30,
)