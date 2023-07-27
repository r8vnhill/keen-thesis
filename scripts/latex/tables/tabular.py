from dataclasses import dataclass

from latex.env import environment, MandatoryArgument
from latex.tables.alignments import Alignment
from latex.tables.cells import Cell
from latex.tables.rows import Row


@dataclass
class Tabular:
    """
    Represents a LaTeX tabular environment.

    A Tabular object consists of multiple Row objects and an Alignment object, defining the alignment
    of each column in the tabular.
    """
    rows: tuple[Row, ...]
    alignment: Alignment

    def __init__(self, *content: object, alignment: str | Alignment):
        """
        Construct a new Tabular object.

        :param content: The Row objects to be displayed in the tabular.
                        Each object will be encapsulated into a Row object.
        :param alignment: An Alignment object defining the alignment for each column.
        :raise ValueError: If no content is provided to the tabular.
        """
        if len(content) == 0:
            raise ValueError("Tabular content must not be empty")
        self.rows = tuple([Row(c) for c in content])
        self.alignment = Alignment(alignment)

    def __str__(self):
        """
        Represent the Tabular object as a LaTeX tabular environment string.

        :return: A string representing the Tabular object in the LaTeX tabular environment format.
        """
        return environment("tabular", "\n".join([str(r) for r in self.rows]), MandatoryArgument(str(self.alignment)))

    def __repr__(self):
        """
        Represent the Tabular object as a Python string.

        :return: A string representing the Tabular object in the Python string format.
        """
        return f'Tabular({", ".join([repr(r) for r in self.rows])}, alignment={repr(self.alignment)})'


if __name__ == '__main__':
    print(Tabular(Row(1.0), Row(2.0), alignment=Alignment('r')))
    print(Tabular(1, 2, 3, alignment='r'))
    print(Tabular(Row(1.0, 2.0), Row(3.0, 4.0), alignment=Alignment('r|r')))
    print(Tabular(Row(Cell(1.0, Alignment('r'), 2), 2), Row(3.0, 4.0, 5), alignment=Alignment('r|r')))
