from pathlib import Path
from typing import Callable

# noinspection SpellCheckingInspection
import matplotlib.pyplot as plt
from attr import dataclass
from numpy import linspace

from latex import tex


class LineStyle:
    """The style of a line."""
    styles: tuple[str, ...]
    index: int

    def __init__(self, *styles: str):
        if not styles:
            self.styles = ("-", "--", "-.", ":")
        else:
            self.styles = tuple(filter(lambda s: s in ("-", "--", "-.", ":"), styles))
        self.index = 0

    def __iter__(self):
        return self

    def __next__(self):
        result = self.styles[self.index]
        self.index = (self.index + 1) % len(self.styles)
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
        path: Path
) -> Path:
    """Draws lines on the screen."""
    from commons import debug

    line_styles = LineStyle()
    debug(f"Drawing lines: {lines}", __name__)
    x = linspace(*x_lim, 100)
    debug(f"X: {x}", __name__)
    for line in lines:
        debug(f"Line: {line}", __name__)
        plt.plot(x, [line.f(i) for i in x], label=tex(line.name), linestyle=next(line_styles))
    plt.title(tex(title))
    plt.xlabel(tex(x_label))
    plt.ylabel(tex(y_label))
    plt.legend()

    debug(f"Saving plot to {path}", __name__)
    plt.savefig(str(path))
    plt.show()
    return path
