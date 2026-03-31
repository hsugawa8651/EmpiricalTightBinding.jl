# SPDX-License-Identifier: MIT
# Copyright (C) 2026 Hiroharu Sugawara
# Part of EmpiricalTightBinding.jl - SP3 model (8-band)

"""8-band sp³ model (s, px, py, pz on anion + cation)."""
struct SP3 <: TBModel end

hamiltonian_size(::SP3) = 8
Base.show(io::IO, ::SP3) = print(io, "sp³ (8-band)")

#= Basis: |s,a⟩ |s,c⟩ |px,a⟩ |py,a⟩ |pz,a⟩ |px,c⟩ |py,c⟩ |pz,c⟩ =#
function build_hamiltonian(::SP3, k, p)
    _check_k(k)
    g0, g1, g2, g3 = structure_factors(k)
    H = Matrix{ComplexF64}(undef, 8, 8)
    fill!(H, zero(ComplexF64))

    H[1, 1] = p.Es_a
    H[2, 2] = p.Es_c
    H[3, 3] = p.Ep_a
    H[4, 4] = p.Ep_a
    H[5, 5] = p.Ep_a
    H[6, 6] = p.Ep_c
    H[7, 7] = p.Ep_c
    H[8, 8] = p.Ep_c

    H[1, 2] = p.Vss * g0
    H[1, 6] = p.Vsapc * g1
    H[1, 7] = p.Vsapc * g2
    H[1, 8] = p.Vsapc * g3
    H[2, 3] = -p.Vscpa * conj(g1)
    H[2, 4] = -p.Vscpa * conj(g2)
    H[2, 5] = -p.Vscpa * conj(g3)
    H[3, 6] = p.Vxx * g0
    H[4, 7] = p.Vxx * g0
    H[5, 8] = p.Vxx * g0
    H[3, 7] = p.Vxy * g3
    H[3, 8] = p.Vxy * g2
    H[4, 6] = p.Vxy * g3
    H[4, 8] = p.Vxy * g1
    H[5, 6] = p.Vxy * g2
    H[5, 7] = p.Vxy * g1

    H = H + H' - Diagonal(diag(H))
    return Hermitian(H)
end
