# SPDX-License-Identifier: MIT
# Copyright (C) 2026 Hiroharu Sugawara
# Part of EmpiricalTightBinding.jl
### Publication-quality figure: GaAs sp³ vs sp³s* comparison (PythonPlot)

using Pkg
Pkg.activate(joinpath(@__DIR__, ".."))

using EmpiricalTightBinding
using PythonPlot

p_sstar = get_params(SP3Sstar, Vogl1983(), "GaAs")
p_sp3 = get_params(SP3, Vogl1983(), "GaAs")
kp = vogl_kpath()

bs_sstar = BandStructure(SP3Sstar(), kp, p_sstar; title = "GaAs sp³s*")
bs_sp3 = BandStructure(SP3(), kp, p_sp3; title = "GaAs sp³")

# Side-by-side subplot
outfile = joinpath(@__DIR__, "302_GaAs_sp3_vs_sp3sstar_publication.pdf")
savefig_publication([bs_sstar, bs_sp3], outfile;
    axis_width_cm = 7.0, axis_height_cm = 5.5, layout = (1, 2))
println("Saved: $outfile")

# Overlay on a single axis
outfile2 = joinpath(@__DIR__, "302_GaAs_sp3_vs_sp3sstar_overlay.pdf")
savefig_publication([bs_sstar, bs_sp3], outfile2;
    axis_width_cm = 8.0, axis_height_cm = 6.0, overlay = true,
    title = "GaAs: sp³s* (black) vs sp³ (blue)")
println("Saved: $outfile2")
