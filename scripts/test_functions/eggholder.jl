using Plots
using LaTeXStrings
include("../commons/draw.jl")

eggholder(x::Number, y::Number)::Number = 
  -(y + 47) * sin(sqrt(abs(x / 2 + (y + 47)))) - x * sin(sqrt(abs(x - (y + 47))))

draw(
  x_range = -512 => 512,
  y_range = -512 => 512,
  f = eggholder,
  minima = [512 => 404.2319],
  name = "eggholder",
)