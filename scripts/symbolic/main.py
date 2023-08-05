import logging
from math import sin

import coloredlogs  # type: ignore

from latex import math
from symbolic.crossover import crossover
from symbolic.functions import Function
from symbolic.initialization import initialize_population
from symbolic.population import Individual
from symbolic.samples import create_samples
from symbolic.selection import select_survivors


def target_function(x: float) -> float:
    """A target function for calculating a mathematical expression."""
    return 5 * x**3 - 2 * x**2 + sin(x) - 7


def create_target_individual() -> Individual[Function]:
    """Creates an individual representing the target function."""
    return Individual(math("f(x)"), Function(python=target_function), 0)


def main() -> None:
    """Main function that initializes and manages the population of Individuals."""
    target_individual = create_target_individual()
    population, samples = initialize_population(
        target_individual, create_samples(target_function)
    )
    survivors = select_survivors(population, target_individual)

    crossed_individuals = crossover(survivors, samples)


if __name__ == "__main__":
    # Set logging level for matplotlib and install colored logs
    logging.getLogger("matplotlib").setLevel(logging.WARNING)
    coloredlogs.install(logging.DEBUG)
    main()
