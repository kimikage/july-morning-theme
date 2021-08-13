module Utilities

using Printf
using Colors
using FixedPointNumbers

export lch_to_rgb, lch_to_rgb8, adjust_color_lch, lch_lighten, lch_darken, adjust_color, get_hsl_adjuster
export ContrastChecker, ColorOrbits, VariationSwatches
export LighterVariationSwatches, DarkerVariationSwatches
export TerminalPreview


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

rgb_to_lch(c::LCHab) = c
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
    (l1 + 0.05) / (l2 + 0.05)
end

function contrast_level(cont, islarge = false)
    if islarge
        cont < 3.0 ? "fail" : cont < 4.5 ? "AA" : "AAA"
    else
        cont < 4.5 ? "fail" : cont < 7.0 ? "AA" : "AAA"
    end
end

adjust_color_lch(c::Color, t::Tuple) = adjust_color_lch(rgb_to_lch(c), t...)

function adjust_color_lch(c::LCHab, dl::Real, dc = 0, dh = 0)
    lch_to_rgb8(LCHab(c.l + dl * 2.5, c.c + dc * 2.5, c.h + dh))
end

adjust_color(c, t::Tuple) = adjust_color(c, t...)

"""
    adjust_color(c::Union{RGB, HSL}, dh::Real, ds = 0, dl = 0)

Adjust the color `c` in HSL space.

# Examples
```jldoctest
julia> adjust_color(HSL(50, 0.6, 0.7), 10, -10, 5)
HSL{Float64}(60, 0.5, 0.75)
```
"""
function adjust_color(c::Union{RGB, HSL}, dh::Real, ds = 0, dl = 0)
    hsl = HSL(c)
    h = normalize_hue(hsl.h + dh)
    s = clamp(hsl.s + ds * 0.01, 0.0, 1.0)
    l = clamp(hsl.l + dl * 0.01, 0.0, 1.0)
    convert(RGB{N0f8}, HSL(h, s, l))
end

function get_hsl_adjuster(c::RGB, dl)
    hsl0 = HSL(c)
    lch0 = rgb_to_lch(c)
    lch1 = rgb_to_lch(lch_to_rgb(LCHab(lch0.l + dl, lch0.c - 0.4 * abs(dl), lch0.h)))
    lch = LCHab(lch1.l, min(lch1.c, lch0.c), lch0.h)
    hsl = HSL(lch_to_rgb(lch))
    dh0 = round(Int, mod(hsl.h - hsl0.h - 180.0, 360) - 180)
    ds0 = round(Int, 100.0 * (hsl.s - hsl0.s))
    dl0 = round(Int, 100.0 * (hsl.l - hsl0.l))
    dh0, ds0, dl0
end

lch_lighten(c::RGB, a) = adjust_color(c, get_hsl_adjuster(c, a))
lch_darken(c::RGB, a) = adjust_color(c, get_hsl_adjuster(c, -a))

struct ContrastChecker{T}
    colors::T
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

struct ColorOrbits{T1, T2}
    id::String
    colors1::T1
    colors2::T2
    bg::RGB
end

Base.showable(::MIME"text/html", ::ColorOrbits) = true

function Base.show(io::IO, ::MIME"text/html", co::ColorOrbits)
    write(io, "<html><body>")
    write(io, """<svg id="$(co.id)" class="ColorOrbits" xmlns="http://www.w3.org/2000/svg"
                      width="60mm" height="60mm" viewBox="-60,-60,120,120"
                      fill="none" stroke="none">""")
    write(io, """<rect fill="#$(hex(co.bg))" x="-60" y="-60" width="120" height="120" />""")
    colors = (co.colors1..., co.colors2...)
    sq = !occursin("both", co.id)
    for rgb in colors
        lch = rgb_to_lch(rgb)
        l = lch.l * 0.6
        c = min(lch.c / 130, 1.0)
        write(io, """<circle r="$l" stroke-opacity="$c" stroke="#$(hex(rgb))" />""")
        y, x = 58 .* sincosd(-lch.h)
        write(io, """<path d="m 0,0 l $x, $y" stroke-opacity="$c" stroke="#aaa" />""")
    end
    for (i, rgb) in enumerate(colors)
        lch = rgb_to_lch(rgb)
        y, x = (lch.l * 0.6) .* sincosd(-lch.h)
        hex6 = hex(rgb)
        if sq && i <= length(co.colors1)
            write(io, """<rect x="$(x-3)" y="$(y-3)" width="6" height="6" stroke-width="1" stroke="#$hex6" />""")
        else
            write(io, """<circle cx="$x" cy="$y" r="3" fill="#$hex6" />""")
        end
    end
    write(io, "</svg>")
    write(io, "</body></html>")
end

struct VariationSwatches
    base::RGB{N0f8}
    bg::RGB{N0f8}
    choosed::Tuple{Int, Int}
end

Base.showable(::MIME"text/html", ::VariationSwatches) = true

