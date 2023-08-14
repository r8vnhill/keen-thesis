import matplotlib.pyplot as plt
import numpy as np


def cardinality(n: int) -> np.ndarray:
    return np.array([65535**n], dtype="object")


def plot_cardinality(n: int) -> None:
    """
    Plot the cardinality from 1 to n.
    """
    plt.plot([cardinality(i) for i in range(1, n + 1)])
    plt.xlabel("n")
    plt.ylabel("cardinality")
    plt.yscale("log")
    plt.savefig("../../img/keen/wgp_cardinality.png")
    plt.show()


def main():
    plot_cardinality(10)


if __name__ == "__main__":
    main()
