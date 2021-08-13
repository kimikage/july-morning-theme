# Design Language

```@setup ex
using Colors
using Main.Utilities

bg_light = colorant"#f5f5f5"
bg_dark  = colorant"#282f2f"

bg_documenter_light = colorant"#ffffff"
bg_documenter_dark  = colorant"#1f2424"

jl_red    = Colors.JULIA_LOGO_COLORS.red
jl_green  = Colors.JULIA_LOGO_COLORS.green
jl_blue   = Colors.JULIA_LOGO_COLORS.blue
jl_purple = Colors.JULIA_LOGO_COLORS.purple

jl_logo_colors = (jl_red, jl_green, jl_blue, jl_purple)

# unofficial colors based on the Julia logo colors
jl_orange    = LCHab(55, 70, 60)
jl_yellow    = LCHab(80, 65, 85)
jl_turquoise = LCHab(70, 39, 215)
jl_cyan      = LCHab(60, 50, 265)

jl_colors = (jl_red, jl_orange, jl_yellow, jl_green,
             jl_turquoise, jl_cyan, jl_blue, jl_purple)

d27_primary   = colorant"#4eb5de"
d27_red       = colorant"#da0b00"
d27_orange    = colorant"#ff470f" # bulma default
d27_yellow    = colorant"#ffdd57" # bulma default
d27_green     = colorant"#22c35b"
d27_turquoise = colorant"#1db5c9"
d27_cyan      = colorant"#209cee" # bulma default
d27_blue      = colorant"#2e63b8"
d27_purple    = colorant"#b86bff" # bulma default

d27_colors_light = (d27_red, d27_orange, d27_yellow, d27_green,
                    d27_turquoise, d27_cyan, d27_blue, d27_purple)

d27_primary_dark   = colorant"#1abc9c" # DARKLY's turquoise
d27_red_dark       = colorant"#9e1b0d"
d27_orange_dark    = colorant"#e67e22" # DARKLY
d27_yellow_dark    = colorant"#ad8100"
d27_green_dark     = colorant"#008438"
d27_turquoise_dark = colorant"#137886"
d27_cyan_dark      = colorant"#024c7d"
d27_blue_dark      = colorant"#3498db" # DARKLY
d27_purple_dark    = colorant"#8e44ad" # DARKLY

d27_colors_dark = (d27_red_dark, d27_orange_dark, d27_yellow_dark, d27_green_dark,
                   d27_turquoise_dark, d27_cyan_dark, d27_blue_dark, d27_purple_dark)

# dl, dc
tw_red       = ( 0,  0)
tw_orange    = ( 1,  3)
tw_yellow    = ( 1,  4)
tw_green     = ( 0,  3)
tw_turquoise = (-4,  0)
tw_cyan      = (-2,  0)
tw_blue      = (-1, -1)
tw_purple    = ( 0,  0)

tw_light = (tw_red, tw_orange, tw_yellow, tw_green,
            tw_turquoise, tw_cyan, tw_blue, tw_purple)

new_colors_light = adjust_color_lch.(jl_colors, tw_light)

new_red, new_orange, new_yellow, new_green, new_turquoise, new_cyan, new_blue, new_purple =
    new_colors_light

dl_red       = 10
dl_orange    = 10
dl_yellow    = 33
dl_green     = 10
dl_turquoise = 13
dl_cyan      = 18
dl_blue      = 11
dl_purple    = 10

dl = (dl_red, dl_orange, dl_yellow, dl_green, dl_turquoise, dl_cyan, dl_blue, dl_purple)

new_colors_dark = lch_darken.(new_colors_light, dl)

new_red_dark, new_orange_dark, new_yellow_dark, new_green_dark,
new_turquoise_dark, new_cyan_dark, new_blue_dark, new_purple_dark = new_colors_dark

ansi_base_colors = (new_red, new_green, new_yellow, new_blue, new_purple, new_turquoise)

dl_ansi_light_green   = 8
dl_ansi_light_yellow  = 24
dl_ansi_light_magenta = 1
dl_ansi_light_cyan    = 6

dl_ansi_light = (0, dl_ansi_light_green, dl_ansi_light_yellow,
                 0, dl_ansi_light_magenta, dl_ansi_light_cyan)

ansi_light_red     = new_red
ansi_light_green   = lch_darken(new_green, dl_ansi_light_green)
ansi_light_yellow  = lch_darken(new_yellow, dl_ansi_light_yellow)
ansi_light_blue    = new_blue
ansi_light_magenta = lch_darken(new_purple, dl_ansi_light_magenta)
ansi_light_cyan    = lch_darken(new_turquoise, dl_ansi_light_cyan)

dl_ansi_red     = 11
dl_ansi_green   = 7
dl_ansi_yellow  = 12
dl_ansi_blue    = 9
dl_ansi_magenta = 8
dl_ansi_cyan    = 9

dl_ansi = (dl_ansi_red, dl_ansi_green, dl_ansi_yellow,
           dl_ansi_blue, dl_ansi_magenta, dl_ansi_cyan)

ansi_colors_light = [
    colorant"#242424",
    lch_darken(ansi_light_red, dl_ansi_red),
    lch_darken(ansi_light_green, dl_ansi_green),
    lch_darken(ansi_light_yellow, dl_ansi_yellow),
    lch_darken(ansi_light_blue, dl_ansi_blue),
    lch_darken(ansi_light_magenta, dl_ansi_magenta),
    lch_darken(ansi_light_cyan, dl_ansi_cyan),
    colorant"#8f8f8f",
    colorant"#707070",
    ansi_light_red,
    ansi_light_green,
    ansi_light_yellow,
    ansi_light_blue,
    ansi_light_magenta,
    ansi_light_cyan,
    colorant"#f5f5f5"
]

ll_ansi_red     = 16
ll_ansi_green   = 10
ll_ansi_yellow  = 0
ll_ansi_blue    = 16
ll_ansi_magenta = 16
ll_ansi_cyan    = 8


ll_ansi = (ll_ansi_red, ll_ansi_green, ll_ansi_yellow,
           ll_ansi_blue, ll_ansi_magenta, ll_ansi_cyan)

ansi_red_dark = lch_lighten(new_red, ll_ansi_red)
ansi_green_dark = lch_lighten(new_green, ll_ansi_green)
ansi_yellow_dark = lch_lighten(new_yellow, ll_ansi_yellow)
ansi_blue_dark = lch_lighten(new_blue, ll_ansi_blue)
ansi_magenta_dark = lch_lighten(new_purple, ll_ansi_magenta)
ansi_cyan_dark = lch_lighten(new_turquoise, ll_ansi_cyan)

ll_ansi_light_red     = 7
ll_ansi_light_green   = 12
ll_ansi_light_yellow  = 14
ll_ansi_light_blue    = 7
ll_ansi_light_magenta = 9
ll_ansi_light_cyan    = 7

ll_ansi_light = (ll_ansi_light_red, ll_ansi_light_green, ll_ansi_light_yellow,
                 ll_ansi_light_blue, ll_ansi_light_magenta, ll_ansi_light_cyan)

ansi_colors_dark = [
    colorant"#242424",
    ansi_red_dark,
    ansi_green_dark,
    ansi_yellow_dark,
    ansi_blue_dark,
    ansi_magenta_dark,
    ansi_cyan_dark,
    colorant"#b3bdbe",
    colorant"#92a0a2",
    lch_lighten(ansi_red_dark, ll_ansi_light_red),
    lch_lighten(ansi_green_dark, ll_ansi_light_green),
    lch_lighten(ansi_yellow_dark, ll_ansi_light_yellow),
    lch_lighten(ansi_blue_dark, ll_ansi_light_blue),
    lch_lighten(ansi_magenta_dark, ll_ansi_light_magenta),
    lch_lighten(ansi_cyan_dark, ll_ansi_light_cyan),
    colorant"#f5f5f5"
]

function print_adjust_color(f, s, c, d)
    if d == 0
        print(f, raw"$", s)
        return
    end
    dh0, ds0, dl0 = get_hsl_adjuster(c, d)
    print(f, raw"adjust-color($", s, ", ")
    print(f, raw"$hue: ", dh0, ", ")
    print(f, raw"$saturation: ", ds0, ", ")
    print(f, raw"$lightness: ", dl0, ")")
end

open(joinpath(@__DIR__, "..", "scss", "_basiccolors.scss"), "w") do f
    sym = (:red, :orange, :yellow, :green, :turquoise, :cyan, :blue, :purple)
    for (s, c) in zip(sym, new_colors_light)
        println(f, raw"$", s, ": #", hex(c, :rrggbb), ";")
    end
    println(f)
    for (s, c, d) in zip(sym, new_colors_light, dl)
        print(f, raw"$", s, "-dark: ")
        print_adjust_color(f, s, c, -d)
        println(f, ";")
    end
end

open(joinpath(@__DIR__, "..", "scss", "_ansicolors_def.scss"), "w") do f
    println(f, raw"@if $documenter-is-dark-theme {")
    asym = (:red, :green, :yellow, :blue, :magenta, :cyan)
    sym  = (:red, :green, :yellow, :blue, :purple, :turquoise)
    for (as, s, c, d) in zip(asym, sym, ansi_base_colors, ll_ansi)
        print(f, raw"  $ansi-", as, ": ")
        print_adjust_color(f, s, c, d)
        println(f, " !default;")
    end
    println(f, raw"  $ansi-white: lighten($grey-light, 14) !default;", "\n")
    println(f, raw"  $ansi-light-black: darken($ansi-white, 12) !default;")
    for (as, c, d) in zip(asym, ansi_colors_dark[2:7], ll_ansi_light)
        print(f, raw"  $ansi-light-", as, ": ")
        print_adjust_color(f, "ansi-$as", c, d)
        println(f, " !default;")
    end
    println(f, "}")
    println(f, "@else {")
    println(f, raw"  $ansi-light-black: darken($grey, 4) !default;")
    for (as, s, c, d) in zip(asym, sym, ansi_base_colors, dl_ansi_light)
        print(f, raw"  $ansi-light-", as, ": ")
        print_adjust_color(f, s, c, -d)
        println(f, " !default;")
    end
    println(f)
    for (as, c, d) in zip(asym, ansi_colors_light[10:15], dl_ansi)
        print(f, raw"  $ansi-", as, ": ")
        print_adjust_color(f, "ansi-light-$as", c, -d)
        println(f, " !default;")
    end
    println(f, raw"  $ansi-white: lighten($ansi-light-black, 12) !default;")
    println(f, "}")
end
```

