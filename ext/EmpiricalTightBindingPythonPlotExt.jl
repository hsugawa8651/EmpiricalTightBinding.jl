# SPDX-License-Identifier: MIT
# Copyright (C) 2026 Hiroharu Sugawara
# Part of EmpiricalTightBinding.jl - PythonPlot extension
module EmpiricalTightBindingPythonPlotExt

using EmpiricalTightBinding
import PythonPlot

const CM_PER_INCH = 2.54

"""
Plot a single BandStructure on the given matplotlib Axes.
"""
function _plot_bands_on_ax!(ax, bs::BandStructure;
                            color = "black", linewidth = 1.5, linestyle = "-")
    for i in 1:size(bs.bands, 2)
        ax.plot(bs.x, bs.bands[:, i]; color, linewidth, linestyle)
    end

    # Vertical lines at high-symmetry points
    for tp in bs.tick_positions
        ax.axvline(tp; color = "gray", linewidth = 0.5)
    end

    # Horizontal dashed line at E=0
    ax.axhline(0.0; color = "gray", linewidth = 0.3, linestyle = "--")

    # Axis labels and ticks
    ax.set_xticks(bs.tick_positions)
    ax.set_xticklabels(bs.tick_labels)
    ax.set_ylabel("Energy (eV)")
    ax.set_title(bs.title)
    ax.set_xlim(bs.x[1], bs.x[end])
end

"""
Compute figure size (inches) and axes positions from axis dimensions and layout.
"""
function _layout_axes(axis_width_cm, axis_height_cm, n;
                      margin_left_cm = 1.5, margin_right_cm = 0.3,
                      margin_bottom_cm = 1.0, margin_top_cm = 0.8,
                      hgap_cm = 1.8, vgap_cm = 1.5,
                      nrows = 1, ncols = 1)
    # Broadcast scalar to vector
    widths = axis_width_cm isa AbstractVector ? axis_width_cm : fill(axis_width_cm, ncols)
    heights = axis_height_cm isa AbstractVector ? axis_height_cm : fill(axis_height_cm, nrows)

    fig_w_cm = margin_left_cm + sum(widths) + hgap_cm * (ncols - 1) + margin_right_cm
    fig_h_cm = margin_bottom_cm + sum(heights) + vgap_cm * (nrows - 1) + margin_top_cm

    fig_w = fig_w_cm / CM_PER_INCH
    fig_h = fig_h_cm / CM_PER_INCH

    positions = Vector{NTuple{4,Float64}}()
    for row in 1:nrows
        for col in 1:ncols
            left = (margin_left_cm + sum(widths[1:col-1]) + hgap_cm * (col - 1)) / fig_w_cm
            bottom = (margin_bottom_cm + sum(heights[row+1:end]) + vgap_cm * (nrows - row)) / fig_h_cm
            w = widths[col] / fig_w_cm
            h = heights[row] / fig_h_cm
            push!(positions, (left, bottom, w, h))
        end
    end

    return fig_w, fig_h, positions
end

# ── Single BandStructure ──

function EmpiricalTightBinding.savefig_publication(
    bs::BandStructure, path::AbstractString;
    axis_width_cm = 8.0, axis_height_cm = 6.0,
    ylims = (-15, 15),
    kwargs...)

    fig_w, fig_h, positions = _layout_axes(axis_width_cm, axis_height_cm, 1)

    fig = PythonPlot.figure(figsize = (fig_w, fig_h))
    ax = fig.add_axes(collect(positions[1]))

    _plot_bands_on_ax!(ax, bs; kwargs...)
    ax.set_ylim(ylims...)

    fig.savefig(path)
    PythonPlot.close(fig)
    return path
end

# Default colors/styles for overlay
const _OVERLAY_STYLES = [
    (color = "black",  linewidth = 1.5, linestyle = "-"),
    (color = "blue",   linewidth = 1.2, linestyle = "--"),
    (color = "red",    linewidth = 1.2, linestyle = "-."),
    (color = "green",  linewidth = 1.2, linestyle = ":"),
    (color = "purple", linewidth = 1.2, linestyle = "--"),
]

# ── Vector{BandStructure} ──

function EmpiricalTightBinding.savefig_publication(
    bss::AbstractVector{<:BandStructure}, path::AbstractString;
    axis_width_cm = 8.0, axis_height_cm = 6.0,
    layout = (1, length(bss)),
    overlay = false,
    ylims = (-15, 15),
    title = "",
    kwargs...)

    if overlay
        # All BandStructures on a single axis
        fig_w, fig_h, positions = _layout_axes(axis_width_cm, axis_height_cm, 1)
        fig = PythonPlot.figure(figsize = (fig_w, fig_h))
        ax = fig.add_axes(collect(positions[1]))

        for (i, bs) in enumerate(bss)
            style = _OVERLAY_STYLES[mod1(i, length(_OVERLAY_STYLES))]
            _plot_bands_on_ax!(ax, bs;
                color = style.color, linewidth = style.linewidth,
                linestyle = style.linestyle)
        end

        ax.set_ylim(ylims...)
        ttl = title != "" ? title : join([bs.title for bs in bss], " / ")
        ax.set_title(ttl)
    else
        # Separate subplots
        nrows, ncols = layout
        n = length(bss)

        fig_w, fig_h, positions = _layout_axes(
            axis_width_cm, axis_height_cm, n;
            nrows, ncols)

        fig = PythonPlot.figure(figsize = (fig_w, fig_h))

        for (i, bs) in enumerate(bss)
            i > length(positions) && break
            ax = fig.add_axes(collect(positions[i]))
            _plot_bands_on_ax!(ax, bs; kwargs...)
            ax.set_ylim(ylims...)
        end
    end

    fig.savefig(path)
    PythonPlot.close(fig)
    return path
end

end
