from dataclasses import dataclass
from typing import Union


def validate_alignment(alignment: str) -> bool:
    """
    Checks if an alignment string is valid.

    This function verifies if all characters in a given alignment string are
    either 'l', 'c', or 'r'. Spaces and '|' characters are ignored during the check.

    :param alignment: Alignment string to be validated.
    :return: Boolean indicating whether the alignment string is valid.
    """
    valid_chars = ['l', 'c', 'r']
    align_chars = filter(lambda x: not (x in [' ', '|']), alignment)
    return all(map(lambda x: x in valid_chars, align_chars))


@dataclass
class Alignment:
    """
    Class for LaTeX table column alignment specification.

    This class is used to encapsulate and validate LaTeX-compatible column
    alignment strings for table creation.
    """

    alignment: str

    def __init__(self, alignment: Union[str, 'Alignment']):
        """
        Initializes an Alignment instance.

        :param alignment: Column alignment string.
        :raises ValueError: If alignment string is invalid.
        """
        match alignment:
            case Alignment(a):
                self.alignment = a
            case str(a):
                if validate_alignment(alignment):
                    self.alignment = alignment
                else:
                    raise ValueError(f'Invalid alignment: {alignment}')
            case _:
                raise TypeError(f'Invalid alignment type: {type(alignment)}')

    def __str__(self):
        """
        Returns the alignment string of the instance.

        :return: Column alignment string.
        """
        return self.alignment


if __name__ == '__main__':
    # Valid alignments
    print(Alignment('|r|r|'))
    print(Alignment('ccc'))
    print(Alignment('l|c|r'))
    print(Alignment("  |  r  ||  r  |  "))
    print(Alignment(Alignment('r')))
    # Invalid alignments
    print(Alignment('abc'))
