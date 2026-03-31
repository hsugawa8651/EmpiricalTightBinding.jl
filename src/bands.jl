# SPDX-License-Identifier: MIT
# Copyright (C) 2026 Hiroharu Sugawara
# Part of EmpiricalTightBinding.jl - Band structure computation
#= Band structure computation =#

"""
    n_valence(model::TBModel, material::String) -> Int

Number of filled valence bands.
Without spin-orbit: 4 (8 electrons / 2 spin).
With spin-orbit: 8 (spin explicitly in basis).
"""
n_valence(::TBModel, ::String) = 4

"""
    compute_bands(model::TBModel, kpath::KPath, params;
                  align=:VBM, material="") -> Matrix{Float64}

Compute eigenvalues along a k-path.
Returns `nk × nbands` matrix of eigenvalues (in the same units as the input parameters).

- `align=:VBM`: shift so VBM = 0 (requires `material` for n_valence)
- `align=:none`: no shift (raw eigenvalues)
"""
function compute_bands(model::TBModel, kpath::KPath, params; align = :VBM, material = "")
    nbands = hamiltonian_size(model)
    nk = length(kpath.kpoints)
    bands = zeros(nk, nbands)
    for (ik, k) in enumerate(kpath.kpoints)
        H = build_hamiltonian(model, k, params)
        bands[ik, :] = eigvals(H)
    end

    if align == :VBM
        nv = min(n_valence(model, material), nbands)
        vbm = maximum(bands[:, nv])
        bands .-= vbm
    end

    return bands
end

"""
    band_energies(model::TBModel, k, params) -> Vector{Float64}

Compute eigenvalues at a single k-point (raw, no shift).
"""
function band_energies(model::TBModel, k, params)
    H = build_hamiltonian(model, k, params)
    return eigvals(H)
end

export n_valence
