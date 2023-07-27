from pathlib import Path

from commons.logs import debug, info

__all__ = ["CONTENTS_DIR", "debug", "info"]
__author__ = ["r8vnhill"]

CONTENTS_DIR = Path(__file__).parent.parent.parent / "contents"

if __name__ == '__main__':
    debug(f"__all__: {__all__}", __name__)
    debug(f"__author__: {__author__}", __name__)
    debug(f"CONTENTS_DIR: {CONTENTS_DIR}", __name__)
