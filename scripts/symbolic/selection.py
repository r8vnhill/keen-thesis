from pathlib import Path

from commons import CONTENTS_DIR, format_number, debug
from latex import bold, Caption, Position
from latex.tables import Table, Tabular, Row
from symbolic.population import Population

SELECTION_PATH = CONTENTS_DIR / "Theoretical_Background" / "GP" / "selection"


def save_probabilities(population: Population) -> Path:
    """
    Save the selection probabilities of the individuals in the population.

    This function calculates and logs the selection probabilities of the individuals in the given population.
    It then creates a LaTeX table with the selection probabilities and saves it to a .tex file.

    The LaTeX table consists of three columns: 'Individual', 'Fitness', and 'Selection probability'.
    Each row of the table corresponds to one individual in the population, listing their name, fitness,
    and selection probability. The selection probability is expressed as a percentage.

    After creating the table, the function logs the table using the 'debug' function, then saves it to
    a .tex file. The path to the saved file is also logged using the 'debug' function.

    :param population: A Population object representing the population for which to calculate and save the selection
                       probabilities.

    :return: A Path object representing the path to the saved .tex file.
    """
    debug(f"Selection probabilities: {population.selection_probability}", __name__)
    tab = Table(
        Tabular(
            Row(bold("Individual"), bold("Fitness"), bold("Selection probability")),
            *[
                Row(i.name, i.fitness, f"{format_number(p * 100)}\\%")
                for i, p in zip(population, population.selection_probability)
            ],
            alignment="|l|r|r|",
        ),
        caption=Caption(
            "Selection probabilities for the symbolic regression problem.",
            label="tab:bg:gp:sel:prob",
        ),
        position=[Position.HERE, Position.TOP, Position.STRICT],
    )
    debug(f"Selection probabilities table:\n{tab}", __name__)
    save_path = tab.save(SELECTION_PATH / "tab-bg-gp-sel-prob.tex")
    debug(f"Saved selection probabilities table to: {save_path}", __name__)
    return save_path
