# SPDX-License-Identifier: MIT
# Copyright (C) 2026 Hiroharu Sugawara
# Part of EmpiricalTightBinding.jl
### Compare sp³ (8-band) vs sp³s* (10-band) for GaAs
###
### Reproduces the key result of Vogl et al. (1983):
### The s* orbital pushes down the conduction band near X,
### enabling correct indirect band gaps.

using Pkg
Pkg.activate(joinpath(@__DIR__, ".."))

using EmpiricalTightBinding
using Plots

p_sstar = get_params(SP3Sstar, Vogl1983(), "GaAs")
p_sp3 = get_params(SP3, Vogl1983(), "GaAs")
kp = vogl_kpath()

bs_sstar = BandStructure(SP3Sstar(), kp, p_sstar;
    title = "GaAs: sp³s* (black) vs sp³ (blue)")
bs_sp3 = BandStructure(SP3(), kp, p_sp3)

plt = plot(bs_sstar)
plot!(plt, bs_sp3, linecolor = :blue, linestyle = :dash)

outfile = joinpath(@__DIR__, "201_GaAs_sp3_vs_sp3sstar.png")
savefig(plt, outfile)
println("Saved: $outfile")
display(plt)
