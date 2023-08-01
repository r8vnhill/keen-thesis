from dataclasses import dataclass
from typing import Callable, Optional


@dataclass
class Function:
    """
    A class that represents a function.

    This class is used to represent a function in symbolic regression problems.
    It contains the function's LaTeX representation, its Python representation, and its depth.
    """

    identity: Optional[str]
    latex: Optional[str]
    python: Optional[Callable[[float], float]]
    depth: Optional[int]

    def __init__(
            self,
            identity: Optional[str] = None,
            latex: Optional[str] = None,
            python: Optional[Callable[[float], float]] = None,
            depth: Optional[int] = None,
    ):
        self.identity = identity
        self.latex = latex
        self.python = python
        self.depth = depth

    def __call__(self, *args, **kwargs):
        return self.python(*args, **kwargs)
