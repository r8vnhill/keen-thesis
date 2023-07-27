from math import sin

from commons.logs import info
from symbolic.samples import create_samples


def target_function(x: float) -> float:
    return 5 * x ** 3 - 2 * x ** 2 + sin(x) - 7


if __name__ == '__main__':
    samples = create_samples(target_function)
    info(f"Samples: {samples}", __name__)
