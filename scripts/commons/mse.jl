"""
    mse(observed::Vector{<:Number}, prediction::Vector{<:Number})::Number

Calculate the mean squared error between the observed and the predicted values.

# Arguments
- `observed::Vector{<:Number}`: the observed values
- `prediction::Vector{<:Number}`: the predicted values

# Returns
- The calculated mean squared error as a Number.
"""
mse(observed::Vector{<:Number}, prediction::AbstractVector{<:Number})::Number =
  sum((observed .- prediction).^2) / length(observed)