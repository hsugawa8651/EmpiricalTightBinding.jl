# SPDX-License-Identifier: MIT
# Copyright (C) 2026 Hiroharu Sugawara
# Part of EmpiricalTightBinding.jl - Abstract types and common utilities

#= Abstract root for all tight-binding models. =#
abstract type TBModel end

"""Hamiltonian matrix dimension for each model."""
function hamiltonian_size end

_check_k(k) =
    length(k) == 3 ||
        throw(ArgumentError("k must be a 3-component vector, got length $(length(k))."))

"""
    build_hamiltonian(model::TBModel, k, params) -> Hermitian{ComplexF64}

Build the tight-binding Hamiltonian at wave vector `k` (in units of 2π/a).
Dispatches on the model type.
"""
function build_hamiltonian(model::TBModel, k, params)
    _check_k(k)
    throw(ArgumentError(
        "No Hamiltonian defined for model=$(model) with params type=$(typeof(params)). " *
        "Check that the model and parameter source are compatible.",
    ))
end

function build_hamiltonian(model, k, params)
    throw(ArgumentError(
        "First argument must be a concrete TBModel instance, got $(typeof(model)).",
    ))
end
