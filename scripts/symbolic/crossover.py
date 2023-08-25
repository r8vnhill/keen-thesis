from math import sin

from commons import debug, CONTENTS_DIR
from latex import bold, Position, Caption, math
from latex.tables import Table, Tabular, Cell, Row
from symbolic.functions import Function
from symbolic.mse import mse, function_mse
from symbolic.population import Population, Individual, concat
from symbolic.samples import Sample

CROSSOVER_PATH = CONTENTS_DIR / "Theoretical_Background" / "GP" / "variation" / "crossover"


def _create_population_table(crossed_population: Population[Function]) -> Table:
    tab = Table(
        Tabular(
            Row(Cell(bold("Generation 1"), length=3), bottom_rules=2),
            Row(bold("Individual"), bold("Program"), bold("Fitness"), bottom_rules=1),
            *[Row(i.name, i.value.latex, i.fitness) for i in crossed_population],
            alignment="c|c|r",
        ),
        caption=Caption("Population after applying the subtree crossover operator.",
                        label="tab:bg:gp:variation:cx:subtree:fitness"),
        position=[Position.HERE, Position.TOP, Position.STRICT]
    )
    debug(f"Crossed population:\n{tab}", __name__)
    return tab


def _create_population_summary(crossed_population: Population[Function]) -> Table:
    tab = Table(
        Tabular(
            Row("", bold("Fitness"), bold("Individual"), top_rules=1, bottom_rules=1),
            Row("Best", crossed_population[3].fitness, crossed_population[3].name),
            Row("Worst", crossed_population[2].fitness, crossed_population[2].name),
            Row("Average",
                Cell(crossed_population.average_fitness, alignment="r|", length=2),
                top_rules=2),
            Row("Standard deviation",
                Cell(crossed_population.stddev_fitness, alignment="r|", length=2),
                bottom_rules=1, top_rules=1),
            alignment="|c|r|c|",
        ),
        caption=Caption(
            "Fitness summary of the population after applying the subtree crossover "
            "operator.",
            label="tab:bg:gp:variation:cx:subtree:fitness:summary"),
        position=[Position.FORCE_HERE]
    )
    debug(f"Population summary:\n{tab}", __name__)
    return tab


def crossover(survivors: Population[Function], samples: list[Sample]) \
        -> Population[Function]:
    """
    Performs crossover on the provided survivors and samples to create a new population.
    """

    # Define the crossed functions
    crossed_fns = [
        Function(latex=math(r"5 \cdot 7"), python=lambda _: 5 * 7),
        Function(latex=math(r"x^2 - (5 + \sin(x))"),
                 python=lambda x: x ** 2 - (5 + sin(x)))
    ]

    # Create crossed individuals based on the crossed functions
    crossed_population = concat(survivors,
                                Individual(math(r"\mathbf{O}_1(x)"), crossed_fns[0],
                                           function_mse(crossed_fns[0], samples)),
                                Individual(math(r"\mathbf{O}_2(x)"), crossed_fns[1],
                                           function_mse(crossed_fns[1], samples)))

    # Debugging log
    debug(f"Crossed individuals: {crossed_population}", __name__)

    # Create and save tables
    table = _create_population_table(crossed_population)
    table.save(CROSSOVER_PATH / "tab-bg-gp-variation-crossover-subtree-fitness.tex")

    summary = _create_population_summary(crossed_population)
    summary.save(
        CROSSOVER_PATH / "tab-bg-gp-variation-crossover-subtree-fitness-summary.tex")

    return crossed_population
