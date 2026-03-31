# SPDX-License-Identifier: MIT
# Copyright (C) 2026 Hiroharu Sugawara
# Part of EmpiricalTightBinding.jl - Error fallback methods
#= Error fallback methods
Called when arguments don't match any concrete implementation. =#

# ── get_params fallbacks ──

# Valid types, but no implementation for this model-source combination
function get_params(::Type{T}, ::S, material::String) where {T<:TBModel,S<:ParamSource}
    throw(ArgumentError("No parameters for model=$T from source=$S."))
end

# Correct model type, wrong source type
function get_params(::Type{T}, source, material::String) where {T<:TBModel}
    throw(
        ArgumentError(
            "Second argument must be a concrete ParamSource instance, got $(typeof(source)).",
        ),
    )
end

# Wrong model type, correct source
function get_params(model, ::S, material::String) where {S<:ParamSource}
    throw(
        ArgumentError(
            "First argument must be a concrete TBModel type, got $(typeof(model)).",
        ),
    )
end

# Both wrong
function get_params(model, source, material)
    throw(
        ArgumentError(
            "get_params requires (Type{<:TBModel}, ParamSource, String), " *
            "got ($(typeof(model)), $(typeof(source)), $(typeof(material))).",
        ),
    )
end

# ── list_materials fallbacks ──

"""
    list_materials(source::ParamSource)

Print available materials for a given parameter source.
The output format varies by source (e.g., crystal type, lattice constant).

# Example
```julia
list_materials(Vogl1983())
list_materials(Jancu1998())
```
"""
function list_materials(::S) where {S<:ParamSource}
    throw(ArgumentError("No material list for source $S."))
end

function list_materials(source)
    throw(
        ArgumentError(
            "list_materials requires a concrete ParamSource instance, got $(typeof(source)).",
        ),
    )
end

# ── savefig_publication fallbacks ──
# Note: BandStructure + AbstractString methods are defined in
# ext/EmpiricalTightBindingPythonPlotExt.jl (loaded by `using PythonPlot`).
# These fallbacks catch wrong types or missing extension.

function savefig_publication(data::Union{BandStructure,AbstractVector{<:BandStructure}},
                             path; kwargs...)
    if path isa AbstractString
        throw(ArgumentError(
            "savefig_publication requires PythonPlot.jl. Run `using PythonPlot` first."
        ))
    else
        throw(ArgumentError(
            "Second argument must be a file path (AbstractString), got $(typeof(path))."
        ))
    end
end

function savefig_publication(data, path; kwargs...)
    if data isa Union{BandStructure,AbstractVector{<:BandStructure}}
        # Should not reach here, but just in case
        throw(ArgumentError(
            "savefig_publication requires PythonPlot.jl. Run `using PythonPlot` first."
        ))
    else
        throw(ArgumentError(
            "First argument must be a BandStructure or Vector{BandStructure}, " *
            "got $(typeof(data))."
        ))
    end
end
