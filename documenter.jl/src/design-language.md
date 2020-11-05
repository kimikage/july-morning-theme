# Design Language

```@setup ex
using Colors
using Main.Utilities

bg_light = colorant"#f5f5f5"
bg_dark = colorant"#282f2f"

bg_documenter_light = colorant"#ffffff"
bg_documenter_dark = colorant"#1f2424"

jl_red = colorant"#cb3c33"
jl_green = colorant"#389826"
jl_blue = colorant"#4063d8"
jl_purple = colorant"#9558b2"

jl_colors = [jl_red, jl_green, jl_blue, jl_purple]

d25_primary = colorant"#4eb5de"
d25_red = colorant"#da0b00"
d25_yellow = colorant"#ffdd57" # bulma default
d25_green = colorant"#22c35b"
d25_turquoise = colorant"#1db5c9"
d25_cyan = colorant"#209cee" # bulma default
d25_blue = colorant"#2e63b8"
d25_purple = colorant"#b86bff" # bulma default

d25_colors_light = [
    d25_red,
    d25_yellow,
    d25_green,
    d25_turquoise,
    d25_cyan,
    d25_blue,
    d25_purple
]

d25_primary_dark = colorant"#1abc9c" # DARKLY's turquoise
d25_red_dark = colorant"#9e1b0d"
d25_yellow_dark = colorant"#ad8100"
d25_green_dark = colorant"#008438"
d25_turquoise_dark = colorant"#137886"
d25_cyan_dark = colorant"#024c7d"
d25_blue_dark = colorant"#3498db" # DARKLY
d25_purple_dark = colorant"#8e44ad" # DARKLY

d25_colors_dark = [
    d25_red_dark,
    d25_yellow_dark,
    d25_green_dark,
    d25_turquoise_dark,
    d25_cyan_dark,
    d25_blue_dark,
    d25_purple_dark
]

new_red = tweak_color(jl_red, 0, 3)
new_yellow = tweak_color(LCHab(80, 65, 80), 1, 2)
new_green = tweak_color(jl_green, 1, 3)
new_turquoise = tweak_color(LCHab(70, 38, 215), -4, 0)
new_cyan = tweak_color(LCHab(60, 50, 260), -2, 0)
new_blue = tweak_color(jl_blue, -1, 0)
new_purple = tweak_color(jl_purple, 0, 3)

new_colors_light = [
    new_red,
    new_yellow,
    new_green,
    new_turquoise,
    new_cyan,
    new_blue,
    new_purple
]

dl_red = 11
dl_yellow = 25
dl_green = 10
dl_turquoise = 10
dl_cyan = 17
dl_blue = 15
dl_purple = 13

new_red_dark = hsl_darken(new_red, dl_red)
new_yellow_dark = hsl_darken(new_yellow, dl_yellow)
new_green_dark = hsl_darken(new_green, dl_green)
new_turquoise_dark = hsl_darken(new_turquoise, dl_turquoise)
new_cyan_dark = hsl_darken(new_cyan, dl_cyan)
new_blue_dark = hsl_darken(new_blue, dl_blue)
new_purple_dark = hsl_darken(new_purple, dl_purple)

new_colors_dark = [
    new_red_dark,
    new_yellow_dark,
    new_green_dark,
    new_turquoise_dark,
    new_cyan_dark,
    new_blue_dark,
    new_purple_dark
]

open(joinpath("..", "scss", "_basiccolors.scss"), "w") do f
    sym = [:red, :yellow, :green, :turquoise, :cyan, :blue, :purple]
    for (s, c) in zip(sym, new_colors_light)
        println(f, raw"$", s, ": #", hex(c, :rrggbb), ";")
    end
end
open(joinpath("..", "scss", "_darkcolors.scss"), "w") do f
    println(f, raw"$info: darken($cyan, ", dl_cyan, ");")
    println(f, raw"$success: darken($green, ", dl_green, ");")
    println(f, raw"$warning: darken($yellow, ", dl_yellow, ");")
    println(f, raw"$danger: darken($red, ", dl_red, ");")
    println(f, raw"$compat: darken($turquoise, ", dl_turquoise, ");")
end
```

