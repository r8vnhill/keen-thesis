include("../commons/draw.jl")

schaffer_4(x::Number, y::Number)::Number = 
  0.5 + (cos(sin(abs(x^2 - y^2)))^2 - 0.5) / (1 + 0.001 * (x^2 + y^2))^2

draw(
  f = schaffer_4,
  minima = [0 => 1.25313, 0 => -1.25313, 1.25313 => 0, -1.25313 => 0],
  name = "schaffer_4",
)

draw(
  f = schaffer_4,
  minima = [0 => 1.25313, 0 => -1.25313, 1.25313 => 0, -1.25313 => 0],
  name = "schaffer_4_closeup",
  x_range = -15 => 15,
  y_range = -15 => 15,
)