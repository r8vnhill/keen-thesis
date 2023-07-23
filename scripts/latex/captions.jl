include("../commons/option.jl")

"""
    struct Caption
      text::String
      label::Union{Option{String}, String}
    end

The `Caption` structure is used to represent the caption of an object (like a figure or table) in a
  document. 

# Fields
  - `text::String`: The main text of the caption.
  - `label::Union{Option{String}, String}`: The label associated with the caption.
    This can be used for referencing in the document.
    If there is no label, a `None` instance can be used.
"""
struct Caption
  text::String
  label::Union{Option{String}, String}
end

"""
    caption(text::String; label::Union{String, Option{String}} = None{String}())::Caption

Construct a Caption object with a provided text and optional label.

# Arguments
  - `text`: A `String` that represents the caption text.
  - `label` (optional): A `String` or `Option{String}` that represents the label of the caption. 
    The label can only contain alphanumeric characters, or any of the characters `:`, `-`, or `_`. 
    If not provided, the default is `None{String}()`.

# Returns
  - `Caption`: A `Caption` object that includes the caption text and label.

# Raises
  - `error`: If the label is not valid according to `_validate_label` function.
"""	
caption(text::AbstractString; label::Union{String, Option{String}} = None{String}())::Caption =
  if _validate_label(label)
    Caption(text, label)
  else
    error("Invalid label: $label")
  end
  
  """
  Base.show(io::IO, caption::Caption)::Nothing

Display a `Caption` object in a LaTeX-like format.

  This method overrides the `Base.show` function for the `Caption` struct. 
  It prints the caption text and its label (if any) in a format compatible 
  with LaTeX captions.

# Arguments
  - `io`: An IO stream to output to.
  - `caption`: A `Caption` object containing the text and possibly a label.

# Examples
  ```julia
  cap = caption("This is a caption", label = "valid:label_1")
  show(stdout, cap) # Outputs: \\caption{This is a caption}\\label{valid:label_1}
  ```
"""

Base.show(io::IO, ::MIME"text/latex", caption::Caption)::Nothing = print(
  io, 
  "\\caption{$(caption.text)}" *
    if !is_none(caption.label) "\n\\label{" * 
      unbox(caption.label) * "}"
    else "" end
)

"""
    _validate_label(label::String)::Bool
    _validate_label(label::Option{String})::Bool

Check whether a label string or an `Option{String}` containing a label is valid.

In this context, a valid label is one that contains only alphanumeric characters, or any of the 
characters `:`, `-`, or `_`.

# Arguments
- `label`: Either a `String` or an `Option{String}` containing the label to be checked.

# Returns
- `Bool`: `true` if the label is valid, and `false` otherwise.
"""
_validate_label(label::String)::Bool = 
  all(c -> isletter(c) || isdigit(c) || c in [':', '-', '_'], label)

_validate_label(label::Option{String})::Bool = 
  if is_some(label) _validate_label(unbox(label)) else true end
