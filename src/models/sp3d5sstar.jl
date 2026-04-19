# SPDX-License-Identifier: MIT
# Copyright (C) 2026 Hiroharu Sugawara
# Part of EmpiricalTightBinding.jl - SP3D5Sstar model (20-band, d orbitals)

"""20-band sp³d⁵s* model (Jancu et al. 1998). Adds five d orbitals per atom."""
struct SP3D5Sstar <: TBModel end

hamiltonian_size(::SP3D5Sstar) = 20
Base.show(io::IO, ::SP3D5Sstar) = print(io, "sp³d⁵s* (20-band)")

#=
Basis (anion 1-10, cation 11-20):
  1:s_a   2:px_a  3:py_a  4:pz_a
  5:dxy_a 6:dyz_a 7:dzx_a 8:dx²-y²_a 9:d3z²-r²_a
 10:s*_a
 11:s_c   12:px_c  13:py_c  14:pz_c
 15:dxy_c 16:dyz_c 17:dzx_c 18:dx²-y²_c 19:d3z²-r²_c
 20:s*_c

Bond-sum with Slater-Koster two-center integrals.
Parameters p: Dict{Symbol, Float64} from Jancu tables.
=#

# ── Slater-Koster helpers ──

"""Fill p→d sub-block T[ip:ip+2, id:id+4] with sign s."""
function _fill_pd!(T, ip, id, l, m, n, Vσ, Vπ, s)
    T[ip, id] = s * (√3 * l^2 * m * Vσ + m * (1 - 2l^2) * Vπ)
    T[ip, id + 1] = s * (√3 * l * m * n * Vσ - 2l * m * n * Vπ)
    T[ip, id + 2] = s * (√3 * l^2 * n * Vσ + n * (1 - 2l^2) * Vπ)
    T[ip, id + 3] = s * ((√3 / 2) * l * (l^2 - m^2) * Vσ + l * (1 - l^2 + m^2) * Vπ)
    T[ip, id + 4] = s * (l * (n^2 - (l^2 + m^2) / 2) * Vσ - √3 * l * n^2 * Vπ)
    T[ip + 1, id] = s * (√3 * m^2 * l * Vσ + l * (1 - 2m^2) * Vπ)
    T[ip + 1, id + 1] = s * (√3 * m^2 * n * Vσ + n * (1 - 2m^2) * Vπ)
    T[ip + 1, id + 2] = s * (√3 * m * n * l * Vσ - 2m * n * l * Vπ)
    T[ip + 1, id + 3] = s * ((√3 / 2) * m * (l^2 - m^2) * Vσ - m * (1 + l^2 - m^2) * Vπ)
    T[ip + 1, id + 4] = s * (m * (n^2 - (l^2 + m^2) / 2) * Vσ - √3 * m * n^2 * Vπ)
    T[ip + 2, id] = s * (√3 * n * l * m * Vσ - 2n * l * m * Vπ)
    T[ip + 2, id + 1] = s * (√3 * n^2 * m * Vσ + m * (1 - 2n^2) * Vπ)
    T[ip + 2, id + 2] = s * (√3 * n^2 * l * Vσ + l * (1 - 2n^2) * Vπ)
    T[ip + 2, id + 3] = s * ((√3 / 2) * n * (l^2 - m^2) * Vσ - n * (l^2 - m^2) * Vπ)
    T[ip + 2, id + 4] = s * (n * (n^2 - (l^2 + m^2) / 2) * Vσ + √3 * n * (l^2 + m^2) * Vπ)
end

"""Fill d→p sub-block T[id:id+4, ip:ip+2] via transposed p→d SK formula.

Per SK Table I (1954), E_{d,p}(R̂) = -E_{p,d}(R̂) due to parity (-1)^(ℓ_p+ℓ_d) = -1.
Caller passes s = -1 for standard d_anion → p_cation (anion-cation NN bond)."""
function _fill_dp!(T, id, ip, l, m, n, Vσ, Vπ, s)
    tmp = zeros(3, 5)
    tmp[1, 1] = s * (√3 * l^2 * m * Vσ + m * (1 - 2l^2) * Vπ)
    tmp[1, 2] = s * (√3 * l * m * n * Vσ - 2l * m * n * Vπ)
    tmp[1, 3] = s * (√3 * l^2 * n * Vσ + n * (1 - 2l^2) * Vπ)
    tmp[1, 4] = s * ((√3 / 2) * l * (l^2 - m^2) * Vσ + l * (1 - l^2 + m^2) * Vπ)
    tmp[1, 5] = s * (l * (n^2 - (l^2 + m^2) / 2) * Vσ - √3 * l * n^2 * Vπ)
    tmp[2, 1] = s * (√3 * m^2 * l * Vσ + l * (1 - 2m^2) * Vπ)
    tmp[2, 2] = s * (√3 * m^2 * n * Vσ + n * (1 - 2m^2) * Vπ)
    tmp[2, 3] = s * (√3 * m * n * l * Vσ - 2m * n * l * Vπ)
    tmp[2, 4] = s * ((√3 / 2) * m * (l^2 - m^2) * Vσ - m * (1 + l^2 - m^2) * Vπ)
    tmp[2, 5] = s * (m * (n^2 - (l^2 + m^2) / 2) * Vσ - √3 * m * n^2 * Vπ)
    tmp[3, 1] = s * (√3 * n * l * m * Vσ - 2n * l * m * Vπ)
    tmp[3, 2] = s * (√3 * n^2 * m * Vσ + m * (1 - 2n^2) * Vπ)
    tmp[3, 3] = s * (√3 * n^2 * l * Vσ + l * (1 - 2n^2) * Vπ)
    tmp[3, 4] = s * ((√3 / 2) * n * (l^2 - m^2) * Vσ - n * (l^2 - m^2) * Vπ)
    tmp[3, 5] = s * (n * (n^2 - (l^2 + m^2) / 2) * Vσ + √3 * n * (l^2 + m^2) * Vπ)

    for α = 0:4, β = 0:2
        T[id + α, ip + β] = tmp[β + 1, α + 1]
    end
