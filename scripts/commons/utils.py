import numpy as np
from numpy import float_, int_


def indent(text: str, spaces: int = 2) -> str:
    """
    Indents a multiline string by a specified number of spaces.
    """
    return '\n'.join([' ' * spaces + line for line in text.splitlines()])


def surround(text: str, top: str, bottom: str) -> str:
    """
    Surrounds a string with a top and bottom string.
    """
    return f"{top}\n{text}\n{bottom}"


def format_number(num: int_ | float_) -> str:
    """
    Formats a real number for display, grouping digits for readability.

    For an integer input, this function groups digits into sets of three, separated by '\\,',
    starting from the rightmost digit.

    For a non-integer input, the function first rounds the number to the seventh decimal place, then
    separates the integer and fractional parts.
    The integer part is formatted in the same way as for an integer input.
    The fractional part is also grouped into sets of three digits, separated by '\\,'.

    :param num: The number to format.
    :return: A string representing the formatted number.

    Example:
        >>> format_number(123456.789123456)
        '123\\,456.789\\,123\\,456'
    """
    match num:
        case int(_):
            return f'{num:,}'.replace(",", "\\,")
        case _:
            num = np.round(num, 7)  # type: ignore
            int_part, frac_part = f"{num:.6f}".split(".")
            int_part = f'{int(int_part):,}'
            frac_part = ",".join([frac_part[i:i + 3] for i in range(0, len(frac_part), 3)])
            return (int_part + "." + frac_part).replace(",", "\\,")


if __name__ == '__main__':
    # indent
    print(indent("Hello, world!"))
    print(indent("Hello, world!", 4))
    print(indent("Hello,\nworld!"))
    print(indent("Hello,\nworld!", 4))
    # format_number
    print(format_number(123456.789123456))
    print(format_number(123456.7891))
    print(format_number(123456))
    print(format_number(12))
