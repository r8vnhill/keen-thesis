import logging
from logging import getLogger
from math import floor

import matplotlib.colors as colors
import matplotlib.pyplot as plt
import numpy as np
from matplotlib.ticker import MultipleLocator

from commons import debug
from latex import math


def _get_ticks_and_norm(log_scale: bool, zss: np.ndarray):
    """
    Calculates tick marks and normalization for a plot, based on whether a logarithmic scale is used.

    If the log_scale argument is True, the function calculates the tick marks for the logarithmic scale and returns
    a LogNorm instance for normalizing input data into the [0,1] range. If log_scale is False, the function returns
    None for both ticks and norm.

    Args:
        log_scale (bool): If True, the tick marks for a logarithmic scale are calculated and a LogNorm instance is
        returned. If False, None is returned for both ticks and norm.
        zss (np.ndarray): A 2D NumPy array representing the z-values in a surface plot or contour plot.

    Returns:
        ticks: Tick mark locations. These are calculated based on the range of zss if log_scale is True; otherwise,
               None.
        norm: A LogNorm instance if log_scale is True; otherwise, None.

    Logs:
        If log_scale is True, a debug-level log message indicating that a logarithmic scale is used.
    """
    # Check if log scale is to be used
    if log_scale:
        debug("Using log scale.", __name__)

        # Compute the max and min values in the zss array
        max_z = np.max(zss)
        min_z = np.min(zss)
        # Compute the step for the tick marks
        step = (max_z - min_z) / 4
        # Calculate the tick mark locations for the logarithmic scale
        ticks = [
            math("10^{i}") if floor(i) == 0 else math(f"10^{floor(i)}")
            for i in np.arange(min_z, max_z + step, step)
        ]
        # Create a LogNorm instance for normalizing input data into the [0,1] range
        norm = colors.LogNorm()
    else:
        # If not log scale, no special tick marks or normalization are needed
        ticks = None
        norm = None
    return ticks, norm


def _draw_contour(xs, ys, zss, minima, name, log_scale=False):
    print(f"Drawing contour plot for {name}...")
    fig, ax = plt.subplots()

    ticks, norm = _get_ticks_and_norm(log_scale, zss)
    cs = ax.contourf(xs, ys, zss, levels=100, cmap="batlowK50", norm=norm)
    cb = fig.colorbar(cs, ticks=ticks)
    cb.ax.tick_params(labelsize=12)
    cs = ax.contour(xs, ys, zss, levels=10, linewidths=0.5, colors="phase", alpha=0.8)

    ax.scatter([p[0] for p in minima], [p[1] for p in minima], color="red", s=36)
    ax.set_xlabel("$x$", fontsize=14)
    ax.set_ylabel("$y$", fontsize=14)

    filename = f"img/test_functions/{name}_contour.png"
    plt.savefig(filename)
    plt.show()

    return filename


def _draw_surface(xs, ys, zss, name, log_scale=False):
    print(f"Drawing surface plot for {name}...")
    fig = plt.figure()
    ax = fig.add_subplot(111, projection="3d")

    ticks, norm = _get_ticks_and_norm(log_scale, zss)
    surf = ax.plot_surface(xs, ys, zss, cmap="batlowK50", norm=norm)
    cb = fig.colorbar(surf, ticks=ticks)

    ax.set_xlabel("$x$", fontsize=14)
    ax.set_ylabel("$y$", fontsize=14)

    filename = f"img/test_functions/{name}_surface.png"
    plt.savefig(filename)
    plt.show()

    return filename


def draw(
    x_range=(-100, 100),
    y_range=(-100, 100),
    granularity=0.01,
    f=None,
    minima=[],
    name="",
    log_scale=False,
):
    xs = np.arange(*x_range, step=granularity)
    ys = np.arange(*y_range, step=granularity)
    xs, ys = np.meshgrid(xs, ys)
    zss = np.log10(f(xs, ys)) if log_scale else f(xs, ys)

    return [
        _draw_contour(xs, ys, zss, minima, name, log_scale),
        _draw_surface(xs, ys, zss, name, log_scale),
    ]


def draw_lines(
    fs,
    x_lim,
    names,
    line_styles=[(2, "solid")],
    title="",
    x_label="",
    y_label="",
    filename="",
):
    assert len(fs) == len(names), "The number of functions and names must be equal."

    if isinstance(line_styles, tuple):
        line_styles = [line_styles] * len(fs)
    else:
        assert len(fs) == len(
            line_styles
        ), "The number of functions and line styles must be equal."

    print("Drawing line plot...")

    fig, ax = plt.subplots()
    x = np.linspace(*x_lim, 1000)

    for f, name, line_style in zip(fs, names, line_styles):
        ax.plot(x, f(x), label=name, linewidth=line_style[0], linestyle=line_style[1])

    ax.set_title(title)
    ax.set_xlabel(x_label)
    ax.set_ylabel(y_label)
    ax.legend(loc="lower right")
    ax.xaxis.set_major_locator(MultipleLocator(0.2))
    ax.yaxis.set_major_locator(MultipleLocator(0.2))
    fig.tight_layout()
    plt.savefig(filename)


if __name__ == "__main__":
    logging.basicConfig(level=logging.DEBUG)
    print(_get_ticks_and_norm(True, np.array([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])))
