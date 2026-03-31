# SPDX-License-Identifier: MIT
# Copyright (C) 2026 Hiroharu Sugawara
# Part of EmpiricalTightBinding.jl - Vogl (1983) parameters
#= Vogl, Hjalmarson, Dow (1983) — Table 1
J. Phys. Chem. Solids 44, 365 =#

# ── Table 1, Part 1: Diagonal energies (eV) ──
const VOGL1983_DIAG_RAW = """
              C        Si       Ge       Sn       SiC      AlP      AlAs     AlSb     GaP      GaAs     GaSb     InP      InAs     InSb     ZnSe     ZnTe
a          3.5668   5.4310   5.6579   6.4892   4.3596   5.4635   5.6611   6.1355   5.4505   5.6533   6.0959   5.8688   6.0584   6.4794   5.6676   6.1026
Es_a      -4.5450  -4.2000  -5.8800  -5.6700  -8.4537  -7.8466  -7.5273  -6.1714  -8.1124  -8.3431  -7.3207  -8.5274  -9.5381  -8.0157 -11.8383  -9.8150
Ep_a       3.8400   1.7150   1.6100   1.3300   2.1234   1.3169   0.9833   0.9807   1.1250   1.0414   0.8554   0.8735   0.9099   0.6338   1.5072   1.4834
Estar_a   11.3700   6.6850   6.3900   5.9000   9.6534   8.7069   7.4833   6.7607   8.5150   8.5914   6.6354   8.2635   7.4099   6.4530   7.5872   7.0834
Es_c      -4.5450  -4.2000  -5.8800  -5.6700  -4.8463  -1.2534  -1.1627  -2.0716  -2.1976  -2.6569  -3.8993  -1.4826  -2.7219  -3.4643   0.0183   0.9350
Ep_c       3.8400   1.7150   1.6100   1.3300   4.3466   4.2831   3.5867   3.0163   4.1150   3.6686   2.9146   4.0065   3.7201   2.9162   5.9928   5.2666
Estar_c   11.3700   6.6850   6.3900   5.9000   9.3166   7.4231   6.7267   6.1543   7.1850   6.7386   5.9866   7.0665   6.7401   5.9362   8.9928   8.2666
"""

# ── Table 1, Part 2: Transfer integrals (eV) ──
const VOGL1983_TRANSFER_RAW = """
              C        Si       Ge       Sn       SiC      AlP      AlAs     AlSb     GaP      GaAs     GaSb     InP      InAs     InSb     ZnSe     ZnTe
Vss      -22.7250  -8.3000  -6.7800  -5.6700 -12.4197  -7.4535  -6.6642  -5.6448  -7.4709  -6.4513  -6.1567  -5.3614  -5.6052  -5.5193  -6.2163  -6.5765
Vxx        3.8400   1.7150   1.6100   1.3300   3.0380   2.3749   1.8700   1.7199   2.1516   1.9546   1.5789   1.8801   1.8398   1.4018   3.0054   2.7951
Vxy       11.6700   4.5750   4.9000   4.0800   5.9216   4.8378   4.2918   3.6648   5.1369   5.0779   4.1285   4.2324   4.4693   3.8761   5.9942   5.4670
Vsapc     15.2206   5.7292   5.4649   4.5116   9.4900   5.2451   5.1106   4.9121   4.2771   4.4800   4.9601   2.2265   3.0354   3.7080   3.4980   5.9827
Vscpa     15.2206   5.7292   5.4649   4.5116   9.2007   5.7775   5.4965   4.2137   6.3190   5.7839   4.6875   5.5825   5.4389   4.5900   6.3191   5.8199
Vstar_apc  8.2109   5.3749   5.2191   5.8939   8.7138   5.2508   4.5316   4.3662   4.6541   4.8422   4.9893   3.4623   3.3744   3.5666   2.5891   1.3196
Vpa_starc  8.2109   5.3749   5.2191   5.8939   6.4051   6.1388   4.9950   3.0739   5.0950   4.8077   4.2180   4.4814   3.9097   3.4048   3.9533   0.0000
"""

# ── Table 4: Spin-orbit parameters (eV) ──
# Δ_a = anion, Δ_c = cation (full splitting, use Δ/3 in Hamiltonian)
const VOGL1983_SO_RAW = """
              AlAs     AlP      GaAs     GaP      GaSb     InAs     InP      InSb     ZnSe
Da         0.421    0.067    0.421    0.067    0.973    0.421    0.067    0.973    0.48
Dc         0.024    0.024    0.174    0.174    0.179    0.392    0.392    0.392    0.074
"""

# ── Parse and merge ──
const _VOGL1983_PARSED = let
    d1 = parse_table(VOGL1983_DIAG_RAW)
    d2 = parse_table(VOGL1983_TRANSFER_RAW)
    d3 = parse_table(VOGL1983_SO_RAW)
    merged = Dict{String,Dict{Symbol,Float64}}()
    for mat in keys(d1)
        merged[mat] = merge(d1[mat], d2[mat])
        # Add SO parameters if available
        if haskey(d3, mat)
            merge!(merged[mat], d3[mat])
        end
    end
    merged
end

const VOGL1983 = Dict{String,SP3SstarParams}(
    mat => _to_sp3sstar(mat, d) for (mat, d) in _VOGL1983_PARSED
)

# ── Accessors ──
get_params(::Type{SP3Sstar}, ::Vogl1983, material::String) = VOGL1983[material]
get_params(::Type{SP3}, ::Vogl1983, material::String) = sp3_params(VOGL1983[material])
get_params(::Type{SP3Sstar_SO}, ::Vogl1983, material::String) = _VOGL1983_PARSED[material]

function list_materials(::Vogl1983)
    for (name, p) in sort(collect(VOGL1983))
        type_str = p.cation == p.anion ? "diamond" : "$(p.cation)-$(p.anion)"
        println("  $name  ($type_str, a=$(p.a) Å)")
    end
end
