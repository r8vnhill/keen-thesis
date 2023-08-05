from pathlib import Path
from typing import Callable, Iterable, TypeVar

# noinspection SpellCheckingInspection
import matplotlib.pyplot as plt
from attr import dataclass
from numpy import linspace

T = TypeVar("T")
_Pair = tuple[T, T]
_FourTuple = tuple[T, T, T, T]
_SixTuple = tuple[T, T, T, T, T, T]
Style = str | tuple[int, _Pair[int] | _FourTuple[int] | _SixTuple[int]]


class LineStyle(Iterable[Style]):
    """
    A class to represent the style of a line.

    The LineStyle class is designed to encapsulate different types of line
    styles used in plotting graphs. It supports several styles ranging from
    simple ones like "solid", "dotted", "dashed", to more complex ones like
    "densely dotted", "dash-dot-dotted" and more.

    Attributes:
        styles (tuple[Style, ...]): A tuple of valid styles.
        _index (int): Index used for cycling through the styles.

    """

    _valid_styles: dict[str, Style] = {
        "solid": "-",
        "dotted": ":",
        "dashed": "--",
        "dash-dot": "-.",
        "densely dotted": (0, (1, 1)),
        "long dash with offset": (5, (10, 3)),
        "densely dashed": (0, (5, 1)),
        "densely dash-dotted": (0, (3, 1, 1, 1)),
        "dash-dot-dotted": (0, (3, 5, 1, 5, 1, 5)),
        "densely dash-dot-dotted": (0, (3, 1, 1, 1, 1, 1)),
        "loosely dashed": (0, (5, 10)),
        "loosely dash-dotted": (0, (3, 10, 1, 10)),
        "loosely dash-dot-dotted": (0, (3, 10, 1, 10, 1, 10)),
        "loosely dotted": (0, (1, 10)),
    }

    def __init__(self, *styles: Style):
        """
        Initializes the LineStyle object.

        If specific styles are provided, only those are considered valid
        styles. If no styles are specified, all styles are considered valid.

        Args:
            styles (Style): The styles that are considered valid for this
                            LineStyle object.

        """
        self.styles = tuple(y for _, y in self._valid_styles.items())
        if len(styles) != 0:
            self.styles = tuple(filter(lambda s: s in self.styles, styles))
        self._index = 0

    def __iter__(self):
        """
        Makes the LineStyle object iterable.

        Returns:
            self: An instance of the class.

        """
        return self

    def __next__(self):
        """
        Implements cycling through styles.

        Returns the next style in the sequence. If the end is reached, it
        loops back to the first style.

        Returns:
            result: The next style in the sequence.

        """
        result = self.styles[self._index]
        self._index = (self._index + 1) % len(self.styles)
        return result


@dataclass(init=False)
class Line:
    name: str
    f: Callable[[float], float]

    def __init__(self, name: str, f: Callable[[float], float]):
        self.name = name
        self.f = f


def draw_lines(
    *lines: Line,
    x_lim: tuple[float, float],
    title: str,
    x_label: str,
    y_label: str,
    path: Path,
) -> Path:
    """Draws lines on the screen."""
    from commons import debug
    from latex import tex

    line_styles = LineStyle()
    debug(f"Drawing lines: {lines}", __name__)
    x = linspace(*x_lim, 100)
    debug(f"X: {x}", __name__)
    for line in lines:
        debug(f"Line: {line}", __name__)
        plt.plot(
            x, [line.f(i) for i in x], label=tex(line.name), linestyle=next(line_styles)
        )
    plt.title(tex(title))
    plt.xlabel(tex(x_label))
    plt.ylabel(tex(y_label))
    plt.legend()

    debug(f"Saving plot to {path}", __name__)
    plt.savefig(str(path))
    plt.show()
    return path
