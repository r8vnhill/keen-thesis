"""
    draw_contour(x, y, z, min, filename)

Draws and saves a contour plot with the provided parameters.

This function creates a filled contour plot using the provided x and y arrays, 
and a z matrix.
It also overlays an additional contour plot with fewer levels and a scatter plot
representing the minimum points.
The plot is then displayed and saved as a PNG file.

# Arguments
- `x` - A 1D array of Float64 representing the x-coordinates for the contour 
  plot.
- `y` - A 1D array of Float64 representing the y-coordinates for the contour
  plot.
- `z` - A 2D matrix of Float64 representing the z-coordinates for the contour
  plot.
- `min` - A 2D matrix of Float64 representing the minimum points to be
  highlighted on the plot.
- `filename` - A String representing the name of the PNG file where the plot
  will be saved.
"""
function draw_contour(
  x,
  y,
  z,
  min,
  filename,
  log_scale::Bool=false
)::String
  if log_scale
    max_z = maximum(z)
    min_z = minimum(z)
    step = (max_z - min_z) / 4

    contour(
      x, y, z, 
      levels=100, 
      fill=true, 
      color=:batlowK50,
      tickfontsize=12, 
      guidefontsize=14, 
      colorbar_tickfontsize=12,
      colorbar_ticks=(min_z:step:max_z, [latexstring(
        if trunc(Int, i) == 0
          "\$1\$"
        else
          "\$10^{$(trunc(Int, i))}\$"
        end
      ) for i in min_z:step:max_z])
    )
  else
    contour(
      x, y, z,
      levels=100,
      fill=true,
      color=:batlowK50,
      tickfontsize=12,
      guidefontsize=14,
      colorbar_tickfontsize=12
    )
  end
  contour!(x, y, z, levels=10, lw=1, color=:black, legend=false)
  scatter!(
    min[1, :],
    min[2, :], 
    color=:red, 
    ms=6, 
    legend=false
  )
  xlabel!(L"$x$")
  ylabel!(L"$y$")
  display(plot!())
  png(filename)  
end

function draw_surface(x, y, z, filename::String)
  surface(
    x, y, z,
    color=:batlowK50,
    colorbar=false,
    tickfontsize=12,
    guidefontsize=14
  )
  xlabel!(L"$x$")
  ylabel!(L"$y$")
  display(plot!())
  png(filename)
end