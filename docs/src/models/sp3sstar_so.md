# SP3S* + Spin-Orbit Model

## Basis

20-band model that doubles the SP3S\* basis with explicit spin:

| Index 1-10 | Spin-up | Index 11-20 | Spin-down |
|------------|---------|-------------|-----------|
| ``s, p_x, p_y, p_z, s^*`` (anion) | ``\uparrow`` | ``s, p_x, p_y, p_z, s^*`` (anion) | ``\downarrow`` |
| ``s, p_x, p_y, p_z, s^*`` (cation) | ``\uparrow`` | ``s, p_x, p_y, p_z, s^*`` (cation) | ``\downarrow`` |

## Spin-Orbit Coupling

Spin-orbit interaction is added as an on-site coupling between p orbitals of different spin. The spin-orbit splitting parameter Δ controls the strength of the coupling.

## Available Parameter Sources

| Source | Materials |
|--------|-----------|
| [`Vogl1983`](@ref) | Si, Ge, C, Sn, SiC, GaAs, GaP, GaSb, AlAs, AlP, AlSb, InAs, InP, InSb, ZnSe, ZnTe |
| [`Klimeck2000`](@ref) | GaAs, GaP, GaSb, AlAs, AlP, AlSb, InAs, InP, InSb |

## When to Use

Required for materials with significant spin-orbit splitting, such as InSb, GaSb, and other heavy-element semiconductors where the split-off band energy is important.

## Reference

- G. Klimeck, R.C. Bowen, T.B. Boykin, T.A. Cwik, "sp3s\* tight-binding parameters for transport simulations in compound semiconductors," *Superlattices and Microstructures* **27**, 519 (2000). [DOI:10.1006/spmi.2000.0862](https://doi.org/10.1006/spmi.2000.0862)
