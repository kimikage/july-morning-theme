# Examples

## Julia

```julia
module Utilities

using Printf
using Colors
using FixedPointNumbers

export lch_to_rgb, lch_to_rgb8, tweak_color, hsl_lighten, hsl_darken
export ContrastChecker, ColorOrbits, VariationSwatches, TerminalPreview


round3p1(x) = @sprintf("%5.1f" , x)

# Many graphics tools set the white point in the Lab color space to D50 and use
# a linear bradford transform to convert it to the D65 in the sRGB color space.

function rgb_to_lab(c::RGB)
    xyz65 = convert(XYZ, c)
    xyz50 = bradford(xyz65, Colors.WP_D65, Colors.WP_D50)
    convert(Lab, xyz50, Colors.WP_D50)
end

function lab_to_rgb(c::Lab)
    xyz50 = convert(XYZ, c, Colors.WP_D50)
    xyz65 = bradford(xyz50, Colors.WP_D50, Colors.WP_D65)
    convert(RGB, xyz65)
end

rgb_to_lch(c::RGB) = convert(LCHab, rgb_to_lab(c))
lch_to_rgb(c::LCHab) = lab_to_rgb(convert(Lab, c))

lch_to_rgb8(c::LCHab) = convert(RGB{N0f8}, lch_to_rgb(c))

function bradford(c::XYZ, src::XYZ, dest::XYZ)
    BFD = [ 0.8951  0.2664 -0.1614
           -0.7502  1.7135  0.0367
            0.0389 -0.0685  1.0296 ]
    BFD_INV = inv(BFD)

    c_lms = BFD * [c.x, c.y, c.z]
    src_wp = BFD * [src.x, src.y, src.z]
    dest_wp = BFD * [dest.x, dest.y, dest.z]
    c_out = BFD_INV * (c_lms .* dest_wp ./ src_wp)
    (typeof(c))(c_out...)
end

function contrast(c1::RGB, c2::RGB)
    xyz1 = convert(XYZ, c1)
    xyz2 = convert(XYZ, c2)
    l2, l1 = minmax(xyz1.y, xyz2.y)
    cont = (l1 + 0.05) / (l2 + 0.05)
end

function contrast_level(cont, islarge = false)
    if islarge
        cont < 3.0 ? "fail" : cont < 4.5 ? "AA" : "AAA"
    else
        cont < 4.5 ? "fail" : cont < 7.0 ? "AA" : "AAA"
    end
end

tweak_color(c::RGB, dl, dc = 0, dh = 0) = tweak_color(rgb_to_lch(c), dl, dc, dh)

function tweak_color(c::LCHab, dl, dc = 0, dh = 0)
    lch_to_rgb8(LCHab(c.l + dl * 2.5, c.c + dc * 5, c.h + dh))
end

function hsl_lighten(c::RGB, a)
    hsl = convert(HSL, c)
    convert(RGB{N0f8}, HSL(hsl.h, hsl.s, hsl.l + a / 100))
end
hsl_darken(c::RGB, a) = hsl_lighten(c::RGB, -a)

struct ContrastChecker
    colors::Vector{RGB}
end

Base.showable(::MIME"text/html", ::ContrastChecker) = true

function Base.show(io::IO, ::MIME"text/html", cc::ContrastChecker)
    write(io, """<pre class="contrast" style="padding:2pt;">""")
    for c in cc.colors
        hex6 = hex(c)
        base = XYZ(c).y > 0.6 ? colorant"black" : colorant"white"
        hex6b = hex(base)
        cont = contrast(base, c)
        scont = lpad(round3p1(cont), 5)
        sl = lpad(contrast_level(cont, false), 4)
        ll = lpad(contrast_level(cont, true), 4)
        write(io, """<span style="font-size:14pt">""")
        write(io, """<span style="background:#$hex6;color:#$hex6b">$scont:1 small</span>""")
        write(io, """<span style="background:#$hex6b;color:#$hex6">($sl) </span>""", )
        write(io, """<span style="font-weight:bold">""")
        write(io, """<span style="background:#$hex6;color:#$hex6b"> LARGE</span>""")
        write(io, """<span style="background:#$hex6b;color:#$hex6">($ll) </span>""", )
        write(io, "</span></span><br>")
    end
    write(io, "</pre>")
end

end # module

```

## YAML

```yaml
name: Documentation

on:
  push:
    branches:
      - master
    tags: '*'
  pull_request:

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: julia-actions/setup-julia@latest
        with:
          version: '1'
      - name: Install dependencies
        run: julia --project=documenter.jl/ -e 'using Pkg; Pkg.instantiate()'
      - name: Build and deploy
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }} # For authentication with GitHub Actions token
          DOCUMENTER_KEY: ${{ secrets.DOCUMENTER_KEY }} # For authentication with SSH deploy key
        run: julia --project=documenter.jl/ documenter.jl/make.jl
```

## JSON


## HTML


## CSS
```css
svg.swatches g rect.choosed {
    stroke-width: 1.5;
    stroke: #aaa;
    animation: stroke-blink 1s infinite alternate;
}

@keyframes stroke-blink {
    0% {
        stroke-opacity: 0;
    }
    50% {
        stroke-opacity: 0;
    }
    100% {
        stroke-opacity: 1;
    }
}
```
