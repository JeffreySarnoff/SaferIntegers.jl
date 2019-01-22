using Documenter, SaferIntegers

makedocs(
    modules = [SaferIntegers],
    sitename = "SaferIntegers.jl",
    authors = "Jeffrey Sarnoff",
    pages = Any[
        "Overview" => "index.md",
        "How To Use" => "howtouse.md",
        "Refs" => "references.md"
    ]
)

deploydocs(
    repo = "github.com/JeffreySarnoff/SaferIntegers.jl.git",
    target = "build"
)
