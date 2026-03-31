# SPDX-License-Identifier: MIT
# Copyright (C) 2026 Hiroharu Sugawara
# Part of EmpiricalTightBinding.jl - Zinc-blende structure factors
#=
Structure factors for zinc-blende (FCC with 2-atom basis)

k: wave vector in units of 2π/a (fractional coordinates of conventional BZ)

Four nearest-neighbor vectors (anion → cation):
  d₁ = (a/4)(+1,+1,+1)    d₂ = (a/4)(+1,−1,−1)
  d₃ = (a/4)(−1,+1,−1)    d₄ = (a/4)(−1,−1,+1)

Phase factors:  φⱼ = exp(ik·dⱼ) = cispi(k·dⱼ·a/π)

Structure factors are linear combinations:
  g₀ = (φ₁ + φ₂ + φ₃ + φ₄) / 4
  g₁ = (φ₁ + φ₂ − φ₃ − φ₄) / 4    (x-like)
  g₂ = (φ₁ − φ₂ + φ₃ − φ₄) / 4    (y-like)
  g₃ = (φ₁ − φ₂ − φ₃ + φ₄) / 4    (z-like)
=#

function structure_factors(k)
    k1, k2, k3 = k

    φ1 = cispi((+k1 + k2 + k3) / 2)
    φ2 = cispi((+k1 - k2 - k3) / 2)
    φ3 = cispi((-k1 + k2 - k3) / 2)
    φ4 = cispi((-k1 - k2 + k3) / 2)

    g0 = (φ1 + φ2 + φ3 + φ4) / 4
    g1 = (φ1 + φ2 - φ3 - φ4) / 4
    g2 = (φ1 - φ2 + φ3 - φ4) / 4
    g3 = (φ1 - φ2 - φ3 + φ4) / 4

    return g0, g1, g2, g3
end
