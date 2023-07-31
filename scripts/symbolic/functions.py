from dataclasses import dataclass
from typing import Callable


@dataclass
class Function:
    """
    A class that represents a function.

    This class is used to represent a function in symbolic regression problems.
    It contains the function's LaTeX representation, its Python representation, and its depth.
    """

    identity: str
    latex: str
    python: Callable[[float], float]
    depth: int

    def __call__(self, *args, **kwargs):
        return self.python(*args, **kwargs)
