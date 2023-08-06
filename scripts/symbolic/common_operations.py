# file: common_operations.py
from commons import debug
from latex import Caption, Position, bold
from latex.tables import Table, Tabular, Row, Cell
from symbolic.population import Population


def create_population_table(population: Population, caption_text: str,
                            label: str) -> Table:
    tab = Table(
        Tabular(
            Row(Cell(bold("Generation 1"), length=3), bottom_rules=2),
            Row(bold("Individual"), bold("Program"), bold("Fitness"), bottom_rules=1),
            *[Row(i.name, i.value.latex, i.fitness) for i in population],
            alignment="c|c|r",
        ),
        caption=Caption(caption_text, label),
        position=[Position.HERE, Position.TOP, Position.STRICT]
    )
    debug(f"Population:\n{tab}", __name__)
    return tab


def create_population_summary(population: Population, caption_text: str,
                              label: str) -> Table:
    tab = Table(
        Tabular(
            Row("", bold("Fitness"), bold("Individual"), top_rules=1, bottom_rules=1),
            Row("Best", population[3].fitness, population[3].name),
            Row("Worst", population[2].fitness, population[2].name),
            Row("Average",
                Cell(population.average_fitness, alignment="r|", length=2),
                top_rules=2),
            Row("Standard deviation",
                Cell(population.stddev_fitness, alignment="r|", length=2),
                bottom_rules=1, top_rules=1),
            alignment="|c|r|c|",
        ),
        caption=Caption(caption_text, label),
        position=[Position.FORCE_HERE]
    )
    debug(f"Population summary:\n{tab}", __name__)
    return tab
