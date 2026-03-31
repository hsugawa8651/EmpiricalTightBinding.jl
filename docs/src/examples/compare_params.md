# Comparing Parameter Sets

## GaAs: Vogl 1983 vs Klimeck 2000

Different parameter sources are fitted with different objectives:

- **[`Vogl1983`](@ref)**: Fitted to reproduce key band energies at high-symmetry points.
- **[`Klimeck2000`](@ref)**: Genetically optimized to reproduce band edge effective masses and deformation potentials.

```julia
using EmpiricalTightBinding

kp = vogl_kpath()

# Vogl (1983)
p_vogl = get_params(SP3Sstar, Vogl1983(), "GaAs")
bs_vogl = BandStructure(SP3Sstar(), kp, p_vogl; title="GaAs: Vogl 1983")

# Klimeck (2000)
p_klim = get_params(SP3Sstar, Klimeck2000(), "GaAs")
bs_klim = BandStructure(SP3Sstar(), kp, p_klim; title="GaAs: Klimeck 2000")
```

## Band Gap Comparison

```julia
gap_vogl = band_energies(SP3Sstar(), [0,0,0], p_vogl) |> e -> e[5] - e[4]
gap_klim = band_energies(SP3Sstar(), [0,0,0], p_klim) |> e -> e[5] - e[4]

println("Vogl 1983:    $(round(gap_vogl, digits=3)) eV")
println("Klimeck 2000: $(round(gap_klim, digits=3)) eV")
println("Experiment:   1.519 eV")
```

### Plot with Plots.jl

```julia
using Plots

plot(bs_vogl)
plot!(bs_klim, linecolor=:blue, linestyle=:dash)
savefig("GaAs_vogl_vs_klimeck_plots.png")
```

### Plot with PythonPlot (Publication Quality)

```julia
using PythonPlot

savefig_publication([bs_vogl, bs_klim], "GaAs_vogl_vs_klimeck.pdf";
    axis_width_cm=8.0, axis_height_cm=6.0,
    layout=(1, 2))
```
