# SPDX-License-Identifier: MIT
# Copyright (C) 2026 Hiroharu Sugawara
# Part of EmpiricalTightBinding.jl - Table parser
#=
Table parser: multiline string → Dict{String, Dict{Symbol, Float64}}

Format mirrors paper tables for easy verification:

              GaAs     GaP      Si
  a          5.6533   5.4505   5.4310
  Es_a      -8.3431  -8.1124  -4.2000
  ...
=#

"""
    parse_table(raw::String) -> Dict{String, Dict{Symbol, Float64}}

Parse a whitespace-separated table string into a nested Dict.
First non-empty line = material names (header).
Subsequent lines = parameter_name followed by values.
"""
function parse_table(raw::String)
    lines = filter(!isempty, strip.(split(raw, '\n')))
    isempty(lines) && return Dict{String,Dict{Symbol,Float64}}()

    # Header: material names
    materials = split(lines[1])

    # Initialize
    result = Dict{String,Dict{Symbol,Float64}}()
    for mat in materials
        result[mat] = Dict{Symbol,Float64}()
    end

    # Data lines
    for line in lines[2:end]
        tokens = split(line)
        length(tokens) < 2 && continue
        param = Symbol(tokens[1])
        for (j, mat) in enumerate(materials)
            idx = j + 1
            if idx <= length(tokens)
                result[mat][param] = parse(Float64, tokens[idx])
            end
        end
    end

    return result
end

# Cation/anion mapping
const ATOM_PAIRS = Dict{String,Tuple{String,String}}(
    # Diamond
    "C" => ("C", "C"),
    "Si" => ("Si", "Si"),
    "Ge" => ("Ge", "Ge"),
    "Sn" => ("Sn", "Sn"),
    # IV-IV
    "SiC" => ("Si", "C"),
    # III-V
    "AlP" => ("Al", "P"),
    "AlAs" => ("Al", "As"),
    "AlSb" => ("Al", "Sb"),
    "GaP" => ("Ga", "P"),
    "GaAs" => ("Ga", "As"),
    "GaSb" => ("Ga", "Sb"),
    "InP" => ("In", "P"),
    "InAs" => ("In", "As"),
    "InSb" => ("In", "Sb"),
    # II-VI
    "ZnSe" => ("Zn", "Se"),
    "ZnTe" => ("Zn", "Te"),
    "CdTe" => ("Cd", "Te"),
)

function _cation_anion(material::String)
    haskey(ATOM_PAIRS, material) && return ATOM_PAIRS[material]
    return (material, material)
end

"""Build SP3SstarParams from parsed table entry."""
function _to_sp3sstar(material::String, d::Dict{Symbol,Float64})
    c, a = _cation_anion(material)
    SP3SstarParams((
        c,
        a,
        d[:a],
        d[:Es_a],
        d[:Ep_a],
        d[:Estar_a],
        d[:Es_c],
        d[:Ep_c],
        d[:Estar_c],
        d[:Vss],
        d[:Vxx],
        d[:Vxy],
        d[:Vsapc],
        d[:Vscpa],
        d[:Vstar_apc],
        d[:Vpa_starc],
    ))
end

"""Build SP3Params from parsed table entry."""
function _to_sp3(material::String, d::Dict{Symbol,Float64})
    c, a = _cation_anion(material)
    SP3Params((
        c,
        a,
        d[:a],
        d[:Es_a],
        d[:Ep_a],
        d[:Es_c],
        d[:Ep_c],
        d[:Vss],
        d[:Vxx],
        d[:Vxy],
        d[:Vsapc],
        d[:Vscpa],
    ))
end
