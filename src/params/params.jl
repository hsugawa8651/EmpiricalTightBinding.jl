# SPDX-License-Identifier: MIT
# Copyright (C) 2026 Hiroharu Sugawara
# Part of EmpiricalTightBinding.jl - Parameter types
#= Parameter source types =#

"""Abstract root for parameter sources."""
abstract type ParamSource end

"""
    list_sources() -> Vector

Return all available parameter source types (subtypes of `ParamSource`).
Includes sources added at runtime.

# Example
```julia
list_sources()
# 3-element Vector{Any}:
#  Jancu1998
#  Klimeck2000
#  Vogl1983
```
"""
list_sources() = subtypes(ParamSource)

"""
    Vogl1983

P. Vogl, H.P. Hjalmarson, J.D. Dow,
"A semi-empirical tight-binding theory of the electronic structure of semiconductors,"
*J. Phys. Chem. Solids* **44**, 365-378 (1983).
DOI: [10.1016/0022-3697(83)90064-1](https://doi.org/10.1016/0022-3697(83)90064-1)

sp³s* parameters for group-IV and III-V zinc-blende semiconductors.
All energies are in eV.
Supports models: `SP3`, `SP3Sstar`, `SP3Sstar_SO`.
"""
struct Vogl1983 <: ParamSource end

"""
    Klimeck2000

G. Klimeck, R.C. Bowen, T.B. Boykin, T.A. Cwik,
"sp3s* tight-binding parameters for transport simulations in compound semiconductors,"
*Superlattices and Microstructures* **27**, 519 (2000).
DOI: [10.1006/spmi.2000.0862](https://doi.org/10.1006/spmi.2000.0862)

Genetically-optimized sp³s*+SO parameters for III-V compound semiconductors.
All energies are in eV.
Supports models: `SP3`, `SP3Sstar`, `SP3Sstar_SO`.
"""
struct Klimeck2000 <: ParamSource end

"""
    Jancu1998

J.-M. Jancu, R. Scholz, F. Beltram, F. Bassani,
"Empirical spds* tight-binding calculation for cubic semiconductors:
General method and material parameters,"
*Phys. Rev. B* **57**, 6493 (1998).
DOI: [10.1103/PhysRevB.57.6493](https://doi.org/10.1103/PhysRevB.57.6493)

sp³d⁵s* parameters for group-IV and III-V zinc-blende semiconductors.
All energies are in eV.
Supports model: `SP3D5Sstar`.
"""
struct Jancu1998 <: ParamSource end

#= Parameter types for each model =#

# SP3: 12 parameters (6 on-site + 4 transfer + cation/anion/a)
const SP3Params = @NamedTuple{
    cation::String,
    anion::String,
    a::Float64,
    Es_a::Float64,
    Ep_a::Float64,
    Es_c::Float64,
    Ep_c::Float64,
    Vss::Float64,
    Vxx::Float64,
    Vxy::Float64,
    Vsapc::Float64,
    Vscpa::Float64,
}

# SP3Sstar: 16 parameters (SP3 + 4 for s*)
const SP3SstarParams = @NamedTuple{
    cation::String,
    anion::String,
    a::Float64,
    Es_a::Float64,
    Ep_a::Float64,
    Estar_a::Float64,
    Es_c::Float64,
    Ep_c::Float64,
    Estar_c::Float64,
    Vss::Float64,
    Vxx::Float64,
    Vxy::Float64,
    Vsapc::Float64,
    Vscpa::Float64,
    Vstar_apc::Float64,
    Vpa_starc::Float64,
}

"""
    sp3_params(p::SP3SstarParams) -> SP3Params

Extract the sp3 subset from sp3s* parameters.
"""
function sp3_params(p::SP3SstarParams)
    return SP3Params((
        p.cation,
        p.anion,
        p.a,
        p.Es_a,
        p.Ep_a,
        p.Es_c,
        p.Ep_c,
        p.Vss,
        p.Vxx,
        p.Vxy,
        p.Vsapc,
        p.Vscpa,
    ))
end
