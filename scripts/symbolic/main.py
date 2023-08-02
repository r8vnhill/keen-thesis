import logging
from math import sin

import coloredlogs  # type: ignore

from commons import IMG_DIR, debug
from latex import math
from symbolic.functions import Function
from symbolic.initialization import plot_population, initialize_population
from symbolic.mse import mse
from symbolic.population import Individual, concat, Population
from symbolic.samples import create_samples, Sample
from symbolic.selection import calculate_probabilities, select_survivors


def target_function(x: float) -> float:
    """A target function for calculating a mathematical expression."""
    return 5 * x**3 - 2 * x**2 + sin(x) - 7


def create_target_individual() -> Individual[Function]:
    """Creates an individual representing the target function."""
    return Individual(math("f(x)"), Function(python=target_function), 0)


def crossover(
    survivors: list[Individual[Function]], samples: list[Sample]
) -> Population[Function]:
    crossed_fns = [
        Function(latex=math(r"5 \cdot 7"), python=lambda _: 5 * 7),
        Function(
            latex=math(r"x^2 - (5 + \sin(x))"), python=lambda x: x**2 - (5 + sin(x))
        ),
    ]
    crossed_individuals = [
        survivors[0],
        survivors[1],
        Individual(
            math("O_1"),
            crossed_fns[0],
            mse([crossed_fns[0](x) for x, _ in samples], [x for _, x in samples]),
        ),
        Individual(
            math("O_2"),
            crossed_fns[1],
            mse([crossed_fns[1](x) for x, _ in samples], [x for _, x in samples]),
        ),
    ]
    debug(crossed_individuals)
    logging.info(f"Crossed individuals: {crossed_individuals}")
    crossed_population = Population(crossed_individuals)

    return Population(crossed_individuals)


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
