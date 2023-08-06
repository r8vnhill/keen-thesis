from numpy import cos

from commons import debug, CONTENTS_DIR
from latex import math, bold, Caption, Position
from latex.tables import Table, Tabular, Row, Cell
from symbolic.common_operations import create_population_table, create_population_summary
from symbolic.functions import Function
from symbolic.mse import function_mse
from symbolic.population import Population, Individual
from symbolic.samples import Sample

MUTATION_PATH = CONTENTS_DIR / "Theoretical_Background" / "GP" / "variation" / "mutation"


def _create_population_table(mutated_population: Population[Function]):
    tab = Table(
        Tabular(
            Row(Cell(bold("Generation 1"), length=3), bottom_rules=2),
            Row(bold("Individual"), bold("Program"), bold("Fitness"), bottom_rules=1),
            *[Row(i.name, i.value.latex, i.fitness) for i in mutated_population],
            alignment="c|c|r",
        ),
        caption=Caption("Population after applying the node mutation operator.",
                        label="tab:bg:gp:variation:mutation:node:fitness"),
        position=[Position.HERE, Position.TOP, Position.STRICT]
    )
    debug(f"Crossed population:\n{tab}", __name__)
    return tab


def _create_population_summary(mutated_population):
    tab = Table(
        Tabular(
            Row("", bold("Fitness"), bold("Individual"), top_rules=1, bottom_rules=1),
            Row("Best", mutated_population[3].fitness, mutated_population[3].name),
            Row("Worst", mutated_population[2].fitness, mutated_population[2].name),
            Row("Average",
                Cell(mutated_population.average_fitness, alignment="r|", length=2),
                top_rules=2),
            Row("Standard deviation",
                Cell(mutated_population.stddev_fitness, alignment="r|", length=2),
                bottom_rules=1, top_rules=1),
            alignment="|c|r|c|",
        ),
        caption=Caption(
            "Fitness summary of the population after applying the node mutation "
            "operator.",
            label="tab:bg:gp:variation:mutation:node:fitness:summary"),
        position=[Position.FORCE_HERE]
    )
    debug(f"Population summary:\n{tab}", __name__)
    return tab


def mutate(crossed_population: Population[Function], samples: list[Sample]):
    mutated_fns = [
        Function(latex=math(r"7 - (5 + \cos(x))"), python=lambda x: 7 - (5 + cos(x))),
        Function(latex=math("6 + 2"), python=lambda _: 6 + 2),
        Function(latex=math(r"6 \cdot 7"), python=lambda _: 6 * 7),
        Function(latex=math(r"x^3 - (5 + \sin(x))"),
                 python=lambda x: x ** 3 - (5 + cos(x))),
    ]
    debug(f"Mutated functions:\n{mutated_fns}", __name__)
    mutated_population = Population(
        [Individual[Function](math(f"M({i.name}"), f, function_mse(f, samples)) for i, f
         in zip(crossed_population, mutated_fns)])
    debug(f"Mutated population:\n{mutated_population}", __name__)
    table = create_population_table(
        mutated_population,
        "Population after applying the node mutation operator.",
        "tab:bg:gp:variation:mutation:node:fitness")

    summary = create_population_summary(
        mutated_population,
        "Fitness summary of the population after applying the node mutation "
        "operator.",
        "tab:bg:gp:variation:mutation:node:fitness:summary")
    table.save(MUTATION_PATH / "tab-bg-gp-variation-mutation-node-fitness.tex")
    summary.save(MUTATION_PATH / "tab-bg-gp-variation-mutation-node-fitness-summary.tex")
    return mutated_population
