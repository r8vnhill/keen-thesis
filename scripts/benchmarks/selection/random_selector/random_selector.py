import json
from pathlib import Path
from typing import List

import numpy

from commons import CONTENTS_DIR, setup_logging, info
from latex import Position, Caption
from latex.tables import Table, Tabular, Row, Cell, Rule
from latex.text import mono

RANDOM_SELECTOR_PATH = CONTENTS_DIR / "keen" / "operators" / "selection" / "random"

BENCHMARK_FILES = [f"{i}.json" for i in range(3)]

WORD_LENGTHS = (1, 20, 40, 60, 80, 100)

InitTime = float
EvolutionTime = float
Generations = int
Accuracy = float
SelectionTime = float


def load_evolution_data(file_path: Path) -> dict[str, str | dict]:
    """Load evolution data from a JSON file."""
    with file_path.open("r") as f:
        info(f"Loading evolution data from {file_path}", __name__)
        return json.load(f)


# noinspection PyTypeChecker
def calculate_averages_from_benchmarks(files: List[str], length: int) \
        -> tuple[
            InitTime, EvolutionTime, Generations, Accuracy, SelectionTime, SelectionTime]:
    """
    Calculate the average initialization time for a given set of benchmark files and word
    length.
    """
    init_times = []
    evolution_times = []
    total_generations = []
    accuracies = []
    survival_selection_times = []
    offspring_selection_times = []
    for file in files:
        evolution = load_evolution_data(Path(str(length)) / file)
        init_times.append(evolution["initialization"]["duration"] / 1000000)
        evolution_times.append(int(evolution["duration"]) / 1000000000)
        generations = evolution["generations"]
        total_generations.append(len(generations))
        last_generation = generations[-1]
        accuracies.append(max(
            last_generation["population"]["resulting"],
            key=lambda x: x["fitness"]
        )["fitness"] / length)
        survival_selection_times.append(
            last_generation["survivorSelection"]["duration"] / 1000000)
        offspring_selection_times.append(
            last_generation["offspringSelection"]["duration"] / 1000000)

    return (numpy.average(init_times),
            numpy.average(evolution_times),
            int(numpy.average(total_generations)),
            numpy.average(accuracies),
            numpy.average(survival_selection_times),
            numpy.average(offspring_selection_times))


def create_table(benchmarks: dict[str, list[float]]):
    """Generate a table with the provided benchmarks."""
    tab = Table(
        Tabular(
            Row(
                "",
                Cell("Word length", length=6, alignment="c|"),
                bottom_rules=Rule(2, 7),
                top_rules=1,
            ),
            Row("", 1, 20, 40, 60, 80, 100, bottom_rules=1),
            Row(r"Survivor selection time (\(\mu\)s)",
                *benchmarks["survival_selection_times"], bottom_rules=1, precision=3),
            Row(r"Offspring selection time (\(\mu\)s)",
                *benchmarks["offspring_selection_times"], bottom_rules=1, precision=3),
            Row("Evolution time (s)", *benchmarks["evolution_times"], bottom_rules=1,
                precision=3),
            Row("Total generations", *benchmarks["generations"], bottom_rules=1,
                precision=3),
            Row("Accuracy", *[f"{x:.3f}\\%" for x in benchmarks["accuracies"]],
                bottom_rules=1, precision=3),
            alignment=f"|l|{'r|' * 6}",
        ),
        position=[Position.HERE, Position.TOP, Position.STRICT],
        caption=Caption(
            f"Performance of the {mono('RandomSelector')} class for the WGP for "
            "different word lengths. "
            "A single-point crossover with a crossover probability of 0.2 and a mutation "
            "probability of 0.06 was used. "
            "The population size was 500 and a limit of 1000 generations was used."
            "The algorithm was run 3 times for each word length and the average "
            "performance is shown.",
            label="tab:keen:operators:selection:random",
        ),
    )
    info(f"Table:\n{tab}", __name__)
    return tab


def main():
    benchmarks = {"init_times": [], "evolution_times": [], "generations": [],
                  "accuracies": [], "survival_selection_times": [],
                  "offspring_selection_times": []}

    for length in WORD_LENGTHS:
        avg_times = calculate_averages_from_benchmarks(BENCHMARK_FILES, length)
        benchmarks["init_times"].append(avg_times[0])
        benchmarks["evolution_times"].append(avg_times[1])
        benchmarks["generations"].append(avg_times[2])
        benchmarks["accuracies"].append(avg_times[3])
        benchmarks["survival_selection_times"].append(avg_times[4])
        benchmarks["offspring_selection_times"].append(avg_times[5])

    table = create_table(benchmarks)
    table.save(RANDOM_SELECTOR_PATH / "tab_keen_operators_selection_random.tex")


if __name__ == "__main__":
    setup_logging()
    main()
