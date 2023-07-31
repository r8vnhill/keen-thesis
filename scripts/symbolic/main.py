import logging
from math import sin

import coloredlogs  # type: ignore

from commons import info, draw_lines, Line, LineStyle, IMG_DIR
from latex import math
from symbolic.functions import Function
from symbolic.initialization import create_population, draw_population
from symbolic.population import Individual, concat
from symbolic.samples import create_samples
from symbolic.selection import save_probabilities


def target_function(x: float) -> float:
    return 5 * x ** 3 - 2 * x ** 2 + sin(x) - 7


if __name__ == "__main__":
    logging.getLogger("matplotlib").setLevel(logging.WARNING)
    coloredlogs.install(logging.DEBUG)
    TARGET = Individual(math("f(x)"), Function("", "", target_function, 0), 0)
    SAMPLES = create_samples(target_function)
    info(f"Samples: {SAMPLES}", "symbolic")
    POPULATION = create_population(SAMPLES)
    draw_population(concat(TARGET, POPULATION.individuals),
                    x_limits=(-5, 5),
                    graph_title="Individuals of the population after initialization",
                    file_path=IMG_DIR / "theoretical_framework" / "gp_pop_init.png")
    info(f"Population: {POPULATION}", "symbolic")
    SUM_OF_FITNESSES = sum([i.fitness for i in POPULATION])
    info(f"Sum of fitnesses: {SUM_OF_FITNESSES}", "symbolic")
    CORRECTED_POPULATION = POPULATION.map(
        lambda i: Individual(i.name, i.value, SUM_OF_FITNESSES - i.fitness)
    )
    info(f"Corrected population: {CORRECTED_POPULATION}", "symbolic")
    save_probabilities(CORRECTED_POPULATION)
    AVERAGE_INITIAL_FITNESS = POPULATION.average_fitness
    info(f"Average initial fitness: {AVERAGE_INITIAL_FITNESS}", "symbolic")
    STDDEV_INITIAL_FITNESS = POPULATION.stddev_fitness
    info(f"Standard deviation of initial fitness: {STDDEV_INITIAL_FITNESS}", "symbolic")
    SURVIVORS: list[Individual[Function]] = [
        POPULATION.individuals[1],
        POPULATION.individuals[2]
    ]
    draw_population(concat(TARGET, SURVIVORS),
                    x_limits=(-1, 1),
                    graph_title="Survivors of the population and the target function",
                    file_path=IMG_DIR / "theoretical_framework"
                              / "gp_pop_sel_survivors.png")
