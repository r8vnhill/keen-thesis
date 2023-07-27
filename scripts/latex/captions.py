from typing import Optional


def validate_label(label: Optional[str]) -> bool:
    """
    Checks if a label is valid.

    This function verifies whether all characters in a given label are alphanumeric
    or belong to a specific set of symbols: '_', ':', and '-'. If label is None, it is considered valid.

    :param label: Label string to be validated. Can be None.
    :return: Boolean indicating whether the label is valid.
    """
    return label is None or all(c.isalnum() or c in ['_', ':', '-'] for c in label)


class Caption:
    """
    Class for LaTeX caption and label generation.

    This class is used to generate LaTeX-compatible caption and label strings.
    It verifies the validity of label strings and properly formats them for LaTeX.
    """

    __text: str
    __label: Optional[str]

    def __init__(self, text: str, label: Optional[str] = None):
        """
        Initializes a Caption instance.

        :param text: Caption text.
        :param label: Label associated with the caption (optional).
        :raises ValueError: If label is invalid.
        """
        if validate_label(label):
            self.__text = text
            self.__label = label
        else:
            raise ValueError(f'Invalid label: {label}')

    def __str__(self):
        """
        Formats the Caption instance into LaTeX-compatible string.

        :return: LaTeX string including the caption and label (if present).
        """
        s = r"\caption{" + self.__text + "}"
        if self.__label is not None:
            s += '\n' + r"\label{" + self.__label + "}"
        return s


if __name__ == '__main__':
    print(Caption('A caption', 'fig:my_fig'))
    print(Caption('A caption'))