## Policy
- Ensure color accessibility (e.g. contrast)
- Harmonize the light and dark themes
- Use derived colors with systematic schemes (i.e. reduce magic numbers)
- Imitate major color schemes
- Inherit Julia's color identity

## Basic Colors
Here, the basic colors are `$red`, `$orange`, `$yellow`, `$green`, `$turquoise`,
`$cyan`, `$blue`, and `$purple`. These names are from the Bulma CSS framework,
but since the time it was introduced into Documenter.jl, their colors have been
customized from the initial values. The basic colors are assigned separately for
the light and dark themes.

### Documenter v0.27
```@example ex
ColorOrbits("d27_light", jl_logo_colors, d27_colors_light, bg_documenter_light) # hide
```
```@example ex
ColorOrbits("d27_dark", jl_logo_colors, d27_colors_dark, bg_documenter_dark) # hide
```
```@example ex
ColorOrbits("d27_both", d27_colors_light, d27_colors_dark, colorant"#888") # hide
```
In the three figures above, the small filled circles represent the basic colors.
Their angles represent the hue, and their radii represent the lightness (in the
Lab color space). The squares indicate Julia's logo colors (red, green, blue,
and purple). The chart with a white background shows the basic colors for the
light theme, the chart with a black background shows the basic colors for the
dark theme, and the chart with a gray background shows the basic colors for both
the light and dark themes.