function Base.show(io::IO, ::MIME"text/html", sw::VariationSwatches)
    bg = LCHab(sw.bg)
    bw = bg.l < 70 ? RGB(1, 1, 1) : RGB(0, 0, 0)
    text = hex(bw)
    write(io, "<html><body>")
    write(io, """<svg class="swatches" xmlns="http://www.w3.org/2000y/svg"
                      width="50mm" height="50mm" viewBox="0,0,120,120" fill="#$text">""")
    write(io, """<rect fill="#$(hex(sw.bg))" width="120" height="120" />""")
    write(io, """<path fill="#aaa" d="m 13,54 l -5,-3 v 6 z" />""")
    write(io, """<path fill="#aaa" d="m 60,8 l -3,-5 h 6 z" />""")
    lch = rgb_to_lch(sw.base)
    ls = range(lch.l + 10, lch.l - 10, length = 9)
    cs = range(lch.c - 10, lch.c + 10, length = 9)
    for i = 1:9, j = 1:9
        y, x = (i - 1) * 10 + 10, (j - 1) * 10 + 16
        lch_o = LCHab(ls[i], cs[j], lch.h)
        rgb = lch_to_rgb8(lch_o)
        lch_b = rgb_to_lch(rgb)
        isapprox(lch_o, lch_b, atol = 2.0) || continue
        hex6 = hex(rgb)
        sl, sc, sh = round3p1.((lch_b.l, lch_b.c, lch_b.h))
        cont = contrast(rgb, bg.c < 20 ? sw.bg : bw)
        scont = round3p1(cont)
        lv = contrast_level(cont)
        choosed = sw.choosed == (5 - i, j - 5) ? "class=\"choosed\"" : ""
        write(io,
            """
            <g>
                <rect x="$x" y="$y" width="8" height="8" fill="#$hex6" $choosed/>
                <text x="2" y="107" xml:space="preserve">LCHab($sl,$sc,$sh)</text>
                <text x="2" y="117" xml:space="preserve">#$hex6  $scont : 1 ($lv)</text>
            </g>
            """)
    end
    write(io, "</svg>")
    write(io, "</body></html>")
end

struct LightnessVariationSwatches{M}
    base::RGB{N0f8}
    bg::RGB{N0f8}
    choosed::Int
end
const LighterVariationSwatches = LightnessVariationSwatches{:L}
const DarkerVariationSwatches = LightnessVariationSwatches{:D}


Base.showable(::MIME"text/html", ::LightnessVariationSwatches) = true

function Base.show(io::IO, ::MIME"text/html", sw::LightnessVariationSwatches{M}) where M
    bg = LCHab(sw.bg)
    bw = (bg.c < 20 && bg.l < 70) || (bg.c >= 20 && M === :D) ? RGB(1, 1, 1) : RGB(0, 0, 0)
    text = hex(bw)
    hsl0 = HSL(sw.base)
    write(io, "<html><body>")
    write(io, """<svg class="swatches" xmlns="http://www.w3.org/2000y/svg"
                      width="200mm" height="10mm" viewBox="0,0,480,24" fill="#$text">""")
    write(io, """<rect fill="#$(hex(sw.bg))" width="480" height="24" />""")
    write(io, """<path fill="#aaa" d="m 110,8 l -3,-5 h 6 z" />""")

    for dl = 0:36
        x = dl * 10 + 106
        dh0, ds0, dl0 = get_hsl_adjuster(sw.base, M === :D ? -dl : dl)
        rgb = adjust_color(hsl0, dh0, ds0, dl0)
        hex6 = hex(rgb)
        cont = contrast(rgb, bg.c < 20 ? sw.bg : bw)
        scont = round3p1(cont)
        lv = contrast_level(cont)
        choosed = sw.choosed == dl ? "class=\"choosed\"" : ""
        write(io,
            """
            <g>
                <rect x="$x" y="10" width="8" height="8" fill="#$hex6" $choosed/>
                <text x="2" y="12" xml:space="preserve">h:$dh0 s:$ds0% l:$dl0%</text>
                <text x="2" y="22" xml:space="preserve">$dl #$hex6  $scont : 1 ($lv)</text>
            </g>
            """)
    end
    write(io, "</svg>")
    write(io, "</body></html>")
end

struct TerminalPreview
    ansi_colors::Vector{RGB{N0f8}}
    bg::RGB{N0f8}
end

Base.showable(::MIME"text/html", ::TerminalPreview) = true

function Base.show(io::IO, ::MIME"text/html", t::TerminalPreview)
    m = XYZ(t.bg).y > 0.6 ? "light" : "dark"
    write(io, """<pre class="terminal-$m"><code class="hljs nohighlight ansi">""")
    names = ("black", "red", "green", "yellow", "blue", "magenta", "cyan", "white")
    for i = 0:15
        idx = lpad(string(i),3)
        fg = i < 8 ? 30 + i : 90 - 8 + i
        bg = fg + 10
        name = lpad(i < 8 ? names[i + 1] : "light_" * names[i - 7], 14)
        cont = contrast(t.ansi_colors[i + 1], t.bg)
        scont = round3p1(cont)
        level = contrast_level(cont)
        write(io, """<span class="sgr$fg"><span class="sgr$bg">  </span>$idx  $name""")
        write(io, """   Contrast$scont:1 ($level)</span>\n""")
    end
    write(io, """</code></pre>""")
end

end #module
