# SPDX-License-Identifier: MIT
# Copyright (C) 2026 Hiroharu Sugawara
# Part of EmpiricalTightBinding.jl - RecipesBase extension
module EmpiricalTightBindingRecipesBaseExt

using EmpiricalTightBinding
using RecipesBase

@recipe function f(bs::BandStructure)
    ylabel     --> "Energy (eV)"
    title      --> bs.title
    legend     --> false
    ylims      --> (-15, 15)
    framestyle --> :box
    grid       --> false
    xticks     --> (bs.tick_positions, bs.tick_labels)

    # Band lines
    for i in 1:size(bs.bands, 2)
        @series begin
            seriestype := :path
            linecolor  --> :black
            linewidth  --> 1.5
            label      := ""
            bs.x, bs.bands[:, i]
        end
    end

    # Vertical lines at high-symmetry points
    for tp in bs.tick_positions
        @series begin
            seriestype := :vline
            primary    := false
            linecolor  := :gray
            linewidth  := 0.5
            label      := ""
            [tp]
        end
    end

    # Horizontal dashed line at E=0
    @series begin
        seriestype := :hline
        primary    := false
        linecolor  := :gray
        linewidth  := 0.3
        linestyle  := :dash
        label      := ""
        [0.0]
    end
end

end
