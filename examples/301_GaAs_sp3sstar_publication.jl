# SPDX-License-Identifier: MIT
# Copyright (C) 2026 Hiroharu Sugawara
# Part of EmpiricalTightBinding.jl
### Publication-quality figure: GaAs sp³s* band structure (PythonPlot)

using Pkg
Pkg.activate(joinpath(@__DIR__, ".."))

using EmpiricalTightBinding
using PythonPlot

p = get_params(SP3Sstar, Vogl1983(), "GaAs")
kp = vogl_kpath()
bs = BandStructure(SP3Sstar(), kp, p)

outfile = joinpath(@__DIR__, "301_GaAs_sp3sstar_publication.pdf")
savefig_publication(bs, outfile;
    axis_width_cm = 8.0, axis_height_cm = 6.0)
println("Saved: $outfile")
