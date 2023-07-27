from math import sin
from typing import Callable

import coloredlogs

from commons import CONTENTS_DIR, debug
from latex import Caption, Position
from latex.tables import Row, Table, Tabular


def create_samples(f: Callable[[float], float]) -> list[tuple[float, float]]:
    """
    Generates a list of samples based on the provided function `f`, and represents these samples as a LaTeX table.

    The function `f` is evaluated at pre-defined sample points.
    The result is a list of tuples where each tuple contains a sample point and its corresponding function value.
    These tuples are then formatted as a LaTeX table and saved to a .tex file.

    :param f: A callable that accepts a float and returns a float.
              This function is used to generate the function values at the sample points.
    :return: A list of tuples.
             Each tuple contains a sample point (float) and its corresponding function value (float).

    Example:
    --------
    Let's say we have a function `f(x) = x**2`.
    We can create a LaTeX table of sample points and their corresponding function values as follows:

    ```python
        def square(x: float) -> float:
            return x**2

        samples = create_samples(square)
    ```

    This will create a .tex file with a table where each row contains a sample point and its square.

    The list `samples` will be a list of tuples where each tuple contains a sample point and its square.
    """
    samples = [-0.889160069272859, -0.8561029711395651, -0.8212951850355155, -0.8181934125983823, -0.4298586689110253,
               -0.3523275114715019, -0.0357759083395397, 0.017449673577553337, 0.5290096774879465, 0.8211010511234629]
    debug(f'Created samples: {samples}', __name__)
    data = [(d, f(d)) for d in samples]
    tab = Table(Tabular(Row(r"\(x\)", r"\(y\)", top_rules=1, bottom_rules=2),
                        *[Row(*d, bottom_rules=1) for d in data],
                        alignment="|r|r|"),
                caption=Caption(
                    r"A set of points generated from the function \(5x^3 - 2x^2 + \sin(x) - 7\)",
                    label="tab:bg:gp:repr_ev:points"),
                position=[Position.HERE, Position.TOP, Position.STRICT])
    debug(f'Created table:\n{tab}', __name__)
    path = tab.save(CONTENTS_DIR / "Theoretical_Background" / "GP" / "representation" / "tab-bg-gp-repr_ev-points.tex")
    debug(f'Saved table to {path}', __name__)
    return data


if __name__ == '__main__':
    coloredlogs.install(level='DEBUG')
    SAMPLES = create_samples(lambda x: 5 * x ** 3 - 2 * x ** 2 + sin(x) - 7)
    print(SAMPLES)
