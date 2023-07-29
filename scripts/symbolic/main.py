import logging
from math import sin

import coloredlogs  # type: ignore
import numpy as np

from commons import info
from symbolic.initialization import create_population
from symbolic.population import Individual
from symbolic.samples import create_samples
from symbolic.selection import save_probabilities


def target_function(x: float) -> float:
    return 5 * x**3 - 2 * x**2 + sin(x) - 7


if __name__ == "__main__":
    coloredlogs.install(logging.DEBUG)
    SAMPLES = create_samples(target_function)
    info(f"Samples: {SAMPLES}", "symbolic")
    POPULATION = create_population(SAMPLES)
    info(f"Population: {POPULATION}", "symbolic")
    SUM_OF_FITNESSES = sum([i.fitness for i in POPULATION])
    info(f"Sum of fitnesses: {SUM_OF_FITNESSES}", "symbolic")
    CORRECTED_POPULATION = POPULATION.map(
        lambda i: Individual(i.name, i.value, SUM_OF_FITNESSES - i.fitness)
    )
    info(f"Corrected population: {CORRECTED_POPULATION}", "symbolic")
    save_probabilities(CORRECTED_POPULATION)
    observed = np.array([i.value for i in POPULATION])
