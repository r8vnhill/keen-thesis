import logging
from pathlib import Path

from commons import CONTENTS_DIR, format_number, debug, IMG_DIR
from latex import bold, Caption, Position
from latex.tables import Table, Tabular, Row
from symbolic.functions import Function
from symbolic.population import Population, Individual, plot_population, concat

SELECTION_PATH = CONTENTS_DIR / "Theoretical_Background" / "GP" / "selection"


def save_probabilities(population: Population) -> Path:
    """
    Save the selection probabilities of the individuals in the population to a .tex file.

    :param population: A Population object representing the population.
    :return: A Path object representing the path to the saved .tex file.
    """
    debug(f"Selection probabilities: {population.selection_probability}", __name__)

    table = generate_table(population)
    debug(f"Selection probabilities table:\n{table}", __name__)

    save_path = table.save(SELECTION_PATH / "tab-bg-gp-sel-prob.tex")
    debug(f"Saved selection probabilities table to: {save_path}", __name__)

    return save_path


def generate_table(population: Population) -> Table:
    """
    Generates a LaTeX table with the selection probabilities of the individuals.

    :param population: A Population object representing the population.
    :return: A Table object representing the generated LaTeX table.
    """
    return Table(
        Tabular(
            Row(
                bold("Individual"),
                bold("Fitness"),
                bold("Selection probability"),
                top_rules=1,
                bottom_rules=1,
            ),
            *[
                Row(
                    individual[0].name,
                    individual[0].fitness,
                    f"{format_number(individual[1] * 100)}\\%",
                    bottom_rules=1 if idx == len(population) - 1 else 0,
                )
                for idx, individual in enumerate(
                    zip(population, population.selection_probability)
                )
            ],
            alignment="|l|r|r|",
        ),
        caption=Caption(
            "Selection probabilities for the symbolic regression problem.",
            label="tab:bg:gp:sel:prob",
        ),
        position=[Position.HERE, Position.TOP, Position.STRICT],
    )


def calculate_probabilities(population: Population[Function]) -> None:
    """
    Corrects the population of Individuals to be used in a roulette wheel selection and
    saves the selection probabilities.
    """
    sum_of_fitnesses = sum(i.fitness for i in population)
    logging.info(f"Sum of fitnesses: {sum_of_fitnesses}")

    corrected_population = population.map(
        lambda i: Individual(i.name, i.value, sum_of_fitnesses - i.fitness)
    )
    logging.info(f"Corrected population: {corrected_population}")

    save_probabilities(corrected_population)


def select_survivors(
    population: Population[Function], target_individual: Individual[Function]
) -> Population[Function]:
    """
    Selects survivors from the population and plots them.

    :param population: A Population object representing the population.
    :param target_individual: An Individual object representing the target individual.
    :return: A Population object representing the survivors.
    """
    calculate_probabilities(population)

    average_initial_fitness = population.average_fitness
    logging.info(f"Average initial fitness: {average_initial_fitness}")

    stddev_initial_fitness = population.stddev_fitness
    logging.info(f"Standard deviation of initial fitness: {stddev_initial_fitness}")

    survivors = Population([population.individuals[1], population.individuals[2]])

    plot_survivors(target_individual, survivors)

    return survivors


def plot_survivors(target_individual: Individual[Function], survivors: Population[Function]) -> None:
    """
    Plots the survivors of the population.

    :param target_individual: An Individual object representing the target individual.
    :param survivors: A Population object representing the survivors.
    """
    plot_population(
        concat(target_individual, survivors),
        x_limits=(-1, 1),
        graph_title="Survivors of the population and the target function",
        file_path=IMG_DIR / "theoretical_framework" / "gp_pop_sel_survivors.png",
    )
