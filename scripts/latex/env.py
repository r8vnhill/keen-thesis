from dataclasses import dataclass

from commons.utils import indent


@dataclass
class OptionalArgument:
    """
    Represents an optional argument in a LaTeX command.

    An optional argument is enclosed in square brackets `[]` in LaTeX.
    """
    value: str

    def __init__(self, value: str):
        """
        Construct a new OptionalArgument object.

        :param value: The value of the optional argument.
        """
        self.value = value


@dataclass
class MandatoryArgument:
    """
    Represents a mandatory argument in a LaTeX command.

    A mandatory argument is enclosed in curly braces `{}` in LaTeX.
    """
    value: str

    def __init__(self, value: str):
        """
        Construct a new MandatoryArgument object.

        :param value: The value of the mandatory argument.
        """
        self.value = value


def environment(name: str, content: str, *args: OptionalArgument | MandatoryArgument) -> str:
    """
    Generate a string representing a LaTeX environment with given arguments.

    :param name: The name of the LaTeX environment.
    :param content: The content of the LaTeX environment.
    :param args: Optional and mandatory arguments to the LaTeX environment.
                 OptionalArgument objects are enclosed in square brackets `[]`.
                 MandatoryArgument objects are enclosed in curly braces `{}`.
    :return: A string representing the LaTeX environment with arguments and content.
    """
    s = r"\begin{" + name + "}"
    for a in args:
        match a:
            case OptionalArgument(v):
                s += f"[{v}]"
            case MandatoryArgument(v):
                s += f"{{{v}}}"
    return s + f"\n{indent(content)}\n" + r"\end{" + name + "}"


if __name__ == '__main__':
    # Matching on OptionalArgument and MandatoryArgument
    match OptionalArgument("optional"):
        case OptionalArgument(V):
            print(f"OptionalArgument: {V}")
        case MandatoryArgument(V):
            print(f"MandatoryArgument: {V}")
    match MandatoryArgument("mandatory"):
        case OptionalArgument(V):
            print(f"OptionalArgument: {V}")
        case MandatoryArgument(V):
            print(f"MandatoryArgument: {V}")

    # Creating an environment
    print(environment("document", "Hello, world!"))
    print(environment("document", "Hello, world!", OptionalArgument("optional")))
    print(environment("document", "Hello, world!", MandatoryArgument("mandatory")))
    print(environment("document", "Hello, world!", OptionalArgument("optional"), MandatoryArgument("mandatory")))
    print(environment("document", "Hello, world!", MandatoryArgument("mandatory"), OptionalArgument("optional"),
                      MandatoryArgument("mandatory")))
