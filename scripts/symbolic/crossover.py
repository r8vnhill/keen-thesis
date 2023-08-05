from math import sin

from commons import debug
from latex import math, bold
from latex.tables import Table, Tabular, Cell, Row
from symbolic.functions import Function
from symbolic.mse import mse
from symbolic.population import Population, Individual
from symbolic.samples import Sample


def crossover(
    survivors: Population[Function], samples: list[Sample]
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
    debug(str(crossed_individuals), __name__)
    crossed_population = Population(crossed_individuals)
    tab = Table(
        Tabular(
            Row(Cell(bold("Generation 1"), length=3), bottom_rules=2),
            Row(bold("Individual"), bold("Program"), bold("Fitness"), bottom_rules=1),
            *[Row(x) for x in crossed_population],
            alignment="c|c|r",
        )
    )
    debug(str(tab), __name__)
    return Population(crossed_individuals)
