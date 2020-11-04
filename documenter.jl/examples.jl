
const mdpath = joinpath(@__DIR__, "src", "examples.md")
const juliapath = joinpath(@__DIR__, "utilities.jl")
const yamlpath = joinpath(@__DIR__, "..", ".github", "workflows", "documenter.yml")
const csspath = joinpath(@__DIR__, "src", "assets", "styles.css")

open(mdpath, "w") do f
    println(f, "# Examples")
    println(f)
    println(f, "## Julia")
    println(f, "```@docs")
    println(f, "Main.Utilities.adjust_color")
    println(f, "```")
    println(f)
    println(f, "````julia")
    write(f, read(juliapath, String))
    println(f, "````")
    println(f)
    println(f, "## YAML")
    println(f, "```yaml")
    write(f, read(yamlpath, String))
    println(f, "```")
    println(f)
    println(f, "## CSS")
    println(f, "```css")
    write(f, read(csspath, String))
    println(f, "```")
    println(f)
end
