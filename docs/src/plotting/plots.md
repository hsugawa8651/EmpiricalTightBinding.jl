# Plots.jl Integration

Band structures can be plotted using [Plots.jl](https://docs.juliaplots.org/stable/) via a [RecipesBase](https://github.com/JuliaPlots/RecipesBase.jl) recipe.

## Usage

```julia
using EmpiricalTightBinding, Plots

p = get_params(SP3Sstar, Vogl1983(), "GaAs")
kp = vogl_kpath()

bs = BandStructure(SP3Sstar(), kp, p)
plot(bs)
```

## Overlaying Band Structures

```julia
bs1 = BandStructure(SP3Sstar(), kp, p; title="GaAs: SP3S* vs SP3")
bs2 = BandStructure(SP3(), kp, get_params(SP3, Vogl1983(), "GaAs"))

plot(bs1)
plot!(bs2, linecolor=:blue, linestyle=:dash)
```

## Customization

All standard [Plots.jl](https://docs.juliaplots.org/stable/) keyword arguments are supported:

```julia
plot(bs; ylims=(-5, 10), size=(800, 600), linecolor=:red)
```
