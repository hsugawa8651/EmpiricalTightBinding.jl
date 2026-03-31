# Publication Figures

For publication-quality figures with precise axis dimensions, use `savefig_publication` which calls [matplotlib](https://matplotlib.org/) directly via [PythonPlot.jl](https://github.com/JuliaPy/PythonPlot.jl).

## Motivation

[Plots.jl](https://docs.juliaplots.org/stable/) does not support specifying axis (plot area) dimensions directly -- only figure size can be set. For journal submissions, precise control over axis dimensions is often required. [matplotlib](https://matplotlib.org/) provides this via `fig.add_axes` and `fig.set_size_inches`.

## Usage

```julia
using EmpiricalTightBinding, PythonPlot

p = get_params(SP3Sstar, Vogl1983(), "GaAs")
kp = vogl_kpath()
bs = BandStructure(SP3Sstar(), kp, p)

savefig_publication(bs, "bands.pdf";
    axis_width_cm=8.0, axis_height_cm=6.0)
```

## Subplot Support

```julia
bs1 = BandStructure(SP3Sstar(), kp, p)
bs2 = BandStructure(SP3(), kp, get_params(SP3, Vogl1983(), "GaAs"))

savefig_publication([bs1, bs2], "compare.pdf";
    axis_width_cm=6.0, axis_height_cm=5.0,
    layout=(1, 2))
```
