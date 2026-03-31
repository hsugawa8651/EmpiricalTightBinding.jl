# Comparing Models

## SP3 vs SP3S* for GaAs

The key difference between [SP3](../models/sp3.md) and [SP3S\*](../models/sp3sstar.md) is the treatment of conduction bands. The excited s\* orbital in SP3S\* corrects the X-point conduction band minimum.

```julia
using EmpiricalTightBinding

kp = vogl_kpath()

# SP3S* model
p_sstar = get_params(SP3Sstar, Vogl1983(), "GaAs")
bs_sstar = BandStructure(SP3Sstar(), kp, p_sstar; title="GaAs: SP3S* vs SP3")

# SP3 model
p_sp3 = get_params(SP3, Vogl1983(), "GaAs")
bs_sp3 = BandStructure(SP3(), kp, p_sp3)
```

### Plot with Plots.jl

```julia
using Plots

plot(bs_sstar)
plot!(bs_sp3, linecolor=:blue, linestyle=:dash)
savefig("GaAs_sp3_vs_sp3sstar_plots.png")
```

### Plot with PythonPlot (Publication Quality)

```julia
using PythonPlot

savefig_publication([bs_sstar, bs_sp3], "GaAs_sp3_vs_sp3sstar.pdf";
    axis_width_cm=8.0, axis_height_cm=6.0,
    layout=(1, 2))
```

## SP3D5S* for Higher Accuracy

The [SP3D5S\*](../models/sp3d5sstar.md) model with [`Jancu1998`](@ref) parameters provides improved accuracy across the full Brillouin zone:

```julia
p_d = get_params(SP3D5Sstar, Jancu1998(), "GaAs")
bs_d = BandStructure(SP3D5Sstar(), kp, p_d)
```

### Plot with Plots.jl

```julia
using Plots

plot(bs_d)
savefig("GaAs_sp3d5sstar_plots.png")
```

### Plot with PythonPlot (Publication Quality)

```julia
using PythonPlot

savefig_publication(bs_d, "GaAs_sp3d5sstar.pdf";
    axis_width_cm=8.0, axis_height_cm=6.0)
```
