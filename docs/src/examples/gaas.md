# GaAs Band Structure

## Compute Band Structure

```julia
using EmpiricalTightBinding

p = get_params(SP3Sstar, Vogl1983(), "GaAs")
kp = vogl_kpath()
bs = BandStructure(SP3Sstar(), kp, p)

# Check band gap at Γ
evals = band_energies(SP3Sstar(), [0, 0, 0], p)
vbm = evals[4]
cbm = evals[5]
println("Direct gap at Γ: $(cbm - vbm) eV")
```

## Plot with Plots.jl

```julia
using Plots

plot(bs)
savefig("GaAs_bands_plots.png")
```

## Plot with PythonPlot (Publication Quality)

```julia
using PythonPlot

savefig_publication(bs, "GaAs_bands.pdf";
    axis_width_cm=8.0, axis_height_cm=6.0)
```

## Comparing with SP3

The [SP3](../models/sp3.md) model (without s\*) gives qualitatively different conduction bands:

```julia
p_sp3 = get_params(SP3, Vogl1983(), "GaAs")
bs_sp3 = BandStructure(SP3(), kp, p_sp3)
```