```@example ex
ContrastChecker(d27_colors_light) # hide
```
```@example ex
ContrastChecker(d27_colors_dark) # hide
```
### Tweaked

```@example ex
ColorOrbits("new_light", jl_logo_colors, new_colors_light, bg_documenter_light) # hide
```
```@example ex
ColorOrbits("new_dark", jl_logo_colors, new_colors_dark, bg_documenter_dark) # hide
```
```@example ex
ColorOrbits("new_both", new_colors_light, new_colors_dark, colorant"#888") # hide
```

```@example ex
ContrastChecker(new_colors_light) # hide
```
```@example ex
ContrastChecker(new_colors_dark) # hide
```
#### Light Colors
```@example ex
VariationSwatches(jl_red, d27_red, tw_red) # hide
```
```@example ex
VariationSwatches(jl_green, d27_green, tw_green) # hide
```
```@example ex
VariationSwatches(jl_blue, d27_blue, tw_blue) # hide
```
```@example ex
VariationSwatches(jl_purple, d27_purple, tw_purple) # hide
```

```@example ex
VariationSwatches(lch_to_rgb8(jl_orange), d27_orange, tw_orange) # hide
```
```@example ex
VariationSwatches(lch_to_rgb8(jl_yellow), d27_yellow, tw_yellow) # hide
```
```@example ex
VariationSwatches(lch_to_rgb8(jl_turquoise), d27_turquoise, tw_turquoise) # hide
```
```@example ex
VariationSwatches(lch_to_rgb8(jl_cyan), d27_cyan, tw_cyan) # hide
```

