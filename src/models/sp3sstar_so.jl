# SPDX-License-Identifier: MIT
# Copyright (C) 2026 Hiroharu Sugawara
# Part of EmpiricalTightBinding.jl - SP3Sstar_SO model (20-band, spin-orbit)

"""20-band sp³s* + spin-orbit model. Doubles basis with spin."""
struct SP3Sstar_SO <: TBModel end

hamiltonian_size(::SP3Sstar_SO) = 20
Base.show(io::IO, ::SP3Sstar_SO) = print(io, "sp³s*+SO (20-band)")

n_valence(::SP3Sstar_SO, ::String) = 8

"""Extract SP3SstarParams from a Dict."""
function _to_sp3sstar_from_dict(p::Dict{Symbol,Float64})
    SP3SstarParams((
        "?",
        "?",
        p[:a],
        p[:Es_a],
        p[:Ep_a],
        p[:Estar_a],
        p[:Es_c],
        p[:Ep_c],
        p[:Estar_c],
        p[:Vss],
        p[:Vxx],
        p[:Vxy],
        p[:Vsapc],
        p[:Vscpa],
        p[:Vstar_apc],
        p[:Vpa_starc],
    ))
end

#=
Basis: spin-↑ block (1-10) then spin-↓ block (11-20)
Each block has sp³s* ordering.
SO coupling: H_SO = (Δ/3) * L·S/ℏ² on p orbitals only.
Anion p = indices 3,4,5 (↑) / 13,14,15 (↓)
Cation p = indices 6,7,8 (↑) / 16,17,18 (↓)
=#
function build_hamiltonian(::SP3Sstar_SO, k, p::Dict{Symbol,Float64})
    _check_k(k)

    p_nt = _to_sp3sstar_from_dict(p)
    H0 = Matrix(build_hamiltonian(SP3Sstar(), k, p_nt))

    H = Matrix{ComplexF64}(undef, 20, 20)
    fill!(H, zero(ComplexF64))
    H[1:10, 1:10] .= H0
    H[11:20, 11:20] .= H0

    Da3 = p[:Da] / 3
    Dc3 = p[:Dc] / 3

    for (ip, λ) in ((3, Da3), (6, Dc3))
        # ↑↑ block: Lz
        H[ip, ip + 1] += λ * (-im / 2)
        H[ip + 1, ip] += λ * (im / 2)
        # ↓↓ block: -Lz
        H[ip + 10, ip + 11] += λ * (im / 2)
        H[ip + 11, ip + 10] += λ * (-im / 2)
        # ↑↓ block: L-
        H[ip, ip + 12] += λ * (1 / 2)
        H[ip + 1, ip + 12] += λ * (-im / 2)
        H[ip + 2, ip + 10] += λ * (-1 / 2)
        H[ip + 2, ip + 11] += λ * (im / 2)
        # ↓↑ block: L+
        H[ip + 12, ip] += λ * (1 / 2)
        H[ip + 12, ip + 1] += λ * (im / 2)
        H[ip + 10, ip + 2] += λ * (-1 / 2)
        H[ip + 11, ip + 2] += λ * (-im / 2)
    end

    return Hermitian(H)
end