end

"""Fill d-d sub-block T[id:id+4, jd:jd+4]."""
function _fill_dd!(T, id, jd, l, m, n, σ, π, δ)
    T[id, jd] = 3l^2 * m^2 * σ + (l^2 + m^2 - 4l^2 * m^2) * π + (n^2 + l^2 * m^2) * δ
    T[id + 1, jd + 1] = 3m^2 * n^2 * σ + (m^2 + n^2 - 4m^2 * n^2) * π + (l^2 + m^2 * n^2) * δ
    T[id + 2, jd + 2] = 3n^2 * l^2 * σ + (n^2 + l^2 - 4n^2 * l^2) * π + (m^2 + n^2 * l^2) * δ
    T[id + 3, jd + 3] =
        3 / 4 * (l^2 - m^2)^2 * σ + (l^2 + m^2 - (l^2 - m^2)^2) * π +
        (n^2 + (l^2 - m^2)^2 / 4) * δ
    T[id + 4, jd + 4] =
        (n^2 - (l^2 + m^2) / 2)^2 * σ + 3n^2 * (l^2 + m^2) * π +
        3 / 4 * (l^2 + m^2)^2 * δ
    T[id, jd + 1] = 3l * m^2 * n * σ + l * n * (1 - 4m^2) * π + l * n * (m^2 - 1) * δ
    T[id, jd + 2] = 3l^2 * m * n * σ + m * n * (1 - 4l^2) * π + m * n * (l^2 - 1) * δ
    T[id + 1, jd + 2] = 3l * m * n^2 * σ + l * m * (1 - 4n^2) * π + l * m * (n^2 - 1) * δ
    T[id, jd + 3] =
        3 / 2 * l * m * (l^2 - m^2) * σ + 2l * m * (m^2 - l^2) * π +
        l * m * (l^2 - m^2) / 2 * δ
    T[id, jd + 4] =
        √3 * l * m * (n^2 - (l^2 + m^2) / 2) * σ - 2√3 * l * m * n^2 * π +
        √3 / 2 * l * m * (1 + n^2) * δ
    T[id + 1, jd + 3] =
        3 / 2 * m * n * (l^2 - m^2) * σ - m * n * (1 + 2(l^2 - m^2)) * π +
        m * n * (1 + (l^2 - m^2) / 2) * δ
    T[id + 1, jd + 4] =
        √3 * m * n * (n^2 - (l^2 + m^2) / 2) * σ + √3 * m * n * (l^2 + m^2 - n^2) * π -
        √3 / 2 * m * n * (l^2 + m^2) * δ
    T[id + 2, jd + 3] =
        3 / 2 * n * l * (l^2 - m^2) * σ + n * l * (1 - 2(l^2 - m^2)) * π -
        n * l * (1 - (l^2 - m^2) / 2) * δ
    T[id + 2, jd + 4] =
        √3 * n * l * (n^2 - (l^2 + m^2) / 2) * σ + √3 * n * l * (l^2 + m^2 - n^2) * π -
        √3 / 2 * n * l * (l^2 + m^2) * δ
    T[id + 3, jd + 4] =
        √3 / 2 * (l^2 - m^2) * (n^2 - (l^2 + m^2) / 2) * σ +
        √3 * n^2 * (m^2 - l^2) * π + √3 / 4 * (1 + n^2) * (l^2 - m^2) * δ
    for α = 0:4, β = (α + 1):4
        T[id + β, jd + α] = T[id + α, jd + β]
    end
end

