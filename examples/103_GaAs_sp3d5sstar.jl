# SPDX-License-Identifier: MIT
# Copyright (C) 2026 Hiroharu Sugawara
# Part of EmpiricalTightBinding.jl
### GaAs band structure with sp³d⁵s* model (Jancu 1998)

using Pkg
Pkg.activate(joinpath(@__DIR__, ".."))

using EmpiricalTightBinding
using Plots

p = get_params(SP3D5Sstar, Jancu1998(), "GaAs")
kp = vogl_kpath()
bs = BandStructure(SP3D5Sstar(), kp, p)

plt = plot(bs)

outfile = joinpath(@__DIR__, "103_GaAs_sp3d5sstar.png")
savefig(plt, outfile)
println("Saved: $outfile")
display(plt)
