using Plots; pythonplot()
using LaTeXStrings
using ColorSchemes

"""
    _draw_contour(x, y, z, min, filename)

Draws and saves a contour plot with the provided parameters.

  This function creates a filled contour plot using the provided x and y arrays, 
  and a z matrix.
  It also overlays an additional contour plot with fewer levels and a scatter plot
  representing the minimum points.pip
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
  - `log_scale` - A Bool indicating whether the z-axis should be displayed in
    logarithmic scale.

# Returns
  A String representing the name of the PNG file where the plot was saved.
"""
function _draw_contour(
  xs::AbstractVector{<:Number},
  ys::AbstractVector{<:Number},
  zss::Matrix{<:Number},
  minima::Pair{<:AbstractVector{<:Number}, <:AbstractVector{<:Number}},
  name::String,
  log_scale::Bool=false
)::String
  println("Drawing contour plot for $name...")
  if log_scale
    max_z = maximum(zss)
    min_z = minimum(zss)
    step = (max_z - min_z) / 4

    contour(
      xs, ys, zss, 
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
      xs, ys, zss,
      levels=100,
      fill=true,
      color=:batlowK50,
      tickfontsize=12,
      guidefontsize=14,
      colorbar_tickfontsize=12
    )
  end
  contour!(
    xs, ys, zss,
    levels = 10,
    lw = 0.5,
    color = cgrad(:phase, rev = true),
    alpha = 0.8,
    legend = false
  )
  scatter!(minima...,color = :red, ms = 6, legend = false)
  xlabel!(L"$x$")
  ylabel!(L"$y$")
  display(plot!())
  png("img/test_functions/$(name)_contour.png")  
end

"""
    _draw_surface(x, y, z, filename)

Draws and saves a surface plot with the provided parameters.

  This function creates a surface plot using the provided x and y arrays, and a z
  matrix.
  The plot is then displayed and saved as a PNG file.

# Arguments
  - `x` - A 1D array of Float64 representing the x-coordinates for the surface 
    plot.
  - `y` - A 1D array of Float64 representing the y-coordinates for the surface
    plot.
  - `z` - A 2D matrix of Float64 representing the z-coordinates for the surface
    plot.
  - `filename` - A String representing the name of the PNG file where the plot
    will be saved.
  - `log_scale` - A Bool indicating whether the z-axis should be displayed in
    logarithmic scale.

# Returns
  A String representing the name of the PNG file where the plot was saved.
"""
function _draw_surface(
  xs::AbstractVector{<:Number},
  ys::AbstractVector{<:Number},
  zss::Matrix{<:Number},
  name::String,
  log_scale::Bool=false
)::String
  println("Drawing surface plot for $name...")
  if log_scale
    max_z = maximum(zss)
    min_z = minimum(zss)
    step = (max_z - min_z) / 4
    surface(
      xs, ys, zss, 
      color=:batlowK50,
      colorbar=false, 
      tickfontsize=12, 
      guidefontsize=14,
      zticks=(min_z:step:max_z, [latexstring(
        if trunc(Int, i) == 0
          "\$1\$"
        else
          "\$10^{$(trunc(Int, i))}\$"
        end
      ) for i in min_z:step:max_z]),
      linealpha = 1,
      fillalpha = 0.8
    )
  else
    surface(
      xs, ys, zss,
      color=:batlowK50,
      colorbar=false,
      tickfontsize=12,
      guidefontsize=14,
      linealpha = 1,
      fillalpha = 0.8
    )
  end
  xlabel!(L"$x$")
  ylabel!(L"$y$")
  display(plot!())
  png("img/test_functions/$(name)_surface.png")
end

"""
    draw(;
      x_range::Pair{<:Number, <:Number} = -100 => 100,
      y_range::Pair{<:Number, <:Number} = -100 => 100,
      granularity::Number = 0.01,
      f::Function,
      minima::Pair{<:AbstractVector{<:Number}, <:AbstractVector{<:Number}},
      name::String,
      log_scale::Bool = false,
    )::Vector{String}

Generates contour and surface plots for a given function `f` over specified `x_range` 
and `y_range`. The plots are produced at a defined granularity level. Additionally, the function
accepts the coordinates of minima for visualization. The produced plots can be in a logarithmic 
scale if `log_scale` is true.

# Arguments
- `x_range::Pair{<:Number, <:Number} = -100 => 100`: The range of x-values for which the 
  function `f` should be evaluated.
- `y_range::Pair{<:Number, <:Number} = -100 => 100`: The range of y-values for which the 
  function `f` should be evaluated.
- `granularity::Number = 0.01`: The relative distance between consecutive points for which `f` is 
  evaluated, i.e., a granularity of 0.01 signifies that the x and y axis would have a length of 100 
  points.
- `f::Function`: The function to be plotted.
- `minima::Pair{<:AbstractVector{<:Number}, <:AbstractVector{<:Number}}`: The coordinates of the 
  minima to be marked on the plot.
- `name::String`: The name of the function `f` to be included in the plot title.
- `log_scale::Bool = false`: Boolean flag to determine if the z-values of the plot should be in 
  logarithmic scale.

# Returns
- A vector of filenames where the contour and surface plots are saved.
"""
function draw(;
  x_range::Pair{<:Number, <:Number} = -100 => 100,
  y_range::Pair{<:Number, <:Number} = -100 => 100,
  granularity::Number = 0.01,
  f::Function,
  minima::Pair{<:AbstractVector{<:Number}, <:AbstractVector{<:Number}},
  name::String,
  log_scale::Bool = false,
)::Vector{String}
  # Define the x and y ranges based on the granularity
  xs = range(x_range..., length = trunc(Int, 1 / granularity))
  ys = range(y_range..., length = trunc(Int, 1 / granularity))

  # Calculate the z-values for the function f over the x and y ranges
  zss = @. if log_scale
    log(f(xs', ys))  # If log_scale is true, take the log of the z-values
  else
    f(xs', ys)  # If log_scale is false, use the z-values as they are
  end

  # Return a vector of filenames generated by the _draw_contour and 
  # _draw_surface functions
  [_draw_contour(xs, ys, zss, minima, name, log_scale)
  _draw_surface(xs, ys, zss, name, log_scale)]
end
