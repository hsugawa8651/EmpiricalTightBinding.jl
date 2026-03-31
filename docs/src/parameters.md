# Parameter Sources

## Overview

Parameters are retrieved using the three-axis dispatch: Model × Source × Material.

```julia
p = get_params(SP3Sstar, Vogl1983(), "GaAs")
```

## Available Sources

### Vogl 1983

Covers [SP3](models/sp3.md) and [SP3S\*](models/sp3sstar.md) models for a wide range of III-V and group-IV semiconductors.

### Jancu 1998

Provides [SP3D5S\*](models/sp3d5sstar.md) parameters fitted to reproduce full-zone band structures.

### Klimeck 2000

Genetically-optimized [SP3S\*+SO](models/sp3sstar_so.md) parameters for accurate band edge properties.

## Parameter Types

- `SP3Params`: NamedTuple with 12 parameters (on-site energies and hopping integrals for sp3 basis)
- `SP3SstarParams`: NamedTuple with 16 parameters (adds excited s\* energies and hoppings)

SP3 parameters can be extracted from SP3S\* parameters via `sp3_params`.

## Listing Available Materials

```julia
list_materials(Vogl1983())
```

## Convenience Instances

The singleton instances `VOGL1983`, `JANCU1998`, and `KLIMECK2000` are also exported:

```julia
p = get_params(SP3Sstar, VOGL1983, "GaAs")  # equivalent
```
