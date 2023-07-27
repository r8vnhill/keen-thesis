from dataclasses import dataclass
from math import sin
from typing import Callable

from commons import info, debug, CONTENTS_DIR
from latex import Caption, Position, math
from latex.tables import Table, Tabular, Cell, Row
from symbolic.population import Population, Individual
from symbolic.samples import create_samples

Sample = tuple[float, float]


@dataclass
class Function:
    """
    A class that represents a function.

    This class is used to represent a function in symbolic regression problems.
    It contains the function's LaTeX representation, its Python representation, and its depth.
    """
    latex: str
    python: Callable[[float], float]
    depth: int

    def __call__(self, *args, **kwargs):
        return self.python(*args, **kwargs)


INITIAL_FUNCTIONS = [Function(math(r"\frac{3}{\sin(2)} \cdot 5^3"), lambda _: 3 / sin(2) * 5 ** 3, 3),
                     Function(math(r"7 - (5 + \sin(x))"), lambda x: 7 - (5 + sin(x)), 3),
                     Function(math(r"7 + 2"), lambda _: 7 + 2, 1),
                     Function(math(r"5x^2"), lambda x: 5 * x ** 2, 2)]


def target_function(x: float) -> float:
    return 5 * x ** 3 - 2 * x ** 2 + sin(x) - 7


def mse(observed: list[float], predicted: list[float]) -> float:
    """
    Computes the Mean Squared Error (MSE) between two lists of numbers.

    Mean Squared Error is a common metric used in regression problems in the field of machine learning.
    It is used to quantify the difference between the predicted numerical values output by a model and the actual
    numerical values.

    It does this by squaring the differences between each predicted and actual value, adding all these square
    differences together, and then dividing by the number of data points.
    This has the effect of 'punishing' larger errors more due to the squaring operation.

    Mathematically, if 'n' is the number of data points, 'Y' is the list of observed values, and 'Y_hat' is the list of
    predicted values, the MSE is computed as:

    MSE = (1 / n) * sum((Y_i - Y_hat_i) ^ 2) for all i in range(n)

    :param observed: The list of observed (actual) values.
    :param predicted: The list of predicted (estimated) values.

    :returns: The computed mean squared error, a single float value.
              This value is always non-negative, and a value of 0 indicates a perfect fit to the data.
              In general, lower MSE values represent better fits to the data.
    """
    return sum([(o - p) ** 2 for o, p in zip(observed, predicted)]) / len(observed)


def bold(text: str) -> str:
    return r"\textbf{" + text + r"}"


def create_population(fns: list[Function], samples: list[Sample]) -> Population:
    """
    Creates the initial population for the genetic programming algorithm.

    This function creates the initial population for the genetic programming algorithm by evaluating each function
    in the 'fns' list for each sample in the 'samples' list.
    The mean squared error (MSE) between the function's output and the actual output is used as the fitness for each
    individual in the population.

    The function then logs some information about the initial population, including the average fitness and the standard
    deviation of the fitness, using the 'debug' function.

    The population is then displayed in a LaTeX table, which is also logged using the 'debug' function.

    Finally, the LaTeX table is saved to a .tex file.
    The path to the saved file is also logged using the 'debug' function.

    :param fns: A list of functions, where each function is considered an individual in the population.
    :param samples: A list of samples, where each sample is a tuple of the form (x, y), representing the inputs and
                    outputs for the function.

    :return: A Population object representing the initial population.
    """
    population = Population(
        [Individual(
            math(r"\mathrm{I}_" + str(i + 1) + r"(x)"),
            f,
            mse([f(x) for x, _ in samples], [s[1] for s in samples])
        ) for i, f in enumerate(fns)])
    debug(f"Initial population: {population}", __name__)
    debug(f"Initial population average fitness: {population.average_fitness}", __name__)
    debug(f"Initial population standard deviation of fitness: {population.stddev_fitness}", __name__)
    tab = Table(
        Tabular(Row(Cell(bold("Generation 0"), alignment="c", length=4), bottom_rules=2),
                Row(bold("Individual"), bold("Program"), bold("Height"), bold("Fitness")),
                *[Row(i.name, i.value.latex, i.value.depth, i.fitness, spacing="2pt") for i in population],
                alignment="c|c|c|r"),
        caption=Caption("Initial population of the genetic programming algorithm",
                        label="tab:bg:gp:sym:init:pop"),
        position=[Position.HERE, Position.TOP, Position.STRICT])
    debug(f"Initial population table:\n{tab}", __name__)
    save_path = tab.save(
        CONTENTS_DIR / "Theoretical_Background" / "GP" / "initialization" / "tab-bg-gp-sym-init-pop.tex")
    debug(f"Saved initial population table to: {save_path}", __name__)
    return population


if __name__ == '__main__':
    SAMPLES = create_samples(target_function)
    info(f"Samples: {SAMPLES}", __name__)
    POPULATION = create_population(INITIAL_FUNCTIONS, SAMPLES)
    info(f"Population: {POPULATION}", __name__)
