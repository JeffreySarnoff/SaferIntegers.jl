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
        "Benchmarks" => "benchmarks.md",
        "How To Use" => "howtouse.md",
        "Refs" => "references.md"
    ]
)

deploydocs(
    repo = "github.com/JeffreySarnoff/SaferIntegers.jl.git",
    target = "build"
)