#### Dark Colors
```@example ex
DarkerVariationSwatches(new_red, d27_red_dark, dl_red) # hide
```
```@example ex
DarkerVariationSwatches(new_green, d27_green_dark, dl_green) # hide
```
```@example ex
DarkerVariationSwatches(new_blue, d27_cyan_dark, dl_blue) # hide
```
```@example ex
DarkerVariationSwatches(new_purple, d27_purple_dark, dl_purple) # hide
```
```@example ex
DarkerVariationSwatches(new_orange, d27_orange_dark, dl_orange) # hide
```
```@example ex
DarkerVariationSwatches(new_yellow, d27_yellow_dark, dl_yellow) # hide
```
```@example ex
DarkerVariationSwatches(new_turquoise, d27_turquoise_dark, dl_turquoise) # hide
```
```@example ex
DarkerVariationSwatches(new_cyan, d27_cyan_dark, dl_cyan) # hide
```

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

## Primary Color
The primary color for the light theme is `$blue`.

The primary color for the dark theme is sea green, whose hue is the mean of
`$green` and `$turquoise`.

```@example ex
VariationSwatches(LCHab(65, 50, 175), bg_dark, (0, 0)) # hide
```

## Terminal (ANSI) Colors
#### Light theme
```@example ex
DarkerVariationSwatches(new_green, bg_light, dl_ansi_light_green) # hide
```
```@example ex
DarkerVariationSwatches(new_yellow, bg_light, dl_ansi_light_yellow) # hide
```
```@example ex
DarkerVariationSwatches(new_purple, bg_light, dl_ansi_light_magenta) # hide
```
```@example ex
DarkerVariationSwatches(new_turquoise, bg_light, dl_ansi_light_cyan) # hide
```
```@example ex
DarkerVariationSwatches(ansi_light_red, ansi_light_red, dl_ansi_red) # hide
```
```@example ex
DarkerVariationSwatches(ansi_light_green, ansi_light_green, dl_ansi_green) # hide
```
```@example ex
DarkerVariationSwatches(ansi_light_yellow, ansi_light_yellow, dl_ansi_yellow) # hide
```
```@example ex
DarkerVariationSwatches(ansi_light_blue, ansi_light_blue, dl_ansi_blue) # hide
```
```@example ex
DarkerVariationSwatches(ansi_light_magenta, ansi_light_magenta, dl_ansi_magenta) # hide
```
```@example ex
DarkerVariationSwatches(ansi_light_cyan, ansi_light_cyan, dl_ansi_cyan) # hide
```

#### Dark theme
```@example ex
LighterVariationSwatches(new_red, bg_dark, ll_ansi_red) # hide
```
```@example ex
LighterVariationSwatches(new_green, bg_dark, ll_ansi_green) # hide
```
```@example ex
LighterVariationSwatches(new_blue, bg_dark, ll_ansi_blue) # hide
```
```@example ex
LighterVariationSwatches(new_purple, bg_dark, ll_ansi_magenta) # hide
```
```@example ex
LighterVariationSwatches(new_turquoise, bg_dark, ll_ansi_cyan) # hide
```
```@example ex
LighterVariationSwatches(ansi_red_dark, ansi_red_dark, ll_ansi_light_red) # hide
```
```@example ex
LighterVariationSwatches(ansi_green_dark, ansi_green_dark, ll_ansi_light_green) # hide
```
```@example ex
LighterVariationSwatches(ansi_yellow_dark, ansi_yellow_dark, ll_ansi_light_yellow) # hide
```
```@example ex
LighterVariationSwatches(ansi_blue_dark, ansi_blue_dark, ll_ansi_light_blue) # hide
```
```@example ex
LighterVariationSwatches(ansi_magenta_dark, ansi_magenta_dark, ll_ansi_light_magenta) # hide
```
```@example ex
LighterVariationSwatches(ansi_cyan_dark, ansi_cyan_dark, ll_ansi_light_cyan) # hide
```

### Demos
```@example ex
TerminalPreview(ansi_colors_light, bg_light) # hide
```
```@example ex
TerminalPreview(ansi_colors_dark, bg_dark) # hide
```

```@repl
using Crayons
Crayons.print_logo()
Crayons.test_system_colors()
```

## Variants
TBD

### Pale turquoise
```@example ex
VariationSwatches(adjust_color_lch(jl_turquoise, (-12, -8)), bg_light, (0, 0)) # hide
```
```@example ex
VariationSwatches(adjust_color_lch(jl_turquoise, (8, -8)), bg_dark, (0, 0)) # hide
```

### Pale blue
```@example ex
VariationSwatches(adjust_color_lch(jl_blue, (0, -8)), bg_light, (0, 0)) # hide
```
```@example ex
VariationSwatches(adjust_color_lch(jl_blue, (8, -8)), bg_dark, (0, 0)) # hide
```

### Gray beige
```@example ex
VariationSwatches(adjust_color_lch(jl_yellow, (-12, -20)), bg_light, (0, 0)) # hide
```
```@example ex
VariationSwatches(adjust_color_lch(jl_yellow, (-8, -20)), bg_dark, (0, 0)) # hide
```