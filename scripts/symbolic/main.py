import logging
from math import sin

import coloredlogs

from commons import info, IMG_DIR
from latex import math
from symbolic.crossover import crossover
from symbolic.functions import Function
from symbolic.initialization import initialize_population
from symbolic.mutation import mutate
from symbolic.population import Individual, plot_population, concat
from symbolic.samples import create_samples
from symbolic.selection import select_survivors


def target_function(x: float) -> float:
    """Return the value of the mathematical expression for the given x."""
    return 5 * x ** 3 - 2 * x ** 2 + sin(x) - 7


def create_target_individual() -> Individual[Function]:
    """Create and return an individual representing the target function."""
    return Individual(math("f(x)"), Function(python=target_function), 0)


def log_improvement(old_value: float, new_value: float, measure: str) -> None:
    """Log the percentage improvement from old_value to new_value."""
    improvement = (old_value - new_value) / old_value
    info(
        f"{measure} improvement: ({old_value} - {new_value}) / {old_value} = {improvement:.3%}",
        "symbolic")


def main() -> None:
    """
    Manage the initialization, selection, and crossover for the population of Individuals.
    """
    target_individual = create_target_individual()
    population, samples = initialize_population(target_individual,
                                                create_samples(target_function))
    survivors = select_survivors(population, target_individual)
    crossed_population = crossover(survivors, samples)
    log_improvement(population.average_fitness, crossed_population.average_fitness,
                    "Crossover average")
    log_improvement(population.stddev_fitness, crossed_population.stddev_fitness,
                    "Crossover std")
    mutated_population = mutate(crossed_population, samples)
    log_improvement(population.average_fitness, mutated_population.average_fitness,
                    "Mutation average")
    log_improvement(population.stddev_fitness, mutated_population.stddev_fitness,
                    "Mutation std")
    plot_population(
        concat(target_individual, mutated_population),
        x_limits=(-5, 5),
        graph_title="Individuals of the population after mutation",
        file_path=IMG_DIR / "theoretical_framework" / "gp_pop_mutated.png",
    )


if __name__ == "__main__":
    setup_logging()
    main()
