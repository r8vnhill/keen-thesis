from dataclasses import dataclass
from typing import Optional

from latex.tables import Cell


@dataclass
class Row:
    """
    Represents a row in a LaTeX table.

    A Row object contains a list of Cell objects and defines the number of horizontal lines (rules) above (top) and
    below (bottom) the row.
    """
    data: list[Cell]
    top_rules: int
    bottom_rules: int
    spacing: Optional[str]

    def __init__(self, *content: object, top_rules: int = 0, bottom_rules: int = 0, spacing: Optional[str] = None):
        """
        Construct a new Row object.

        :param content: The data objects to be displayed in the row.
                        Each object will be encapsulated into a Cell object.
                        If content is a single Row object, its data is used as this row's data.
        :param top_rules: The number of horizontal lines above the row, default is 0.
        :param bottom_rules: The number of horizontal lines below the row, default is 0.
        :param spacing: The optional spacing for the first cell in the row. Default is None.
        """
        match content:
            case (Row(d, t, b, s), ):
                self.data = d
                self.top_rules = t
                self.bottom_rules = b
                self.spacing = s
            case _:
                self.data = [Cell(c) for c in content]
                self.top_rules = top_rules
                self.bottom_rules = bottom_rules
                self.spacing = spacing

    def __str__(self) -> str:
        """
        Returns a string representation of the row for use in a LaTeX table.

        It starts with as many "\\hline" commands as specified by top_rules, then joins the string representations of
        all cells in the row separated by " & ", and ends with "\\\\" for a new line and as many "\\hline" commands as
        specified by bottom_rules.

        If the spacing attribute is not None, the first cell is surrounded by \\Gape[spacing][spacing]{...}

        :return: A string representing the row for use in a LaTeX table.
        """
        data_str = list(map(str, self.data))
        if self.spacing:
            data_str[0] = f"\\Gape[{self.spacing}][{self.spacing}]{{{data_str[0]}}}"

        return "\\hline\n" * self.top_rules \
            + "\t& ".join(data_str) + "\t\\\\" \
            + "\n\\hline" * self.bottom_rules


if __name__ == '__main__':
    print(Row(1, 2, 3, top_rules=1, bottom_rules=2))
    print(Row(1, 2, 3))
    print(Row(Cell(1, length=2), 2))
    print(Row(Row(1, 2, 3)))
    print(Row(1, 2, 3, spacing="1ex"))
