# Theory

## Empirical Tight-Binding Method

The empirical tight-binding method expands electronic states in a basis of atomic-like orbitals localized on each atom. For a zinc-blende crystal with two atoms per unit cell (anion and cation), the Bloch Hamiltonian at wave vector ``\mathbf{k}`` takes the form:

```math
H(\mathbf{k}) = \begin{pmatrix} E_a & V(\mathbf{k}) \\ V^\dagger(\mathbf{k}) & E_c \end{pmatrix}
```

where ``E_a`` and ``E_c`` are diagonal on-site energy matrices for the anion and cation, ``V(\mathbf{k})`` contains the hopping (off-diagonal) terms modulated by structure factors, and ``V^\dagger`` is the conjugate transpose of ``V``.

## Structure Factors

For the zinc-blende structure (FCC lattice with two-atom basis), the nearest-neighbor structure factors are:

```math
g_0(\mathbf{k}) = \frac{1}{4}\left(e^{i\pi(k_1+k_2+k_3)/2} + e^{i\pi(-k_1-k_2+k_3)/2} + e^{i\pi(-k_1+k_2-k_3)/2} + e^{i\pi(k_1-k_2-k_3)/2}\right)
```

with ``g_1, g_2, g_3`` formed by sign changes on the individual exponentials. These factors encode the crystal geometry and modulate the Slater-Koster hopping integrals.

## Slater-Koster Parameters

The hopping matrix elements between orbitals are parameterized using the Slater-Koster two-center integrals (``V_{ss\sigma}``, ``V_{sp\sigma}``, ``V_{pp\sigma}``, ``V_{pp\pi}``, etc.). These parameters are fitted to reproduce experimental or first-principles band structures at high-symmetry points.

## References

- J.C. Slater, G.F. Koster, "Simplified LCAO Method for the Periodic Potential Problem," *Phys. Rev.* **94**, 1498 (1954). [DOI:10.1103/PhysRev.94.1498](https://doi.org/10.1103/PhysRev.94.1498)
- See also the [References](references.md) page for parameter source publications.
