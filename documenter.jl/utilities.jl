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

struct ColorOrbits
    id::String
    colors1::Vector{RGB}
    colors2::Vector{RGB}
    bg::RGB
end

Base.showable(::MIME"image/svg+xml", ::ColorOrbits) = true

function Base.show(io::IO, ::MIME"image/svg+xml", co::ColorOrbits)
    write(io, """<svg id="$(co.id)" class="ColorOrbits" xmlns="http://www.w3.org/2000/svg"
                      width="60mm" height="60mm" viewBox="-60,-60,120,120"
                      fill="none" stroke="none">""")
    write(io, """<rect fill="#$(hex(co.bg))" x="-60" y="-60" width="120" height="120" />""")
    colors = vcat(co.colors1, co.colors2)
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
        c = min(lch.c / 130, 1.0)
        y, x = (lch.l * 0.6) .* sincosd(-lch.h)
        hex6 = hex(rgb)
        if i <= length(co.colors1)
            write(io, """<rect x="$(x-3)" y="$(y-3)" width="6" height="6" rx="0.5" fill="#$hex6" />""")
        else
            write(io, """<circle cx="$x" cy="$y" r="3" fill="#$hex6" />""")
        end
    end
    write(io, "</svg>")
end

struct VariationSwatches
    id::String
    base::RGB
    bg::RGB
    choosed::Tuple{Int, Int}
    VariationSwatches(id, base, bg, choosed=(0, 0)) = new(id, base, bg, choosed)
end

Base.showable(::MIME"image/svg+xml", ::VariationSwatches) = true

function Base.show(io::IO, ::MIME"image/svg+xml", sw::VariationSwatches)
    write(io, """<svg id="$(sw.id)" class="swatches" xmlns="http://www.w3.org/2000/svg"
                      width="50mm" height="50mm" viewBox="0,0,120,120" >""")
    write(io, """<rect fill="#$(hex(sw.bg))" width="120" height="120" />""")
    write(io, """<path fill="#aaa" d="m 13,54 l -5,-3 v 6 z" />""")
    write(io, """<path fill="#aaa" d="m 60,8 l -3,-5 h 6 z" />""")
    lch = rgb_to_lch(sw.base)
    ls = range(lch.l + 10, lch.l - 10, length = 9)
    cs = range(lch.c - 20, lch.c + 20, length = 9)
    for i = 1:9, j = 1:9
        y, x = (i - 1) * 10 + 10, (j - 1) * 10 + 16
        lch_o = LCHab(ls[i], cs[j], lch.h)
        rgb = lch_to_rgb8(lch_o)
        lch_b = rgb_to_lch(rgb)
        if isapprox(lch_o, lch_b, atol = 1.5)
            hex6 = hex(rgb)
            sl, sc, sh = round3p1.((lch_b.l, lch_b.c, lch_b.h))
            cont = contrast(rgb, sw.bg)
            scont = round3p1(cont)
            level = contrast_level(cont)
            choosed = sw.choosed == (5 - i, j - 5) ? "class=\"choosed\"" : ""
            write(io,
                """
                <g fill="#$hex6">
                  <rect x="$x" y="$y" width="8" height="8" $choosed/>
                  <text x="2" y="107" xml:space="preserve">LCHab($sl,$sc,$sh)</text>
                  <text x="2" y="117" xml:space="preserve">#$hex6  $scont:1 ($level)</text>
                </g>
                """)
        end
    end
    write(io, """</svg>""")
end


struct TerminalPreview end

Base.showable(::MIME"text/html", ::TerminalPreview) = true

function Base.show(io::IO, ::MIME"text/html", ::TerminalPreview)
    write(io, """<pre><code class="ansi nohighlight">""")
    for i = 0:15
        idx = lpad(string(i),3)
        fg = i < 8 ? 30 + i : 90 - 8 + i
        bg = fg + 10
        write(io, """<span class="sgr$fg"><span class="sgr$bg">  </span>$idx  </span>""")
        i == 7 && write(io, "\n")
    end
    write(io, """</code></pre>""")
end

end #module
