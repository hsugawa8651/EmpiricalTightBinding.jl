# Models Overview

EmpiricalTightBinding.jl provides a hierarchy of tight-binding models with increasing complexity.

## Model Comparison

| Model | Orbitals per atom | Bands | Spin-Orbit | Reference |
|-------|-------------------|-------|------------|-----------|
| [SP3](sp3.md) | s, p | 8 | No | — |
| [SP3Sstar](sp3sstar.md) | s, p, s\* | 10 | No | Vogl et al. (1983) |
| [SP3Sstar\_SO](sp3sstar_so.md) | s, p, s\* × spin | 20 | Yes | Klimeck et al. (2000) |
| [SP3D5Sstar](sp3d5sstar.md) | s, p, d, s\* | 20 | No | Jancu et al. (1998) |

## Choosing a Model

- **[SP3](sp3.md)**: Simplest model. Gives qualitatively correct valence bands but poor conduction bands (no indirect gap in Si/Ge).
- **[SP3Sstar](sp3sstar.md)**: Adds an excited s\* orbital to fix the conduction band issue. The standard choice for most applications.
- **[SP3Sstar\_SO](sp3sstar_so.md)**: Adds spin-orbit coupling. Required for materials with significant spin-orbit (SO) splitting (e.g., InSb, GaSb).
- **[SP3D5Sstar](sp3d5sstar.md)**: Adds d orbitals for improved accuracy across the full Brillouin zone. Best for quantitative work.