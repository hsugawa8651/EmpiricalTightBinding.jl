# SPDX-License-Identifier: MIT
# Copyright (C) 2026 Hiroharu Sugawara
# Part of EmpiricalTightBinding.jl
### Compare parameter sources for GaAs sp³s*: Vogl 1983 vs Klimeck 2000

using Pkg
Pkg.activate(joinpath(@__DIR__, ".."))

using EmpiricalTightBinding
using Plots

kp = vogl_kpath()

p_vogl = get_params(SP3Sstar, Vogl1983(), "GaAs")
p_klimeck = get_params(SP3Sstar, Klimeck2000(), "GaAs")

bs_vogl = BandStructure(SP3Sstar(), kp, p_vogl;
    title = "GaAs sp³s*: Vogl (black) vs Klimeck (red)")
bs_klimeck = BandStructure(SP3Sstar(), kp, p_klimeck)

plt = plot(bs_vogl)
plot!(plt, bs_klimeck, linecolor = :red, linestyle = :dash)

outfile = joinpath(@__DIR__, "203_GaAs_vogl_vs_klimeck.png")
savefig(plt, outfile)
println("Saved: $outfile")
display(plt)
