from dataclasses import dataclass
from pathlib import Path
from typing import TypeVar, Generic, Callable, Sized

import numpy as np

from commons import Line, draw_lines
from latex import math
from symbolic.functions import Function

T = TypeVar("T")


@dataclass
class Individual(Generic[T]):
    """
    Represents an individual in a population for evolutionary algorithms.
    """

    name: str
    """A string representing the name of the individual."""
    value: T
    """
    The genotype of the individual.
    This can be of any type 'T'.
    """
    fitness: float
    """
    A numerical value representing the fitness of the individual.
    It indicates how well the individual performs in the environment.
    """


@dataclass
class Population(Sized, Generic[T]):
    """
    Represents a population of individuals for evolutionary algorithms.

    Attributes:
    -----------
    individuals: list[Individual]
        A list of individuals that make up the population.
    """

    individuals: list[Individual[T]]

    @property
    def fitness(self) -> list[float]:
        """
        A property that returns a list of fitness values of all the individuals in the population.
        """
        return [i.fitness for i in self.individuals]

    @property
    def average_fitness(self) -> np.float64:
        """
        A property that returns the average fitness of the population.
        """
        return np.average(self.fitness)

    @property
    def stddev_fitness(self) -> np.float64:
        """
        A property that returns the standard deviation of fitness in the population.
        """
        # noinspection PyTypeChecker
        return np.std(self.fitness)

    @property
    def selection_probability(self) -> list[np.float64]:
        """
        A property that returns a list of selection probabilities for all individuals in the population.
        Each individual's selection probability is calculated as its fitness divided by the total fitness of the
        population.
        """
        return [i.fitness / np.sum(self.fitness) for i in self.individuals]

    def map(
            self, transform: Callable[[Individual[T]], Individual[T]]
    ) -> "Population[T]":
        """
        Apply a given transformation function to each individual in the population and return a new population
        of transformed individuals.

        :param transform: A function that takes an individual and returns a transformed individual.

        :returns: A new population of transformed individuals.
        """
        return Population([transform(i) for i in self.individuals])

    def filter(self, predicate: Callable[[Individual[T]], bool]) -> "Population[T]":
        """
        Filters the population based on the given predicate and returns a new population
        of filtered individuals.

        :param predicate: A function that takes an individual and returns a boolean value.

        :returns: A new population of filtered individuals.
        """
        return Population([i for i in self.individuals if predicate(i)])

    def __getitem__(self, item: int) -> Individual[T]:
        """
        Returns the individual at the given index in the population.
        """
        return self.individuals[item]

    def __len__(self) -> int:
        """
        Returns the number of individuals in the population.
        """
        return len(self.individuals)

    def __iter__(self):
        """
        Returns an iterator for the population.
        """
        return iter(self.individuals)


def concat(
        *individuals: Individual[T] | list[Individual[T]] | Population[T],
) -> Population[T]:
    """
    Concatenates the values of the given individuals and returns a new population
    with the concatenated value.

    :param individuals: A list of individuals to concatenate.

    :returns: A new individual with the concatenated value.
    """
    flattened = []
    for i in individuals:
        if isinstance(i, list):
            flattened.extend(i)
        elif isinstance(i, Population):
            flattened.extend(i.individuals)
        else:
            flattened.append(i)
    return Population(flattened)


def plot_population(
        population: Population[Function],
        x_limits: tuple[float, float],
        graph_title: str,
        file_path: Path,
) -> None:
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
    functions_to_plot = [
        Line(individual.name, individual.value.python) for individual in population
    ]

    draw_lines(
        *functions_to_plot,
        x_lim=x_limits,
        title=graph_title,
        x_label=math("x"),
        y_label=math("f(x)"),
        path=file_path,
    )


if __name__ == "__main__":
    print(Individual("a", 1, 2))
    print(Population([Individual("a", 1, 2), Individual("b", 2, 3)]))
    print(Population([Individual("a", 1, 2), Individual("b", 2, 3)]).fitness)
    print(Population([Individual("a", 1, 2), Individual("b", 2, 3)]).average_fitness)
    print(Population([Individual("a", 1, 2), Individual("b", 2, 3)]).stddev_fitness)
    print(
        Population([Individual("a", 1, 2), Individual("b", 2, 3)]).selection_probability
    )
    print(
        Population([Individual("a", 1, 2), Individual("b", 2, 3)]).map(
            lambda i: Individual(i.name, i.value, 0)
        )
    )
