using Documenter
using EmpiricalTightBinding

makedocs(
    sitename = "EmpiricalTightBinding.jl",
    modules = [EmpiricalTightBinding],
    authors = "Hiroharu Sugawara",
    remotes = nothing,
    warnonly = [:missing_docs],
    format = Documenter.HTML(
        canonical = "https://hsugawa8651.github.io/EmpiricalTightBinding.jl",
        edit_link = "main",
    ),
    pages = [
        "Home" => "index.md",
        "Getting Started" => "guide.md",
        "Theory" => "theory.md",
        "Models" => [
            "Overview" => "models/overview.md",
            "SP3" => "models/sp3.md",
            "SP3S*" => "models/sp3sstar.md",
            "SP3S* + Spin-Orbit" => "models/sp3sstar_so.md",
            "SP3D5S*" => "models/sp3d5sstar.md",
        ],
        "Parameter Sources" => "parameters.md",
        "K-Paths & Brillouin Zone" => "kpaths.md",
        "Plotting" => [
            "Overview" => "plotting/overview.md",
            "Plots.jl (Recipe)" => "plotting/plots.md",
            "Publication Figures" => "plotting/publication.md",
        ],
        "Examples" => [
            "GaAs Band Structure" => "examples/gaas.md",
            "Comparing Models" => "examples/compare_models.md",
            "Comparing Parameter Sets" => "examples/compare_params.md",
        ],
        "API Reference" => "api.md",
        "References" => "references.md",
    ],
)

deploydocs(
    repo = "github.com/hsugawa8651/EmpiricalTightBinding.jl.git",
    devbranch = "main",
)