## Policy
- Ensure color accessibility (e.g. contrast)
- Harmonize the light and dark themes
- Use derived colors with systematic schemes (i.e. reduce magic numbers)
- Imitate major color schemes
- Inherit Julia's color identity

## Basic Colors

### Documenter v0.25
```@example ex
ColorOrbits("d25_light", jl_colors, d25_colors_light, bg_documenter_light) # hide
```
```@example ex
ColorOrbits("d25_dark", jl_colors, d25_colors_dark, bg_documenter_dark) # hide
```
```@example ex
ColorOrbits("d25_comp", d25_colors_light, d25_colors_dark, colorant"#888") # hide
```

```@example ex
ContrastChecker(d25_colors_light) # hide
```
### Tweaked

```@example ex
ColorOrbits("new_light", jl_colors, new_colors_light, bg_documenter_light) # hide
```
```@example ex
ColorOrbits("new_light", jl_colors, new_colors_dark, bg_documenter_dark) # hide
```
```@example ex
ColorOrbits("new_light", new_colors_light, new_colors_dark, colorant"#888") # hide
```

```@example ex
ContrastChecker(new_colors_light) # hide
```

#### Light Colors
```@example ex
VariationSwatches("new_red_cand", jl_red, d25_red, (0, 3)) # hide
```
```@example ex
VariationSwatches("new_green_cand", jl_green, d25_green, (1, 3)) # hide
```
```@example ex
VariationSwatches("new_blue_cand", jl_blue, d25_blue, (-1, 0)) # hide
```
```@example ex
VariationSwatches("new_purple_cand", jl_purple, d25_purple, (0, 3)) # hide
```


```@example ex
VariationSwatches("new_yellow_cand", lch_to_rgb8(LCHab(80, 65, 80)), d25_yellow, (1, 2)) # hide
```
```@example ex
VariationSwatches("new_turquoise_cand", lch_to_rgb8(LCHab(70, 38, 215)), d25_turquoise, (-4, 0)) # hide
```
```@example ex
VariationSwatches("new_cyan_cand", lch_to_rgb8(LCHab(60, 50, 260)), d25_cyan, (-2, 0)) # hide
```

#### Dark Colors


### Demos
!!! danger "Red"
    This is a `!!! danger`-type admonition.

!!! warning "Yellow"
    This is a `!!! warning`-type admonition.

!!! tip "Green"
    This is a `!!! tip`-type admonition.

!!! compat "Turquoise"
    This is a `!!! compat`-type admonition.

!!! info "Cyan"
    This is a `!!! info`-type admonition.

!!! unknown
    This is an unknown admonition.

[`$blue` is used in link texts (light theme)](#Light-Colors)


## Primary/Secondary Colors

## Terminal (ANSI) Colors

```@example ex
TerminalPreview() # hide
```

## Variants
### Red
```@example ex
VariationSwatches("julia-red-light", jl_red, bg_light) # hide
```
```@example ex
VariationSwatches("julia-red-dark", jl_red, bg_dark) # hide
```
### Green
```@example ex
VariationSwatches("julia-red-light", jl_green, bg_light) # hide
```
```@example ex
VariationSwatches("julia-red-dark", jl_green, bg_dark) # hide
```
### Blue
```@example ex
VariationSwatches("julia-red-light", jl_blue, bg_light) # hide
```
```@example ex
VariationSwatches("julia-red-dark", jl_blue, bg_dark) # hide
```
### Purple
```@example ex
VariationSwatches("julia-red-light", jl_purple, bg_light) # hide
```
```@example ex
VariationSwatches("julia-red-dark", jl_purple, bg_dark) # hide
```