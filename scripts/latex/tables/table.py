import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Optional, TextIO

from commons.logs import debug
from latex.captions import Caption
from latex.env import environment, OptionalArgument
from latex.positions import Position, render_position
from latex.tables.tabular import Tabular


@dataclass
class Table:
    """
    Represents a LaTeX table environment.

    A Table object includes the Tabular content to be displayed within the table environment, the position of the table
    on the page, and a caption for the table.
    """
    content: Tabular
    position: Optional[list[Position]]
    caption: Optional[Caption]

    def __init__(self, tabular: Tabular, position: Optional[list[Position]] = None, caption: Optional[Caption] = None):
        """
        Construct a new Table object.

        :param tabular: The Tabular object to be displayed within the table environment.
        :param position: A list of Position objects indicating where the table should be placed on the page.
                         The default is None, indicating that LaTeX should decide where to place the table.
        :param caption: The Caption object for the table. The default is None, indicating that the table has no caption.
        """
        self.content = tabular
        self.position = position
        self.caption = caption

    def write(self, io: TextIO = sys.stdout) -> str:
        """
        Write the LaTeX code for the table to a file or stream.

        Remark: This method DOES NOT close the file or stream after writing to it.

        :param io: A file or stream to which the LaTeX code should be written.
                   The default is ``sys.stdout``.
        :return: The name of the file to which the LaTeX code was written.
        """
        debug(f'Writing table to {io.name}', __name__)
        io.write(str(self))
        return io.name

    def save(self, path: str | Path, overwrite: bool = True) -> str:
        """
        Write the LaTeX code for the table to a file.

        Remark: This method DOES NOT close the file after writing to it.

        :param path: The name of the file to which the LaTeX code should be written.
        :param overwrite: A boolean indicating whether the file should be overwritten if it already exists.
                          The default is True.
        :return: The name of the file to which the LaTeX code was written.
        """
        debug(f"Saving table to {path}", __name__)
        if not overwrite and Path(path).exists():
            raise FileExistsError(f"File {path} already exists")
        with open(str(path), 'w' if overwrite else 'x') as f:
            self.write(f)
        return path

    def __str__(self) -> str:
        """
        Generate the LaTeX code for the table.

        :return: A string of LaTeX code for the table.
        """
        return environment("table",
                           f"\\centering\n"
                           f"{self.content}\n"
                           f"{self.caption}\n" if self.caption else "",
                           OptionalArgument(render_position(*self.position)) if self.position else "")

    def __repr__(self) -> str:
        """
        Generate a string representation of the Table object.

        :return: A string representation of the Table object.
        """
        return f"Table(content={repr(self.content)}, position={repr(self.position)}, caption={repr(self.caption)})"


if __name__ == '__main__':
    Table(Tabular(1, alignment='r'), caption=Caption("Caption", label="label"),
          position=[Position.HERE, Position.TOP, Position.STRICT]) \
        .save("table.tex")
