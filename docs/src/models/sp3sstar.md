# SP3S* Model

## Basis

10-band model adding an excited s\* orbital to the [SP3](sp3.md) basis:

| Index | Anion | Cation |
|-------|-------|--------|
| 1, 6 | ``s`` | ``s`` |
| 2, 7 | ``p_x`` | ``p_x`` |
| 3, 8 | ``p_y`` | ``p_y`` |
| 4, 9 | ``p_z`` | ``p_z`` |
| 5, 10 | ``s^*`` | ``s^*`` |

## Parameters

Uses `SP3SstarParams` with 16 parameters, adding:

- On-site energies: Es\* for each atom
- Hopping integrals: Vs\*p and Vps\*

## Available Parameter Sources

| Source | Materials |
|--------|-----------|
| [`Vogl1983`](@ref) | Si, Ge, C, Sn, SiC, GaAs, GaP, GaSb, AlAs, AlP, AlSb, InAs, InP, InSb, ZnSe, ZnTe |
| [`Klimeck2000`](@ref) | GaAs, GaP, GaSb, AlAs, AlP, AlSb, InAs, InP, InSb |

## Key Feature

The excited s\* orbital corrects the conduction band at the X point, enabling correct prediction of indirect band gaps in Si and Ge. This is the model introduced by Vogl, Hjalmarson, and Dow (1983).

## Reference

- P. Vogl, H.P. Hjalmarson, J.D. Dow, "A semi-empirical tight-binding theory of the electronic structure of semiconductors," *J. Phys. Chem. Solids* **44**, 365-378 (1983). [DOI:10.1016/0022-3697(83)90064-1](https://doi.org/10.1016/0022-3697(83)90064-1)
