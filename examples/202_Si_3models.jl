# SPDX-License-Identifier: MIT
# Copyright (C) 2026 Hiroharu Sugawara
# Part of EmpiricalTightBinding.jl
### Compare three models for Si: sp³, sp³s*, sp³d⁵s*

using Pkg
Pkg.activate(joinpath(@__DIR__, ".."))

using EmpiricalTightBinding
using Plots

kp = textbook_kpath()

p_sstar = get_params(SP3Sstar, Vogl1983(), "Si")
p_sp3 = get_params(SP3, Vogl1983(), "Si")
p_d = get_params(SP3D5Sstar, Jancu1998(), "Si")

bs_sstar = BandStructure(SP3Sstar(), kp, p_sstar;
    title = "Si: sp³s* (black), sp³ (blue), sp³d⁵s* (red)")
bs_sp3 = BandStructure(SP3(), kp, p_sp3)
bs_d = BandStructure(SP3D5Sstar(), kp, p_d)

plt = plot(bs_sstar; ylims = (-13, 8))
plot!(plt, bs_sp3, linecolor = :blue, linestyle = :dash)
plot!(plt, bs_d, linecolor = :red, linestyle = :dot)

outfile = joinpath(@__DIR__, "202_Si_3models.png")
savefig(plt, outfile)
println("Saved: $outfile")
display(plt)
