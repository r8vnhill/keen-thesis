from enum import Enum


class Position(Enum):
    """
    Represents the position of a float in LaTeX.
    """
    TOP = "t"
    BOTTOM = "b"
    HERE = "h"
    PAGE = "p"
    STRICT = "!"
    FORCE_HERE = "H"


def render_position(*positions: Position) -> str:
    """
    Returns a string representing the concatenation of the float positions.
    """
    return "".join(map(lambda p: p.value, positions))


if __name__ == '__main__':
    print(render_position(Position.HERE, Position.BOTTOM, Position.STRICT))
