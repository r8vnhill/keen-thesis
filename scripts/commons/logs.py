import logging

import coloredlogs


def debug(msg: str, context: object) -> None:
    """
    Logs a debug message.

    Args:
        msg: The message to be logged.
        context: The context in which the message is being logged. Used as the logger name.
    """
    logging.getLogger(str(context)).debug(msg)


def info(msg: str, context: object) -> None:
    """
    Logs an info message.

    Args:
        msg: The message to be logged.
        context: The context in which the message is being logged. Used as the logger name.
    """
    logging.getLogger(str(context)).info(msg)


def warning(msg: str, context: object) -> None:
    """
    Logs a warning message.

    Args:
        msg: The message to be logged.
        context: The context in which the message is being logged. Used as the logger name.
    """
    logging.getLogger(str(context)).warning(msg)


def error(msg: str, context: object) -> None:
    """
    Logs an error message.

    Args:
        msg: The message to be logged.
        context: The context in which the message is being logged. Used as the logger name.
    """
    logging.getLogger(str(context)).error(msg)


def critical(msg: str, context: object) -> None:
    """
    Logs a critical message.

    Args:
        msg: The message to be logged.
        context: The context in which the message is being logged. Used as the logger name.
    """
    logging.getLogger(str(context)).critical(msg)


def setup_logging() -> None:
    """Set up logging configurations."""
    logging.getLogger("matplotlib").setLevel(logging.WARNING)
    coloredlogs.install(level=logging.DEBUG)
