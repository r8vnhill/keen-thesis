"""
    Option{T}

An abstract type representing a container that may or may not contain a value of a given type `T`.

The `Option` type is typically used to represent the result of a computation that may fail.
It provides a safer alternative to returning a special error value or `nothing` because the type
system forces the programmer to explicitly handle both the success and failure cases.

The actual data can be of type `Some{T}` if a value is present or `None{T}` if it's absent.
"""
abstract type Option{T} end

"""
    Some{T} <: Option{T}

A concrete type representing the presence of a value in an `Option` container.

`Some` is a parameterized type where `T` is the type of the value it contains.
"""
struct Some{T} <: Option{T}
  value::T
end

"""
    None{T} <: Option{T}

A concrete type representing the absence of a value in an `Option` container.

`None` is a parameterized type where `T` is the type of the value that could be present.
This is consistent with `Some{T}`, making `None` and `Some` both subtypes of `Option{T}`.
"""
struct None{T} <: Option{T} end

"""
    unbox(any)

Unwrap a value from a `Some` instance or directly return the value if it's not 
  an `Option`. Throws an error if the argument is a `None`.

This function is used to retrieve the value encapsulated within an instance of 
  `Some` or to return the original value if it's not an `Option`. It's commonly 
  used to simplify the extraction of values from `Option` instances in the 
  program's logic.

# Arguments
- `any`: The value to unbox. This can be an instance of `Some`, `None`, or any 
  other type.

# Returns
- If `any` is a `Some`, it returns the value it encapsulates.
- If `any` is not an `Option`, it returns `any` itself.
- If `any` is `None`, it throws an error.

# Examples
```julia
unbox(Some(42))  # Returns: 42
unbox("hello")   # Returns: "hello"
unbox(None())    # Throws an error
```
"""
unbox(any) = if !is_none(any)
  if is_some(any)
    any.value
  else
    any
  end
else
  error("Cannot get value from None")
end

"""
    is_some(opt)

Checks if an `Option` type container contains a value.

The `is_some` function is used to check if an `Option` type container contains
a value. If `opt` is of type `Some`, `true` will be returned. If `opt` is of
type `None`, `false` will be returned.

# Arguments
  - `opt` : The `Option` type variable to be checked.

# Returns
  - `true` if `opt` is of type `Some`.
  - `false` if `opt` is of type `None`.
"""
is_some(opt) = opt isa Some

"""
    is_none(opt)

Checks if an `Option` type container does not contain a value.

The `is_none` function is used to check if an `Option` type container does not
contain a value. If `opt` is of type `None`, `true` will be returned. If `opt`
is of type `Some`, `false` will be returned.

# Arguments
  - `opt` : The `Option` type variable to be checked.

# Returns
  - `true` if `opt` is of type `None`.
  - `false` if `opt` is of type `Some`.
"""
is_none(opt) = opt isa None
