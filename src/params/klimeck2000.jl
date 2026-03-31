# SPDX-License-Identifier: MIT
# Copyright (C) 2026 Hiroharu Sugawara
# Part of EmpiricalTightBinding.jl - Klimeck (2000) parameters
#=
Klimeck, Bowen, Boykin, Cwik (2000) — Table 1
Superlattices and Microstructures 27, 519

GA-optimized sp3s* parameters for 9 III-V compounds.
Vogl convention (V parameters, not bare SK integrals).
Lattice constants converted from nm to Å.
Δ_a, Δ_c are FULL spin-orbit splitting (use Δ/3 in Hamiltonian).
=#

const KLIMECK2000_RAW = """
              GaAs       AlAs       InAs       GaP        AlP        InP        GaSb       AlSb       InSb
a          5.6660     5.6600     6.0583     5.4509     5.4635     5.8687     6.0959     6.1355     6.0583
Es_a      -3.53284   -3.21537   -9.57566   -8.63163   -8.93519   -7.91404   -7.16208   -4.55720   -7.80905
Ep_a       0.27772   -0.09711    0.02402    0.77214    1.13009    0.08442   -0.17071    0.01635   -0.14734
Estar_a   12.33930   12.05550    7.44461   11.90050   12.82470    9.88869    7.32190    9.84286    7.43195
Es_c      -8.11499   -9.52462   -2.21525   -1.77800    0.06175   -2.76662   -4.77036   -4.11800   -2.83599
Ep_c       4.57341    4.97139    4.64241    4.17259    4.55816    4.75968    4.06643    4.87411    3.91522
Estar_c    4.31241    3.99445    4.12648    7.99670    9.41477    7.66966    3.12330    7.43245    3.54540
Vss       -6.87653   -8.84261   -5.06858   -7.21087   -6.68397   -6.16976   -6.60955   -6.63365   -4.89637
Vxx        1.33572   -0.01434    0.84908    1.83129    2.28630    0.75617    0.58073    1.10706    0.75260
Vxy        5.07596    4.25949    4.68538    4.87432    5.12891    4.23370    4.76520    4.89960    4.48030
Vsapc      2.85929    2.42476    2.51793    6.12826    9.44286    3.62283    3.00325    4.58724    3.33714
Vscpa     11.09774   13.20317    6.18038    6.10944    5.93164    6.90390    7.78033    8.53398    5.60426
Vstar_apc  6.31619    5.83246    3.79662    6.69771   10.08057    4.61375    4.69778    7.38446    4.59953
Vpa_starc  5.02335    4.60075    2.45537    6.33303    4.80831    6.18932    4.09285    6.29608   -2.53756
Da         0.32703    0.29145    0.38159    0.05379    0.04600    0.09400    0.75773    0.70373    0.85794
Dc         0.12000    0.03152    0.37518    0.21636    0.01608    0.54000    0.15778    0.03062    0.51000
"""

const _KLIMECK2000_PARSED = parse_table(KLIMECK2000_RAW)

const KLIMECK2000 = Dict{String,SP3SstarParams}(
    mat => _to_sp3sstar(mat, d) for (mat, d) in _KLIMECK2000_PARSED
)

# ── Accessors ──
get_params(::Type{SP3Sstar}, ::Klimeck2000, material::String) = KLIMECK2000[material]
get_params(::Type{SP3}, ::Klimeck2000, material::String) = sp3_params(KLIMECK2000[material])
get_params(::Type{SP3Sstar_SO}, ::Klimeck2000, material::String) =
    _KLIMECK2000_PARSED[material]

function list_materials(::Klimeck2000)
    for (name, p) in sort(collect(KLIMECK2000))
        println("  $name  ($(p.cation)-$(p.anion), a=$(p.a) Å)")
    end
end
