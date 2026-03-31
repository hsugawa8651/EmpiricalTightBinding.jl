# SPDX-License-Identifier: MIT
# Copyright (C) 2026 Hiroharu Sugawara
# Part of EmpiricalTightBinding.jl
### Si band structure with sp³s* model (Vogl 1983)

using Pkg
Pkg.activate(joinpath(@__DIR__, ".."))

using EmpiricalTightBinding
using Plots

p = get_params(SP3Sstar, Vogl1983(), "Si")
kp = vogl_kpath()
bs = BandStructure(SP3Sstar(), kp, p)

plt = plot(bs)

outfile = joinpath(@__DIR__, "102_Si_sp3sstar.png")
savefig(plt, outfile)
println("Saved: $outfile")
display(plt)
