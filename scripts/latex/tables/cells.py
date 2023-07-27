from dataclasses import dataclass

from commons.utils import format_number
from latex.tables.alignments import Alignment


def format_data(data: object) -> str:
    """
    Recursively format the data object for display.

    If data is a Cell object, it recursively formats the data field in the Cell.
    If data is a float or an integer, it formats the number using the format_number function.
    Otherwise, it converts the data to a string using the built-in str function.

    :param data: The data object to be formatted.
    :return: A string representing the formatted data.
    """
    match data:
        case Cell(d, _, _):
            return format_data(d)
        case float(n) | int(n):
            return format_number(n)
        case _:
            return str(data)


@dataclass
class Cell:
    """
    Represents a table cell in a LaTeX table.

    A Cell object contains data, alignment and length.
    Data can be any object, alignment defines the alignment of the data inside the cell in the table, and length is used
    for multicolumn cells in LaTeX (a cell that spans multiple columns).
    """
    data: object
    alignment: Alignment
    length: int

    def __init__(self, data: object, alignment: Alignment | str = 'c', length: int = 1):
        if length < 1:
            raise ValueError(f'Cell length [{length}] must be positive...')
        match data:
            case Cell(d, a, l):
                self.data = d
                self.alignment = a
                self.length = l
            case _:
                self.data = data
                self.alignment = Alignment(alignment)
                self.length = length

    def __str__(self):
        """
        Returns a string representation of the cell for use in a LaTeX table.

        If the length of the cell is greater than 1, it returns a LaTeX multicolumn command with the specified length,
        alignment and formatted data.

        If the length of the cell is 1, it simply returns the formatted data.

        :return: A string representing the cell for use in a LaTeX table.
        """
        d = format_data(self.data)
        if self.length > 1:
            return r"\multicolumn{" + str(self.length) + "}{" + str(self.alignment) + "}{" + d + "}"
        return d


if __name__ == '__main__':
    print(Cell(1.0))
    print(Cell(1.0, Alignment('r')))
    print(Cell(1.0, Alignment('r'), 2))
    print(Cell(Cell(1.0, Alignment('r'), 2), Alignment('r'), 2))
