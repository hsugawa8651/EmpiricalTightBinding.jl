# SPDX-License-Identifier: MIT
# Copyright (C) 2026 Hiroharu Sugawara
# Part of EmpiricalTightBinding.jl - Test suite
using Test
using LinearAlgebra

using EmpiricalTightBinding

@testset "EmpiricalTightBinding" begin

    @testset "Structure factors at Γ" begin
        g0, g1, g2, g3 = structure_factors([0.0, 0.0, 0.0])
        @test g0 ≈ 1.0
        @test abs(g1) < 1e-14
        @test abs(g2) < 1e-14
        @test abs(g3) < 1e-14
    end

    @testset "Structure factors at X" begin
        g0, g1, g2, g3 = structure_factors([1.0, 0.0, 0.0])
        @test abs(g0) < 1e-14
        @test g1 ≈ im
    end

    @testset "GaAs SP3Sstar at Γ" begin
        p = get_params(SP3Sstar, Vogl1983(), "GaAs")
        evals = band_energies(SP3Sstar(), [0, 0, 0], p)
        @test evals[2] ≈ 0.0 atol=0.001
        @test evals[3] ≈ 0.0 atol=0.001
        @test evals[4] ≈ 0.0 atol=0.001
        @test evals[5] ≈ 1.55 atol=0.01
    end

    @testset "GaAs SP3 at Γ" begin
        p = get_params(SP3, Vogl1983(), "GaAs")
        evals = band_energies(SP3(), [0, 0, 0], p)
        @test length(evals) == 8
        @test evals[2] ≈ 0.0 atol=0.001
        @test evals[3] ≈ 0.0 atol=0.001
        @test evals[4] ≈ 0.0 atol=0.001
    end

    @testset "Hermiticity" begin
        p = get_params(SP3Sstar, Vogl1983(), "GaAs")
        H = build_hamiltonian(SP3Sstar(), [0.3, 0.2, 0.1], p)
        @test H isa Hermitian
    end

    @testset "sp3_params extraction" begin
        p_full = get_params(SP3Sstar, Vogl1983(), "Si")
        p_sp3 = get_params(SP3, Vogl1983(), "Si")
        @test p_sp3.Es_a == p_full.Es_a
        @test p_sp3.Vss == p_full.Vss
    end

    @testset "KPath" begin
        kp = vogl_kpath(nk = 10)
        @test length(kp.kpoints) == length(kp.x)
        @test length(kp.tick_positions) >= 5
        @test kp.tick_labels[1] == "L"
        @test kp.tick_labels[end] == "Γ"
    end

    @testset "textbook_kpath" begin
        kp = textbook_kpath(nk = 10)
        @test kp.tick_labels[1] == "L"
        @test kp.tick_labels[end] == "X"
        @test length(kp.tick_labels) == 3
    end

    @testset "compute_bands" begin
        p = get_params(SP3Sstar, Vogl1983(), "GaAs")
        kp = vogl_kpath(nk = 10)
        bands = compute_bands(SP3Sstar(), kp, p)
        @test size(bands, 2) == 10
        @test size(bands, 1) == length(kp.kpoints)
    end

    @testset "Si SP3D5Sstar at Γ (Jancu Table IV)" begin
        p = get_params(SP3D5Sstar, Jancu1998(), "Si")
        evals = band_energies(SP3D5Sstar(), [0, 0, 0], p)
        vbm = evals[4]
        evals .-= vbm
        @test evals[1] ≈ -12.24 atol=0.02
        @test evals[4] ≈ 0.0 atol=0.001
        @test evals[5] ≈ 3.41 atol=0.02
        @test evals[8] ≈ 4.15 atol=0.03
    end

    @testset "Klimeck2000 GaAs" begin
        p = get_params(SP3Sstar, Klimeck2000(), "GaAs")
        evals = band_energies(SP3Sstar(), [0, 0, 0], p)
        gap = evals[5] - evals[4]
        @test gap > 1.0
        @test gap < 2.0
    end

    @testset "BandStructure" begin
        p = get_params(SP3Sstar, Vogl1983(), "GaAs")
        kp = vogl_kpath(nk = 10)

        # コンストラクタ
        bs = BandStructure(SP3Sstar(), kp, p)
        @test bs isa BandStructure

        # フィールドアクセス
        @test bs.x == kp.x
        @test bs.tick_positions == kp.tick_positions
        @test bs.tick_labels == kp.tick_labels

        # bands サイズ: nk × nbands
        @test size(bs.bands) == (length(kp.kpoints), hamiltonian_size(SP3Sstar()))

        # align=:VBM → VBM=0
        nv = n_valence(SP3Sstar(), "GaAs")
        vbm = maximum(bs.bands[:, nv])
        @test vbm ≈ 0.0 atol = 1e-10

        # title 自動生成
        @test occursin("GaAs", bs.title)
        @test occursin("sp³s*", bs.title) || occursin("SP3Sstar", bs.title)

        # title 手動指定
        bs2 = BandStructure(SP3Sstar(), kp, p; title = "Custom")
        @test bs2.title == "Custom"

        # align=:none
        bs3 = BandStructure(SP3Sstar(), kp, p; align = :none)
        vbm3 = maximum(bs3.bands[:, nv])
        @test vbm3 != 0.0

        # material 手動指定
        bs4 = BandStructure(SP3Sstar(), kp, p; material = "Test")
        @test occursin("Test", bs4.title)

        # SP3 でも動作
        p_sp3 = get_params(SP3, Vogl1983(), "GaAs")
        bs_sp3 = BandStructure(SP3(), kp, p_sp3)
        @test size(bs_sp3.bands, 2) == hamiltonian_size(SP3())

        # SP3D5Sstar でも動作
        p_d = get_params(SP3D5Sstar, Jancu1998(), "GaAs")
        bs_d = BandStructure(SP3D5Sstar(), kp, p_d)
        @test size(bs_d.bands, 2) == hamiltonian_size(SP3D5Sstar())
    end

    @testset "RecipesBase recipe" begin
        using RecipesBase

        p = get_params(SP3Sstar, Vogl1983(), "GaAs")
        kp = vogl_kpath(nk = 10)
        bs = BandStructure(SP3Sstar(), kp, p)

        # apply_recipe が動作する
        result = RecipesBase.apply_recipe(Dict{Symbol,Any}(), bs)
        @test length(result) > 0

        # series 数 = nbands + tick本数 + 1(hline)
        nbands = hamiltonian_size(SP3Sstar())
        nticks = length(kp.tick_positions)
        expected = nbands + nticks + 1
        @test length(result) == expected
    end

    @testset "Error fallbacks" begin
        # Unknown material
        @test_throws KeyError get_params(SP3Sstar, Vogl1983(), "Unobtanium")
        @test_throws KeyError get_params(SP3D5Sstar, Jancu1998(), "ZnTe")

        # Model-source mismatch (no method defined)
        @test_throws ArgumentError get_params(SP3D5Sstar, Vogl1983(), "GaAs")
        @test_throws ArgumentError get_params(SP3, Jancu1998(), "Si")

        # Correct model, wrong source type
        @test_throws ArgumentError get_params(SP3Sstar, 42, "GaAs")
        # Wrong model type, correct source
        @test_throws ArgumentError get_params(42, Vogl1983(), "GaAs")
        # Both wrong
        @test_throws ArgumentError get_params(42, 42, 42)

        # Wrong type for build_hamiltonian
        p = get_params(SP3Sstar, Vogl1983(), "GaAs")
        @test_throws ArgumentError build_hamiltonian("not_a_model", [0, 0, 0], p)
        @test_throws ArgumentError build_hamiltonian(42, [0, 0, 0], p)

        # Model-params type mismatch
        @test_throws ArgumentError build_hamiltonian(SP3D5Sstar(), [0, 0, 0], p)

        # Wrong type for list_materials
        @test_throws ArgumentError list_materials(42)

        # Wrong k dimension
        p = get_params(SP3Sstar, Vogl1983(), "GaAs")
        @test_throws ArgumentError build_hamiltonian(SP3Sstar(), [0, 0], p)
        @test_throws ArgumentError build_hamiltonian(SP3Sstar(), [0, 0, 0, 0], p)

        # k as Tuple works (no error)
        H = build_hamiltonian(SP3Sstar(), (0, 0, 0), p)
        @test H isa Hermitian

        # ── savefig_publication fallbacks ──
        p = get_params(SP3Sstar, Vogl1983(), "GaAs")
        kp = vogl_kpath(nk = 10)
        bs = BandStructure(SP3Sstar(), kp, p)

        # Correct type, but PythonPlot not loaded
        @test_throws ArgumentError savefig_publication(bs, "file.pdf")
        @test_throws ArgumentError savefig_publication([bs, bs], "file.pdf")

        # Wrong first argument type
        @test_throws ArgumentError savefig_publication(42, "file.pdf")

        # Wrong path type
        @test_throws ArgumentError savefig_publication(bs, 42)
    end

    @testset "Old API removed" begin
        @test !isdefined(EmpiricalTightBinding, :plot_bands)
        @test !isdefined(EmpiricalTightBinding, :plot_bands!)
    end

    @testset "savefig_publication (PythonPlot)" begin
        using PythonPlot

        p = get_params(SP3Sstar, Vogl1983(), "GaAs")
        kp = vogl_kpath(nk = 10)
        bs = BandStructure(SP3Sstar(), kp, p)

        # Single plot
        tmpfile = tempname() * ".pdf"
        savefig_publication(bs, tmpfile; axis_width_cm = 8.0, axis_height_cm = 6.0)
        @test isfile(tmpfile)
        rm(tmpfile)

        # Subplot
        bs2 = BandStructure(SP3(), kp, get_params(SP3, Vogl1983(), "GaAs"))
        tmpfile2 = tempname() * ".pdf"
        savefig_publication([bs, bs2], tmpfile2;
            axis_width_cm = 6.0, axis_height_cm = 5.0, layout = (1, 2))
        @test isfile(tmpfile2)
        rm(tmpfile2)
    end
end
