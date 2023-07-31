from math import sin
from pathlib import Path

from commons import debug, CONTENTS_DIR, draw_lines, Line
from latex import math, bold, Caption, Position
from latex.tables import Table, Tabular, Row, Cell
from symbolic.functions import Function
from symbolic.mse import mse
from symbolic.population import Individual, Population
from symbolic.samples import Sample

INITIAL_FUNCTIONS: list[Function] = [
    Function(math(r"\mathbf{I}_1"), math(r"\frac{3}{\sin(2)} \cdot 5^3"),
             lambda _: 3 / sin(2) * 5 ** 3, 3),
    Function(math(r"\mathbf{I}_2"), math(r"7 - (5 + \sin(x))"),
             lambda x: 7 - (5 + sin(x)), 3),
    Function(math(r"\mathbf{I}_3"), math(r"7 + 2"), lambda _: 7 + 2, 1),
    Function(math(r"\mathbf{I}_4"), math(r"5x^2"), lambda x: 5 * x ** 2, 2),
]

INITIALIZATION_PATH = CONTENTS_DIR / "Theoretical_Background" / "GP" / "initialization"


def _create_individuals(fns: list[Function], samples: list[Sample]) -> list[
    Individual[Function]]:
    """
    Creates individuals for the initial population.

    :param fns: A list of Function instances. Each Function instance is treated as a distinct individual in the
                population.
    :param samples: A list of Sample instances. Each Sample instance is a pair (x, y) representing the inputs and
                    outputs for the Function instance.
    :return: A list of Individual instances representing the initial population.
    """
    return [
        Individual(
            math(f"{bold('I', True)}_{i + 1}(x)"),
            f,
            mse([f(x) for x, _ in samples], [s[1] for s in samples]),
        )
        for i, f in enumerate(fns)
    ]


def _log_population_stats(population: Population) -> None:
    """
    Logs statistics about the population.

    :param population: A Population object representing the initial population.
    """
    debug(f"Initial population: {population}", "symbolic")
    debug(
        f"Initial population average fitness: {population.average_fitness}", "symbolic"
    )
    debug(
        f"Initial population standard deviation of fitness: {population.stddev_fitness}",
        "symbolic",
    )


def _create_population_table(population: Population) -> Table:
    """
    Creates a LaTeX table for the initial population.

    :param population: A Population object representing the initial population.

    :return: A Table object representing the LaTeX table of the initial population.
    """
    return Table(
        Tabular(
            Row(Cell(bold("Generation 0"), alignment="c", length=4), bottom_rules=2),
            Row(bold("Individual"), bold("Program"), bold("Height"), bold("Fitness"),
                bottom_rules=1),
            *[
                Row(i.name, i.value.latex, i.value.depth, i.fitness, spacing="2pt")
                for i in population
            ],
            alignment="c|c|c|r",
        ),
        caption=Caption(
            "Initial population of the genetic programming algorithm",
            label="tab:bg:gp:sym:init:pop",
        ),
        position=[Position.HERE, Position.TOP, Position.STRICT],
    )


def _save_population_table(tab: Table) -> str | Path:
    """
    Saves the LaTeX table to a .tex file.

    :param tab: A Table object representing the LaTeX table of the initial population.

    :return: The path to the saved file.
    """
    save_path = tab.save(INITIALIZATION_PATH / "tab-bg-gp-sym-init-pop.tex")
    debug(f"Saved initial population table to: {save_path}", "symbolic")
    return save_path


def _create_population_summary(population: Population) -> Table:
    """
    Creates a LaTeX table summarizing the initial population.

    :param population: A Population object representing the initial population.
    :return: A Table object representing the LaTeX table summarizing the initial population.
    """
    return Table(
        Tabular(
            Row("", bold("Fitness"), bold("Individual"), top_rules=1, bottom_rules=1),
            Row("Best", population[1].fitness, population[1].name),
            Row("Worst", population[0].fitness, population[0].name),
            Row(
                "Average",
                Cell(population.average_fitness, alignment="r|", length=2),
                top_rules=2,
            ),
            Row(
                "Standard deviation",
                Cell(population.stddev_fitness, alignment="r|", length=2),
                bottom_rules=1,
                top_rules=1,
            ),
            alignment="|c|r|c|",
        ),
        caption=Caption(
            "Fitness of the individuals in generation 0",
            label="tab:bg:gp:sym:init:pop:summary",
        ),
        position=[Position.HERE, Position.TOP, Position.STRICT],
    )


def _save_population_summary(tab: Table) -> str | Path:
    """
    Saves the LaTeX table summarizing the initial population to a .tex file.

    :param tab: A Table object representing the LaTeX table summarizing the initial population.
    :return: The path to the saved file.
    """
    save_path = tab.save(INITIALIZATION_PATH / "tab-bg-gp-sym-init-pop-summary.tex")
    debug(f"Saved initial population summary to: {save_path}", "symbolic")
    return save_path


def create_population(samples: list[Sample]) -> Population[Function]:
    """
    Creates the initial population for the genetic programming algorithm.

    This function creates the initial population for the genetic programming algorithm by
    evaluating each function in the 'fns' list for each sample in the 'samples' list.

    The function then logs some information about the initial population, including the average fitness and the standard
    deviation of the fitness.

    The population is then displayed in a LaTeX table, which is also logged.

    Finally, the LaTeX table is saved to a .tex file.

    :param samples: A list of samples, where each sample is a tuple of the form (x, y), representing the inputs and
                    outputs for the function.

    :return: A Population object representing the initial population.
    """
    individuals = _create_individuals(INITIAL_FUNCTIONS, samples)
    population = Population(individuals)
    _log_population_stats(population)
    tab = _create_population_table(population)
    debug(f"Initial population table:\n{tab}", "symbolic")
    summary = _create_population_summary(population)
    debug(f"Initial population summary:\n{summary}", "symbolic")
    _save_population_table(tab)
    _save_population_summary(summary)
    return population


def plot_population(population: Population[Function],
                    x_limits: Tuple[float, float],
                    graph_title: str,
                    file_path: Path) -> None:
    """
    Generate a plot illustrating the given population of functions.

    :param population: A `Population` instance, comprising several function
                       representations.
    :param x_limits: A tuple specifying the lower and upper limits for the x-axis.
    :param graph_title: The title to be displayed at the top of the plot.
    :param file_path: A `Path` instance denoting the location and filename where the plot
                      will be saved.
    """

    # Generate list of Line instances corresponding to population functions
    functions_to_plot = [Line(individual.name, individual.value.python) for individual in
                         population]

    draw_lines(
        *functions_to_plot,
        x_lim=x_limits,
        title=graph_title,
        x_label=math("x"),
        y_label=math("f(x)"),
        path=file_path
    )

