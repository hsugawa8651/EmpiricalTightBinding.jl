# SPDX-License-Identifier: MIT
# Copyright (C) 2026 Hiroharu Sugawara
# Part of EmpiricalTightBinding.jl
### GaAs band structure with sp³s* + spin-orbit model

using Pkg
Pkg.activate(joinpath(@__DIR__, ".."))

using EmpiricalTightBinding
using Plots

p = get_params(SP3Sstar_SO, Vogl1983(), "GaAs")
kp = vogl_kpath()
bs = BandStructure(SP3Sstar_SO(), kp, p)

plt = plot(bs)

outfile = joinpath(@__DIR__, "104_GaAs_sp3sstar_so.png")
savefig(plt, outfile)
println("Saved: $outfile")
display(plt)
