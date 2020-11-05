using Documenter
using DocumenterTools
using DocumenterTools: Themes

include("utilities.jl")

Themes.compile(joinpath(@__DIR__, "scss/light.scss"), joinpath(@__DIR__, "src/assets/themes/documenter-light.css"))
Themes.compile(joinpath(@__DIR__, "scss/dark.scss"), joinpath(@__DIR__, "src/assets/themes/documenter-dark.css"))

makedocs(
    clean = false,
    modules = Module[],
    format = Documenter.HTML(prettyurls = get(ENV, "CI", nothing) == "true",
                             assets = ["assets/styles.css", "assets/highlight.min.js", "assets/hljs.js"]),
    checkdocs = :exports,
    sitename = "July Morning/Night",
    pages = Any[
        "Introduction" => "index.md",
        "Examples" => "examples.md",
        "Design Language" => "design-language.md",
        ]
    )

deploydocs(
    repo = "github.com/kimikage/july-morning-theme.git",
    target = "build",
    devbranch = "main",
    push_preview = true
    )
