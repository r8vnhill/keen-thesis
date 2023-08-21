from pathlib import Path

from commons.draw import draw_lines, Line, LineStyle
from commons.logs import debug, info, setup_logging
from commons.utils import format_number

__all__ = [
    "CONTENTS_DIR",
    "IMG_DIR",
    "debug",
    "info",
    "setup_logging",
    "format_number",
    "draw_lines",
    "Line",
    "LineStyle",
]
__author__ = ["r8vnhill"]

CONTENTS_DIR: Path = Path(__file__).parent.parent.parent / "contents"
IMG_DIR: Path = Path(__file__).parent.parent.parent / "img"

if __name__ == "__main__":
    debug(f"__all__: {__all__}", __name__)
    debug(f"__author__: {__author__}", __name__)
    debug(f"CONTENTS_DIR: {CONTENTS_DIR}", __name__)
