# EmpiricalTightBinding.jl

[![CI](https://github.com/hsugawa8651/EmpiricalTightBinding.jl/actions/workflows/CI.yml/badge.svg)](https://github.com/hsugawa8651/EmpiricalTightBinding.jl/actions/workflows/CI.yml)
[![Stable Docs](https://img.shields.io/badge/docs-stable-blue.svg)](https://hsugawa8651.github.io/EmpiricalTightBinding.jl/stable/)
[![Dev Docs](https://img.shields.io/badge/docs-dev-blue.svg)](https://hsugawa8651.github.io/EmpiricalTightBinding.jl/dev/)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.19477635.svg)](https://doi.org/10.5281/zenodo.19477635)

Educational Julia package for empirical tight-binding band structure calculations of semiconductors.

## Three axes: Model, Source, Material

All calculations are specified by three independent choices:

```julia
using EmpiricalTightBinding

get_params(Model, Source(), "Material")
build_hamiltonian(Model(), k, params)
```

**Model** (Hamiltonian formulation):

| Type | Size | Orbitals |
|------|------|----------|
| `SP3` | 8x8 | s, p |
| `SP3Sstar` | 10x10 | s, p, s* |
| `SP3Sstar_SO` | 20x20 | s, p, s* + spin |
| `SP3D5Sstar` | 20x20 | s, p, d, s* |

**Source** (parameter set):

| Type | Reference | Materials |
|------|-----------|-----------|
| `Vogl1983()` | Vogl et al., J. Phys. Chem. Solids 44, 365 (1983) | 16 |
| `Klimeck2000()` | Klimeck et al., Superlattices Microstruct. 27, 519 (2000) | 9 |
| `Jancu1998()` | Jancu et al., Phys. Rev. B 57, 6493 (1998) | 12 |

**Material**: `"GaAs"`, `"Si"`, `"InP"`, etc.

## Quick start

```julia
using EmpiricalTightBinding
using Plots  # RecipesBase plot recipe

# GaAs band structure with sp3s* model
p = get_params(SP3Sstar, Vogl1983(), "GaAs")
kp = vogl_kpath()
bs = BandStructure(SP3Sstar(), kp, p)
plot(bs)
```

## Compare models

See how adding orbitals improves the band structure:

```julia
p = get_params(SP3Sstar, Vogl1983(), "GaP")
p_sp3 = get_params(SP3, Vogl1983(), "GaP")
kp = vogl_kpath()

bs1 = BandStructure(SP3Sstar(), kp, p)
bs2 = BandStructure(SP3(), kp, p_sp3)
plot(bs1)   # sp3s*
plot(bs2)   # sp3
```

## Compare parameter sources

Same model, different fitting methods:

```julia
kp = vogl_kpath()
p1 = get_params(SP3Sstar, Vogl1983(), "GaAs")
p2 = get_params(SP3Sstar, Klimeck2000(), "GaAs")

bs1 = BandStructure(SP3Sstar(), kp, p1)
bs2 = BandStructure(SP3Sstar(), kp, p2)
plot(bs1)   # Vogl1983
plot(bs2)   # Klimeck2000
```

## Three models for Si

```julia
kp = textbook_kpath()  # L -> Gamma -> X

p_vogl = get_params(SP3Sstar, Vogl1983(), "Si")
p_sp3 = get_params(SP3, Vogl1983(), "Si")
p_jancu = get_params(SP3D5Sstar, Jancu1998(), "Si")

bs1 = BandStructure(SP3Sstar(), kp, p_vogl)
bs2 = BandStructure(SP3(), kp, p_sp3)
bs3 = BandStructure(SP3D5Sstar(), kp, p_jancu)
plot(bs1)   # sp3s* (Vogl)
plot(bs2)   # sp3 (Vogl)
plot(bs3)   # sp3d5s* (Jancu)
```

## Available k-paths

```julia
vogl_kpath()      # L -> Gamma -> X -> U,K -> Gamma (Vogl Fig.1)
textbook_kpath()  # L -> Gamma -> X (simplified)
make_kpath([:L => :Gamma, :Gamma => :X, :X => :W])  # custom
```

## Error handling

Wrong argument types produce clear error messages:

```julia
build_hamiltonian(42, [0,0,0], p)
# ArgumentError: First argument must be a concrete TBModel instance, got Int64.

get_params(SP3Sstar, 42, "GaAs")
# ArgumentError: Second argument must be a concrete ParamSource instance, got Int64.
```

## References

1. Vogl, Hjalmarson, Dow (1983) - sp3s* model, J. Phys. Chem. Solids 44, 365
2. Jancu, Scholz, Beltram, Bassani (1998) - sp3d5s* model, Phys. Rev. B 57, 6493
3. Klimeck, Bowen, Boykin, Cwik (2000) - GA-optimized sp3s*, Superlattices Microstruct. 27, 519
