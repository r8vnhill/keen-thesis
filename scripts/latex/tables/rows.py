from dataclasses import dataclass
from typing import Optional

from latex.tables import Cell


@dataclass
class Rule:
    r"""
    Represents a LaTeX table horizontal rule (partial line) for specific columns.

    Attributes:
    -----------
    start_column: int
        The starting column for the horizontal rule in the LaTeX table.

    end_column: int
        The ending column for the horizontal rule in the LaTeX table.

    Methods:
    --------
    __str__() -> str:
        Returns the LaTeX representation of the horizontal rule for the specified columns.

    Examples:
    ---------
    >>> rule = Rule(1, 3)
    >>> print(rule)
    \cline{1-3}
    """

    start_column: int
    end_column: int

    def __str__(self) -> str:
        return f"\\cline{{{self.start_column}-{self.end_column}}}"


@dataclass
class Row:
    """
    Represents a row in a LaTeX table.

    A Row object contains a list of Cell objects and defines the number of horizontal
    lines (rules) above (top) and below (bottom) the row.
    """

    data: list[Cell]
    top_rules: int
    bottom_rules: int
    spacing: Optional[str]

    def __init__(
            self,
            *content: object,
            top_rules: int | Rule | list[Rule] = 0,
            bottom_rules: int | Rule | list[Rule] = 0,
            spacing: Optional[str] = None,
            precision: int = 6,
    ):
        """
        Construct a new Row object.

        :param content: The data objects to be displayed in the row.
                        Each object will be encapsulated into a Cell object.
                        If content is a single Row object, its data is used as this row's data.
        :param top_rules: The number of horizontal lines above the row, default is 0.
        :param bottom_rules: The number of horizontal lines below the row, default is 0.
        :param spacing: The optional spacing for the first cell in the row. Default is None.
        """
        match (top_rules, bottom_rules):
            case (int(t), _) if t < 0:
                raise ValueError("Number of rules must be non-negative.")
            case (_, int(b)) if b < 0:
                raise ValueError("Number of rules must be non-negative.")
            case (Rule(a, b), _) if a < 1 or b < a:
                raise ValueError("Rule start column must be greater than 0.")
            case (_, Rule(a, b)) if a < 1 or b < a:
                raise ValueError("Rule start column must be greater than 0.")
        match content:
            case (Row(d, t, b, s), ):
                self.data = d
                self.top_rules = t
                self.bottom_rules = b
                self.spacing = s
            case _:
                self.data = [Cell(c, precision=precision) for c in content]
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

        top_rules, bottom_rules = self._parse_rules()

        return (
                top_rules
                + "\t& ".join(data_str)
                + "\t\\\\"
                + str(bottom_rules)
        )

    def _parse_rules(self) -> tuple[str, str]:
        def match_rule(rule):
            match rule:
                case int(r):
                    return "\\hline\n" * r
                case Rule(_, _):
                    return str(rule)
                case list(_):
                    return '\n'.join([match_rule(r) for r in rule])
                case _:
                    raise ValueError("Invalid rule type.")

        return match_rule(self.top_rules), match_rule(self.bottom_rules)


if __name__ == "__main__":
    print(Row(1, 2, 3, top_rules=1, bottom_rules=2))
    print(Row(1, 2, 3))
    print(Row(Cell(1, length=2), 2))
    print(Row(Row(1, 2, 3)))
    print(Row(1, 2, 3, spacing="1ex"))
