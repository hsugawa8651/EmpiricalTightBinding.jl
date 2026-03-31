# SP3D5S* Model

## Basis

20-band model adding five d orbitals per atom to the SP3S\* basis:

| Index | Anion | Cation |
|-------|-------|--------|
| 1, 11 | ``s`` | ``s`` |
| 2-4, 12-14 | ``p_x, p_y, p_z`` | ``p_x, p_y, p_z`` |
| 5-9, 15-19 | ``d_{xy}, d_{yz}, d_{zx}, d_{x^2-y^2}, d_{3z^2-r^2}`` | ``d_{xy}, \ldots`` |
| 10, 20 | ``s^*`` | ``s^*`` |

## Parameters

Uses an extended parameter set with additional Slater-Koster integrals:
- d on-site energies
- s-d, p-d, and d-d hopping integrals

## Available Parameter Sources

| Source | Materials |
|--------|-----------|
| [`Jancu1998`](@ref) | Si, Ge, C, Sn, SiC, GaAs, GaP, GaSb, AlAs, AlP, AlSb, InAs, InP, InSb, ZnSe, ZnTe |

## Key Feature

The d orbitals provide improved accuracy for the full Brillouin zone, particularly for higher conduction bands.

## Reference

- J.-M. Jancu, R. Scholz, F. Beltram, F. Bassani, "Empirical spds\* tight-binding calculation for cubic semiconductors: General method and material parameters," *Phys. Rev. B* **57**, 6493 (1998). [DOI:10.1103/PhysRevB.57.6493](https://doi.org/10.1103/PhysRevB.57.6493)
