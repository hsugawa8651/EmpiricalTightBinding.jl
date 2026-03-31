# SPDX-License-Identifier: MIT
# Copyright (C) 2026 Hiroharu Sugawara
# Part of EmpiricalTightBinding.jl - Module definition
module EmpiricalTightBinding

using LinearAlgebra
using InteractiveUtils: subtypes

include("models/types.jl")
include("models/sp3.jl")
include("models/sp3sstar.jl")
include("models/sp3sstar_so.jl")
include("models/sp3d5sstar.jl")
include("structure_factors.jl")
include("params/params.jl")
include("params/parse.jl")
include("params/vogl1983.jl")
include("params/jancu1998.jl")
include("params/klimeck2000.jl")
include("kpath.jl")
include("bands.jl")
include("bandstructure.jl")
include("plotting.jl")
include("fallbacks.jl")

export TBModel, SP3, SP3Sstar, SP3Sstar_SO, SP3D5Sstar
export ParamSource, Vogl1983, Klimeck2000, Jancu1998
export hamiltonian_size, build_hamiltonian
export structure_factors
export SP3Params, SP3SstarParams, sp3_params
export get_params, list_materials, list_sources, VOGL1983, JANCU1998, KLIMECK2000
export KPath, make_kpath, vogl_kpath, textbook_kpath, FCC_KPOINTS
export compute_bands, band_energies, n_valence, BandStructure
export savefig_publication

end
