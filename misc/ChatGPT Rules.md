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