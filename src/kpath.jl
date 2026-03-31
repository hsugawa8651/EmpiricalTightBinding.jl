# SPDX-License-Identifier: MIT
# Copyright (C) 2026 Hiroharu Sugawara
# Part of EmpiricalTightBinding.jl - k-path utilities
#= k-path utilities for band structure calculations =#

"""High-symmetry k-points for FCC/zinc-blende (in units of 2π/a)."""
const FCC_KPOINTS = Dict{Symbol,Vector{Float64}}(
    :Γ => [0.0, 0.0, 0.0],
    :X => [1.0, 0.0, 0.0],
    :L => [0.5, 0.5, 0.5],
    :K => [0.75, 0.75, 0.0],
    :U => [1.0, 0.25, 0.25],
    :W => [1.0, 0.5, 0.0],
)

"""
    KPath

Discretized k-path through the Brillouin zone.
Stores k-points, cumulative distances, and tick info for plotting.
"""
struct KPath
    kpoints::Vector{Vector{Float64}}
    x::Vector{Float64}
    tick_positions::Vector{Float64}
    tick_labels::Vector{String}
end

"""
    make_kpath(segments; nk=100, kpoints=FCC_KPOINTS)

Build a KPath from a list of segment specifications.

Each segment is a `Pair` of symbols or vectors:
- `(:L => :Γ)` — uses named high-symmetry points
- `([0.5,0.5,0.5] => [0.0,0.0,0.0])` — explicit coordinates

Multiple segments can be separated by `nothing` to indicate a discontinuity
(e.g., U,K jump in Vogl Fig.1).

# Example (Vogl Fig.1 path)
```julia
kp = make_kpath([
    :L => :Γ, :Γ => :X, :X => :U,
    nothing,  # discontinuity
    :K => :Γ
])
```
"""
function make_kpath(segments; nk = 100, kpoints = FCC_KPOINTS)
    all_kpts = Vector{Float64}[]
    all_x = Float64[]
    tick_pos = Float64[]
    tick_lab = String[]
    offset = 0.0

    for seg in segments
        seg === nothing && continue

        # Resolve endpoints
        k_start, k_end, label_start, label_end = _resolve_segment(seg, kpoints)

        x_start = isempty(all_x) ? 0.0 : offset

        for j = 0:(nk-1)
            t = j / nk
            k = (1-t) .* k_start .+ t .* k_end
            push!(all_kpts, k)
            if j == 0
                push!(all_x, x_start)
            else
                dx = norm(all_kpts[end] - all_kpts[end-1])
                push!(all_x, all_x[end] + dx)
            end
        end

        # Add tick at start of segment
        if isempty(tick_pos) || tick_pos[end] != x_start
            push!(tick_pos, x_start)
            push!(tick_lab, label_start)
        else
            # Merge labels at same position (e.g., "U,K")
            tick_lab[end] = tick_lab[end] * "," * label_end  # actually label_start
        end

        offset = all_x[end] + norm(k_end - all_kpts[end]) / nk  # approximate
    end

    # Add final point
    last_seg = filter(s -> s !== nothing, segments)[end]
    k_start, k_end, _, label_end = _resolve_segment(last_seg, kpoints)
    push!(all_kpts, k_end)
    push!(all_x, all_x[end] + norm(k_end - all_kpts[end-1]))
    push!(tick_pos, all_x[end])
    push!(tick_lab, label_end)

    offset = all_x[end]

    return KPath(all_kpts, all_x, tick_pos, tick_lab)
end

function _resolve_segment(seg::Pair, kpoints)
    k_start = _resolve_kpoint(seg.first, kpoints)
    k_end = _resolve_kpoint(seg.second, kpoints)
    l_start = _kpoint_label(seg.first)
    l_end = _kpoint_label(seg.second)
    return k_start, k_end, l_start, l_end
end

_resolve_kpoint(s::Symbol, kpoints) = kpoints[s]
_resolve_kpoint(v::AbstractVector, _) = collect(Float64, v)

_kpoint_label(s::Symbol) = string(s)
_kpoint_label(v::AbstractVector) = "k"

"""
    vogl_kpath(; nk=100)

Standard Vogl Fig.1 k-path: L → Γ → X → U,K → Γ
"""
function vogl_kpath(; nk = 100)
    # Build two continuous segments with a jump at U,K
    kpts_a, x_a, ticks_a, labs_a = _build_continuous([:L => :Γ, :Γ => :X, :X => :U], nk)
    kpts_b, x_b, ticks_b, labs_b = _build_continuous([:K => :Γ], nk)

    # Shift part b to start where part a ends
    x_b .+= x_a[end]
    ticks_b .+= x_a[end]

    # Merge U,K label
    labs_a[end] = "U,K"

    return KPath(
        vcat(kpts_a, kpts_b),
        vcat(x_a, x_b),
        vcat(ticks_a, ticks_b),
        vcat(labs_a, labs_b),
    )
end

"""
    textbook_kpath(; nk=100)

Simple textbook k-path: L → Γ → X
"""
function textbook_kpath(; nk = 100)
    kpts, x, tick_pos, tick_lab = _build_continuous([:L => :Γ, :Γ => :X], nk)
    return KPath(kpts, x, tick_pos, tick_lab)
end

function _build_continuous(segments, nk)
    kpts = Vector{Float64}[]
    x = Float64[]
    tick_pos = Float64[]
    tick_lab = String[]

    for seg in segments
        k_start, k_end, l_start, l_end = _resolve_segment(seg, FCC_KPOINTS)
        x_off = isempty(x) ? 0.0 : x[end]

        # Tick at start
        if isempty(tick_pos) || abs(tick_pos[end] - x_off) > 1e-10
            push!(tick_pos, x_off)
            push!(tick_lab, l_start)
        end

        for j = 0:(nk-1)
            t = j / nk
            k = (1 - t) .* k_start .+ t .* k_end
            push!(kpts, k)
            if length(kpts) == 1
                push!(x, 0.0)
            else
                push!(x, x[end] + norm(kpts[end] - kpts[end-1]))
            end
        end
    end

    # Final point
    _, k_end, _, l_end = _resolve_segment(segments[end], FCC_KPOINTS)
    push!(kpts, k_end)
    push!(x, x[end] + norm(k_end - kpts[end-1]))
    push!(tick_pos, x[end])
    push!(tick_lab, l_end)

    return kpts, x, tick_pos, tick_lab
end
