using Documenter
using DocumenterTools
using DocumenterTools: Themes

include("utilities.jl")

Themes.compile(joinpath(@__DIR__, "scss/light.scss"), joinpath(@__DIR__, "src/assets/themes/documenter-light.css"))
Themes.compile(joinpath(@__DIR__, "scss/dark.scss"), joinpath(@__DIR__, "src/assets/themes/documenter-dark.css"))

include("examples.jl")

assets = [
    "assets/styles.css",
    "assets/highlight.min.js",
    "assets/hljs.js",
    ]
makedocs(
    clean = false,
    modules = Module[],
    format = Documenter.HTML(prettyurls = get(ENV, "CI", nothing) == "true",
                             ansicolor = true,
                             assets = assets),
    checkdocs = :exports,
    sitename = "July Morning/Night",
    pages = Any[
        "Introduction" => "index.md",
        "Examples" => "examples.md",
        "Design Language" => "design-language.md",
        ]
    )

documenterjs = joinpath(@__DIR__, "build", "assets", "documenter.js")
lines = readlines(documenterjs, keep = true)
open(documenterjs, "w") do f
    for line in lines
        occursin("hljs.highlightAll", line) && write(f, "//")
        write(f, line)
    end
end

deploydocs(
    repo = "github.com/kimikage/july-morning-theme.git",
    target = "build",
    devbranch = "main",
    push_preview = true
    )
