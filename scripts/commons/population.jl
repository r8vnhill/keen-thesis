import Base: map

"""
    struct Individual

A data structure representing an individual in a population.

This structure holds the name and the fitness ϕ of an individual.

# Fields
- `name`: A string representing the name of the individual.
- `ϕ`: A number representing the fitness of the individual.
"""
struct Individual{T}
  value::T
  name::String
  ϕ::Number
end

"""
    Base.show(io::IO, ind::Individual)
    
Print an individual to the given IO stream.

# Arguments
- `io`: The IO stream to which the individual will be printed.
- `ind`: The individual to be printed.
"""
function Base.show(io::IO, ind::Individual)::Nothing
  print(io, "Individual($(ind.name), $(ind.ϕ))")
end

"""
    struct Population

A data structure representing a population in a genetic algorithm.

  This structure holds the fitness values of each individual in a population.

# Fields
  - `individuals`: A vector of `Individual` objects representing the individuals in the population.
"""
struct Population{T}
  individuals::Vector{Individual{T}}
end

function Base.show(io::IO, mime::MIME"text/plain", pop::Population)::Nothing
  println(io, "Population(")
  join(io, map(individual -> indent(repr(mime, individual), 2), pop.individuals), ",\n")
  print(io, ")")
end

"""
    Φ(pop::Population)::Vector{Number}

Extract the fitness value for each individual in the population.

This function applies a map operation to the population's individuals to extract
  their fitness values (ϕ), and returns these values in a vector.

# Arguments
- `pop`: A `Population` object.

# Returns
- A vector containing the fitness values of all individuals in the population.
"""
function Φ(pop::Population)::Vector{Number}
  Base.map(individual -> individual.ϕ, pop.individuals)
end

"""
    average_fitness(pop::Population)::Number

Calculate the average fitness of a population.

# Arguments
  - `pop::Population`: the population

# Returns
  - The average fitness of the population as a Number.
"""
average_fitness(pop::Population)::Number = mean(Φ(pop))

"""
    stddev_fitness(pop::Population)::Number

Calculate the standard deviation of the fitness values of a population.

# Arguments
  - `pop::Population`: the population

# Returns
  - The standard deviation of the fitness values of the population as a Number.
"""
stddev_fitness(pop::Population)::Number = std(Φ(pop))

"""
    selection_probabilities(pop::Population)::Vector{Number}

Calculate the selection probabilities of a population.

# Arguments
  - `pop::Population`: the population

# Returns
  - A vector containing the selection probabilities of the population.
"""
selection_probabilities(pop::Population)::Vector{Number} = map(
  individual -> individual.ϕ / sum(Φ(pop)), 
  pop.individuals
)

"""
    save_population(pop::Population, filename::String)::Nothing

Save a population's individual parameters and statistics to a file.

  This function writes each individual's name and their corresponding ϕ parameter 
  to the specified file. It also computes and writes the average and standard 
  deviation of fitness in the population.

# Arguments
  - `pop`: A `Population` object whose data is to be saved.
  - `filename`: A string indicating the name (and optionally the path) of the file 
    where the data will be written. The file is created if it does not exist, and 
    overwritten if it does.

# Output
  This function returns `Nothing`.

# Side Effects
  This function creates or modifies a file in the file system.
"""
save_population(pop::Population, filename::String)::Nothing = open(filename, "w") do io
  header = ["Individual" "ϕ"]
  for individual in pop.individuals
    println(io, "ϕ(", individual.name, "(x)) = ", individual.ϕ)
    println(io, 
      "p($(individual.name)(x)) = ", 
      individual.ϕ / sum(map(individual -> individual.ϕ, pop.individuals))
    )
  end
  println(io, "average = ", average_fitness(pop))
  println(io, "std = ", stddev_fitness(pop))
end

"""
    map(f::Function, pop::Population)::Population

Apply a function to each individual in a population.

# Arguments
  - `f::Function`: the function to be applied to each individual in the population.
  - `pop::Population`: the population

# Returns
  - A new `Population` object with the results of applying `f` to each individual 
    in the population.
"""
map(transform::Function, pop::Population)::Population = 
  Population(map(individual -> transform(individual), pop.individuals))
