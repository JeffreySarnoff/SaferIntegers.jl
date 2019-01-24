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
        "Symbols Used" => "symbols.md",
        "How To Use" => "howtouse.md",
        "Benchmarks" => "benchmarks.md",
        "Refs" => "references.md"
    ]
)

deploydocs(
    repo = "github.com/JeffreySarnoff/SaferIntegers.jl.git",
    target = "build"
)
