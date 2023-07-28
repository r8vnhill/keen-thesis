from dataclasses import dataclass
from typing import TypeVar, Generic, Callable, Sized

import numpy as np

T = TypeVar('T')


@dataclass
class Individual(Generic[T]):
    """
    Represents an individual in a population for evolutionary algorithms.

    Attributes:
    -----------
    name: str
        A string representing the name of the individual.
    value: T
        The genotype of the individual.
        This can be of any type 'T'.
    fitness: float
        A numerical value representing the fitness of the individual.
        It indicates how well the individual performs in the environment.
    """

    name: str
    value: T
    fitness: float


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
    def average_fitness(self) -> float:
        """
        A property that returns the average fitness of the population.
        """
        return np.average(self.fitness)

    @property
    def stddev_fitness(self) -> float:
        """
        A property that returns the standard deviation of fitness in the population.
        """
        # noinspection PyTypeChecker
        return np.std(self.fitness)

    @property
    def selection_probability(self) -> list[float]:
        """
        A property that returns a list of selection probabilities for all individuals in the population.
        Each individual's selection probability is calculated as its fitness divided by the total fitness of the
        population.
        """
        return [i.fitness / sum(self.fitness) for i in self.individuals]

    def map(self, transform: Callable[[Individual[T]], Individual[T]]) -> 'Population[T]':
        """
        Apply a given transformation function to each individual in the population and return a new population
        of transformed individuals.

        :param transform: A function that takes an individual and returns a transformed individual.

        :returns: A new population of transformed individuals.
        """
        return Population([transform(i) for i in self.individuals])

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


if __name__ == '__main__':
    print(Individual('a', 1, 2))
    print(Population([Individual('a', 1, 2), Individual('b', 2, 3)]))
    print(Population([Individual('a', 1, 2), Individual('b', 2, 3)]).fitness)
    print(Population([Individual('a', 1, 2), Individual('b', 2, 3)]).average_fitness)
    print(Population([Individual('a', 1, 2), Individual('b', 2, 3)]).stddev_fitness)
    print(Population([Individual('a', 1, 2), Individual('b', 2, 3)]).selection_probability)
    print(Population([Individual('a', 1, 2), Individual('b', 2, 3)]).map(lambda i: Individual(i.name, i.value, 0)))
