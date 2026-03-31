# SPDX-License-Identifier: MIT
# Copyright (C) 2026 Hiroharu Sugawara
# Part of EmpiricalTightBinding.jl - Plotting stubs
#=
Plotting stubs — actual implementations in extensions:
- ext/EmpiricalTightBindingRecipesBaseExt.jl (Plots.jl recipe)
- ext/EmpiricalTightBindingPythonPlotExt.jl  (savefig_publication)
=#

"""
    savefig_publication(bs::BandStructure, path::AbstractString; kwargs...)
    savefig_publication(bss::AbstractVector{<:BandStructure}, path::AbstractString; kwargs...)

Save publication-quality band structure figure with precise axis dimensions.
Requires `using PythonPlot`.

# Keywords
- `axis_width_cm`: axis width in cm (default: 8.0)
- `axis_height_cm`: axis height in cm (default: 6.0)
- `layout`: subplot layout tuple, e.g., `(1, 2)` (for vector input)

# Example
```julia
using PythonPlot
savefig_publication(bs, "bands.pdf"; axis_width_cm=8.0, axis_height_cm=6.0)
```
"""
function savefig_publication end
