import re


def math(text: str) -> str:
    """
    Converts the input text into a LaTeX inline math mode string.

    :param text: A string representing a mathematical expression.
    :return: A string with the input text wrapped within LaTeX inline math mode delimiters.
    """
    # Remove non-escaped $ and $$
    text = re.sub(r'(?<!\\)\$', '', text)
    text = re.sub(r'(?<!\\)\$\$', '', text)

    # Remove non-escaped \( and \)
    text = re.sub(r'(?<!\\)\\[(]', '', text)
    text = re.sub(r'(?<!\\)\\[)]', '', text)

    return r"\(" + text + r"\)"


def tex(text) -> str:
    """
    Converts the input text into a LaTeX inline math mode string.

    :param text: A string representing a mathematical expression.
    :return: A string with the input text wrapped within LaTeX inline math mode delimiters.
    """
    return text.replace(r"\(", "$").replace(r"\)", "$")


def bold(text: str, math_mode: bool = False) -> str:
    """
    Converts the input text into a LaTeX bold string.

    :param text: A string.
    :param math_mode: A boolean indicating whether the text should be wrapped within LaTeX math mode delimiters.
    :return: A string with the input text wrapped within LaTeX bold delimiters.
    """
    if math_mode:
        return r"\mathbf{" + str(text) + r"}"
    else:
        return r"\textbf{" + str(text) + r"}"
