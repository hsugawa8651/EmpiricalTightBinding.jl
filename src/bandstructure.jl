# SPDX-License-Identifier: MIT
# Copyright (C) 2026 Hiroharu Sugawara
# Part of EmpiricalTightBinding.jl - BandStructure type
#= BandStructure: precomputed band structure data =#

# Extract material name for title
_mat_name(p::NamedTuple) = p.cation == p.anion ? p.cation : "$(p.cation)$(p.anion)"
_mat_name(p::Dict) = ""
_mat_name(::Any) = ""

"""
    BandStructure

Precomputed band structure data, independent of any plotting library.

# Fields
- `x::Vector{Float64}` — cumulative k-path distances
- `bands::Matrix{Float64}` — eigenvalues, `nk × nbands` (same units as input parameters)
- `tick_positions::Vector{Float64}` — high-symmetry point positions
- `tick_labels::Vector{String}` — high-symmetry point labels
- `title::String` — plot title
"""
struct BandStructure
    x::Vector{Float64}
    bands::Matrix{Float64}
    tick_positions::Vector{Float64}
    tick_labels::Vector{String}
    title::String
end

"""
    BandStructure(model::TBModel, kpath::KPath, params; align=:VBM, material="", title="")

Compute band structure and store the result.

# Arguments
- `model`: tight-binding model (e.g., `SP3Sstar()`)
- `kpath`: discretized k-path
- `params`: Slater-Koster parameters
- `align`: `:VBM` to shift VBM to 0, `:none` for raw eigenvalues
- `material`: material name for title (auto-detected from params if empty)
- `title`: custom title (auto-generated if empty)
"""
function BandStructure(model::TBModel, kpath::KPath, params;
                       align = :VBM, material = "", title = "")
    mat = material != "" ? material : _mat_name(params)
    bands = compute_bands(model, kpath, params; align, material = mat)
    ttl = title != "" ? title : "$mat $model"
    BandStructure(kpath.x, bands, kpath.tick_positions, kpath.tick_labels, ttl)
end
