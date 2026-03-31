# SP3 Model

## Basis

8-band model with s and three p orbitals on each atom:

| Index | Anion | Cation |
|-------|-------|--------|
| 1, 5 | ``s`` | ``s`` |
| 2, 6 | ``p_x`` | ``p_x`` |
| 3, 7 | ``p_y`` | ``p_y`` |
| 4, 8 | ``p_z`` | ``p_z`` |

## Parameters

The SP3 model uses `SP3Params` with 12 parameters:

- On-site energies: Es, Ep for each atom
- Hopping integrals: Vss, Vxx, Vxy, Vsapc, Vscpa

SP3 parameters can be extracted from SP3S\* parameters via `sp3_params`.

## Available Parameter Sources

| Source | Materials |
|--------|-----------|
| [`Vogl1983`](@ref) | Si, Ge, C, Sn, SiC, GaAs, GaP, GaSb, AlAs, AlP, AlSb, InAs, InP, InSb, ZnSe, ZnTe |
| [`Klimeck2000`](@ref) | GaAs, GaP, GaSb, AlAs, AlP, AlSb, InAs, InP, InSb |

## Limitations

The sp3 basis cannot reproduce indirect conduction band minima correctly. For quantitative work, use [SP3Sstar](sp3sstar.md) or higher models.
