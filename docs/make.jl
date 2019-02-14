using Documenter, SaferIntegers

makedocs(
    modules = [SaferIntegers],
    sitename = "SaferIntegers.jl",
    authors = "Jeffrey Sarnoff",
    pages = Any[
        "Overview" => "index.md",
        "Highlights" => "highlights.md",
        "Basic Guide" => "basicguide.md",
        "Supported Operations" => "supports.md",
        "How To Use" => "howtouse.md",
        "Safe Shifts" => "safeshifts.md",
        "Safer Rationals" => "rationals.md",
        "Benchmarks" => "benchmarks.md",
        "Refs" => "references.md"
    ]
)

deploydocs(
    repo = "github.com/JeffreySarnoff/SaferIntegers.jl.git",
    target = "build"
)
