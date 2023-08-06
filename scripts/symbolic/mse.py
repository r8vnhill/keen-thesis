from symbolic.functions import Function
from symbolic.samples import Sample


def mse(observed: list[float], predicted: list[float]) -> float:
    """
    Computes the Mean Squared Error (MSE) between two lists of numbers.

    Mean Squared Error is a common metric used in regression problems in the field of machine learning.
    It is used to quantify the difference between the predicted numerical values output by a model and the actual
    numerical values.

    It does this by squaring the differences between each predicted and actual value, adding all these square
    differences together, and then dividing by the number of data points.
    This has the effect of 'punishing' larger errors more due to the squaring operation.

    Mathematically, if 'n' is the number of data points, 'Y' is the list of observed values, and 'Y_hat' is the list of
    predicted values, the MSE is computed as:

        ``MSE = (1 / n) * sum((Y_i - Y_hat_i) ^ 2) for all i in range(n)``

    :param observed: The list of observed (actual) values.
    :param predicted: The list of predicted (estimated) values.

    :returns: The computed mean squared error, a single float value.
              This value is always non-negative, and a value of 0 indicates a perfect fit to the data.
              In general, lower MSE values represent better fits to the data.
    """
    return sum([(o - p) ** 2 for o, p in zip(observed, predicted)]) / len(observed)


# Utility functions
def function_mse(func: Function, samples: list[Sample]) -> float:
    predicted = [func(x) for x, _ in samples]
    actual = [y for _, y in samples]
    return mse(predicted, actual)
