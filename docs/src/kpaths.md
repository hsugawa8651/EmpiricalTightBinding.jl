# K-Paths & Brillouin Zone

## FCC Brillouin Zone

EmpiricalTightBinding.jl provides high-symmetry k-points for the FCC/zinc-blende Brillouin zone (in units of 2π/a):

| Point | Coordinates |
|-------|-------------|
| Γ | (0, 0, 0) |
| X | (1, 0, 0) |
| L | (1/2, 1/2, 1/2) |
| K | (3/4, 3/4, 0) |
| U | (1, 1/4, 1/4) |
| W | (1, 1/2, 0) |

## Predefined Paths

- `vogl_kpath(; nk=100)`: L → Γ → X → U,K → Γ (Vogl Fig.1)
- `textbook_kpath(; nk=100)`: L → Γ → X

## Custom Paths

Build custom paths with `make_kpath`:

```julia
# W → L → Γ → X → W → K
kp = make_kpath([:W => :L, :L => :Γ, :Γ => :X, :X => :W, :W => :K])
```

### Discontinuities

Use `nothing` to indicate a jump (e.g., U,K point in the Vogl path):

```julia
kp = make_kpath([
    :L => :Γ, :Γ => :X, :X => :U,
    nothing,
    :K => :Γ
])
```
