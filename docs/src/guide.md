# Getting Started

## Basic Workflow

A typical band structure calculation has three steps:

### 1. Choose model and parameters

```julia
using EmpiricalTightBinding

# SP3S* model with Vogl (1983) parameters for GaAs
p = get_params(SP3Sstar, Vogl1983(), "GaAs")
```

Available combinations depend on which parameter sources support which models:

| Source | Models | Materials |
|--------|--------|-----------|
| [`Vogl1983`](@ref) | [SP3](models/sp3.md), [SP3Sstar](models/sp3sstar.md) | Si, Ge, GaAs, GaP, InAs, InP, ... |
| [`Jancu1998`](@ref) | [SP3D5Sstar](models/sp3d5sstar.md) | Si, Ge, GaAs, ... |
| [`Klimeck2000`](@ref) | [SP3Sstar](models/sp3sstar.md) | GaAs, InAs, ... |

Use [`list_materials`](@ref) to see available materials:

```julia
list_materials(Vogl1983())
```

### 2. Build a k-path

```julia
# Predefined Vogl Fig.1 path: L → Γ → X → U,K → Γ
kp = vogl_kpath()

# Or a simple textbook path: L → Γ → X
kp = textbook_kpath()

# Or custom
kp = make_kpath([:L => :Γ, :Γ => :X])
```

See [K-Paths & Brillouin Zone](kpaths.md) for details on [`vogl_kpath`](@ref), [`textbook_kpath`](@ref), and [`make_kpath`](@ref).

### 3. Compute band structure

```julia
bands = compute_bands(SP3Sstar(), kp, p)
# Returns nk × nbands matrix, VBM aligned to 0
```

[`compute_bands`](@ref) returns a matrix of eigenvalues (in the same units as the input parameters), with the valence band maximum aligned to 0 by default.

## Single k-point Calculation

For eigenvalues at a single k-point, use [`band_energies`](@ref):

```julia
evals = band_energies(SP3Sstar(), [0.0, 0.0, 0.0], p)
```

## Direct Hamiltonian Access

Use [`build_hamiltonian`](@ref) to get the Hamiltonian matrix directly:

```julia
H = build_hamiltonian(SP3Sstar(), [0.3, 0.2, 0.1], p)
# Returns Hermitian{ComplexF64} matrix
```
