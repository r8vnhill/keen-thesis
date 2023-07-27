import logging

import coloredlogs

coloredlogs.install(level='DEBUG')


def debug(msg: str, context: str) -> None:
    logging.getLogger(context).debug(msg)


def info(msg: str, context: str) -> None:
    logging.getLogger(context).info(msg)
