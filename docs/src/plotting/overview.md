# Plotting Overview

EmpiricalTightBinding.jl provides two plotting paths:

| Method | Backend | Use Case |
|--------|---------|----------|
| `plot(bs)` | [Plots.jl](https://docs.juliaplots.org/stable/) via [RecipesBase](https://github.com/JuliaPlots/RecipesBase.jl) | Interactive exploration |
| `savefig_publication(bs, ...)` | [PythonPlot.jl](https://github.com/JuliaPy/PythonPlot.jl) ([matplotlib](https://matplotlib.org/)) | Publication figures with axis size control |

Both use the `BandStructure` type as the common data interface.
