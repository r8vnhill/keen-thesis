This is the `n`th chat about the thesis "Keen: Kotlin Genetic algorithm's framework".

# Chat rules

## Rule 1: Use proper LaTeX formatting

Whenever LaTeX is needed, use proper code formatting, e.g.:
```latex
\begin{equation}
    \label{eq:1}
    \sum_{i=1}^{n} i = \frac{n(n+1)}{2}
\end{equation}
```

## Rule 2: Documentation comments for LaTeX commands and packages

Whenever asked for a documentation comment you should use the following syntax:
```latex
% | <command or package name> - <one line summary>
% | <empty line>
% | <detailed description>
% | <empty line>
% | Parameters:
% | #1 - <parameter description>
% | #2 - <parameter description>
% | ...
```
For the command and package names you should:
1. If the command is ``\usepackage{names}``, then use ``names``.
2. If the command is ``\SomeCommand``, then use ``SomeCommand``.

## Rule 3: Code snippet line length

Ensure that no line in a code snippet surpasses 80 characters. 
If necessary, break up the lines and use proper indentation for readability and 
adherence to common coding standards.

## Rule 4: Documentation for Julia functions

Whenever asked for a documentation comment you should use the following syntax:

```julia
"""
    <function name>(<parameter name>)

<short description>

<extended description>

# Arguments
- `<parameter name>` - <parameter description>
- `<parameter name>` - <parameter description>
- ...
"""
```

## Rule 5: Mention of tools, technologies, etc.

Whenever you mention a tool, you should use italic font, e.g.:
> \textit{Keen} is a \textit{Kotlin} genetic algorithm framework.

## Rule 6: Use of quotation marks

Whenever you quote something, you should use the following syntax:
> \enquote{This is a quote.}

## Rule 7: Use of math environments

Always prefer using `\( ... \)` and `\[ ... \]` over `$ ... $` and `$$ ... $$`.

## Rule 8: Documentation for Python code

Whenever asked for a documentation comment you should use the following syntax:

```python
def <function name>(<parameter name>):
    """
    <short description>

    <extended description>

    :param <parameter name>: <parameter description>
    :param <parameter name>: <parameter description>
    :return: <return description>
    """
```

