# EmpiricalTightBinding.jl

Empirical tight-binding band structure calculations for zinc-blende semiconductors.

## Features

- Multiple tight-binding models: [SP3](models/sp3.md), [SP3S\*](models/sp3sstar.md), [SP3S\*+SO](models/sp3sstar_so.md), [SP3D5S\*](models/sp3d5sstar.md)
- Multiple parameter sources: Vogl 1983, Jancu 1998, Klimeck 2000
- Flexible k-path construction for FCC Brillouin zone
- Plot recipes for [Plots.jl](https://docs.juliaplots.org/stable/) integration

## Quick Start

```julia
using EmpiricalTightBinding
using Plots

# Get parameters
p = get_params(SP3Sstar, Vogl1983(), "GaAs")

# Build k-path
kp = vogl_kpath()

# Compute and plot band structure
bands = compute_bands(SP3Sstar(), kp, p)
```

## Installation

```julia
using Pkg
Pkg.add("EmpiricalTightBinding")
```

## Design Concept: Model × Source × Material

EmpiricalTightBinding.jl is organized around three orthogonal axes:

| Axis | Examples |
|------|----------|
| **Model** (basis set) | [`SP3`](models/sp3.md), [`SP3Sstar`](models/sp3sstar.md), [`SP3Sstar_SO`](models/sp3sstar_so.md), [`SP3D5Sstar`](models/sp3d5sstar.md) |
| **Source** (parameter set) | [`Vogl1983`](@ref), [`Jancu1998`](@ref), [`Klimeck2000`](@ref) |
| **Material** | `"GaAs"`, `"Si"`, `"InP"`, ... |

Parameters are retrieved by specifying all three:

```julia
p = get_params(SP3Sstar, Vogl1983(), "GaAs")
```