"""
Fill the 10×10 SK hopping matrix T[α_a, β_c] for a single bond direction (l,m,n).
T must be pre-allocated and zeroed by caller.
"""
function _sk_bond_matrix!(T, l, m, n, p)
    # s_a (row 1) → cation
    T[1, 1] = p[:ss]
    T[1, 2] = l * p[:sa_pc]
    T[1, 3] = m * p[:sa_pc]
    T[1, 4] = n * p[:sa_pc]
    T[1, 5] = √3 * l * m * p[:sa_dc]
    T[1, 6] = √3 * m * n * p[:sa_dc]
    T[1, 7] = √3 * n * l * p[:sa_dc]
    T[1, 8] = (√3 / 2) * (l^2 - m^2) * p[:sa_dc]
    T[1, 9] = (n^2 - (l^2 + m^2) / 2) * p[:sa_dc]
    T[1, 10] = p[:sa_stc]

    # p_a (rows 2-4) → s_c (sign −1 for p-s)
    T[2, 1] = -l * p[:sc_pa]
    T[3, 1] = -m * p[:sc_pa]
    T[4, 1] = -n * p[:sc_pa]
    # p_a → p_c
    dc = (l, m, n)
    for α = 1:3, β = 1:3
        T[1 + α, 1 + β] = if α == β
            dc[α]^2 * p[:pp_sig] + (1 - dc[α]^2) * p[:pp_pi]
        else
            dc[α] * dc[β] * (p[:pp_sig] - p[:pp_pi])
        end
    end
    # p_a → d_c (SK Table I: E_{p,d} positive, no parity flip)
    _fill_pd!(T, 2, 5, l, m, n, p[:pa_dc_sig], p[:pa_dc_pi], +1)
    # p_a → s*_c (sign −1)
    T[2, 10] = -l * p[:stc_pa]
    T[3, 10] = -m * p[:stc_pa]
    T[4, 10] = -n * p[:stc_pa]

    # d_a (rows 5-9) → s_c
    T[5, 1] = √3 * l * m * p[:sc_da]
    T[6, 1] = √3 * m * n * p[:sc_da]
    T[7, 1] = √3 * n * l * p[:sc_da]
    T[8, 1] = (√3 / 2) * (l^2 - m^2) * p[:sc_da]
    T[9, 1] = (n^2 - (l^2 + m^2) / 2) * p[:sc_da]
    # d_a → p_c (SK Table I parity: E_{d,p} = -E_{p,d})
    _fill_dp!(T, 5, 2, l, m, n, p[:pc_da_sig], p[:pc_da_pi], -1)
    # d_a → d_c
    _fill_dd!(T, 5, 5, l, m, n, p[:dd_sig], p[:dd_pi], p[:dd_del])
    # d_a → s*_c
    T[5, 10] = √3 * l * m * p[:stc_da]
    T[6, 10] = √3 * m * n * p[:stc_da]
    T[7, 10] = √3 * n * l * p[:stc_da]
    T[8, 10] = (√3 / 2) * (l^2 - m^2) * p[:stc_da]
    T[9, 10] = (n^2 - (l^2 + m^2) / 2) * p[:stc_da]

    # s*_a (row 10) → cation
    T[10, 1] = p[:sta_sc]
    T[10, 2] = l * p[:sta_pc]
    T[10, 3] = m * p[:sta_pc]
    T[10, 4] = n * p[:sta_pc]
    T[10, 5] = √3 * l * m * p[:sta_dc]
    T[10, 6] = √3 * m * n * p[:sta_dc]
    T[10, 7] = √3 * n * l * p[:sta_dc]
    T[10, 8] = (√3 / 2) * (l^2 - m^2) * p[:sta_dc]
    T[10, 9] = (n^2 - (l^2 + m^2) / 2) * p[:sta_dc]
    T[10, 10] = p[:stst]
end

function build_hamiltonian(::SP3D5Sstar, k, p::Dict{Symbol,Float64})
    _check_k(k)
    H = Matrix{ComplexF64}(undef, 20, 20)
    fill!(H, zero(ComplexF64))
    T = Matrix{Float64}(undef, 10, 10)

    # On-site energies
    H[1, 1] = p[:Es_a]
    H[2, 2] = p[:Ep_a]
    H[3, 3] = p[:Ep_a]
    H[4, 4] = p[:Ep_a]
    for i = 5:9
        H[i, i] = p[:Ed_a]
    end
    H[10, 10] = p[:Estar_a]
    H[11, 11] = p[:Es_c]
    H[12, 12] = p[:Ep_c]
    H[13, 13] = p[:Ep_c]
    H[14, 14] = p[:Ep_c]
    for i = 15:19
        H[i, i] = p[:Ed_c]
    end
    H[20, 20] = p[:Estar_c]

    # Nearest-neighbor hopping: sum over 4 bonds
    for (sx, sy, sz) in ((1, 1, 1), (1, -1, -1), (-1, 1, -1), (-1, -1, 1))
        φ = cispi((sx * k[1] + sy * k[2] + sz * k[3]) / 2)
        l = sx / √3
        m = sy / √3
        n = sz / √3

        fill!(T, 0.0)
        _sk_bond_matrix!(T, l, m, n, p)

        for i = 1:10, j = 1:10
            H[i, 10 + j] += T[i, j] * φ
        end
    end

    # Hermitianize
    for i = 1:20, j = (i + 1):20
        H[j, i] = conj(H[i, j])
    end
    return Hermitian(H)
end
