from dataclasses import dataclass

from latex.tables.cells import Cell


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

    def __init__(self, *content: object, top_rules: int = 0, bottom_rules: int = 0):
        """
        Construct a new Row object.

        :param content: The data objects to be displayed in the row.
                        Each object will be encapsulated into a Cell object.
                        If content is a single Row object, its data is used as this row's data.
        :param top_rules: The number of horizontal lines above the row, default is 0.
        :param bottom_rules: The number of horizontal lines below the row, default is 0.
        """
        match content:
            case (Row(d, t, b),):
                self.data = d
                self.top_rules = t
                self.bottom_rules = b
            case _:
                self.data = [Cell(c) for c in content]
                self.top_rules = top_rules
                self.bottom_rules = bottom_rules

    def __str__(self) -> str:
        """
        Returns a string representation of the row for use in a LaTeX table.

        It starts with as many "\\hline" commands as specified by top_rules, then joins the string representations of
        all cells in the row separated by " & ", and ends with "\\\\" for a new line and as many "\\hline" commands as
        specified by bottom_rules.

        :return: A string representing the row for use in a LaTeX table.
        """
        return "\\hline\n" * self.top_rules \
            + "\t& ".join(map(str, self.data)) + "\t\\\\" \
            + "\n\\hline" * self.bottom_rules


if __name__ == '__main__':
    print(Row(1, 2, 3, top_rules=1, bottom_rules=2))
    print(Row(1, 2, 3))
    print(Row(Cell(1, length=2), 2))
    print(Row(Row(1, 2, 3)))
