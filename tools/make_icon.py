#!/usr/bin/env python3
"""Draw the fiat santa launcher icon: the house silhouette in the app's
cranberry, a wrapped present on top in cream -- lid and box, the ribbon left
as a gap down the middle so the silhouette shows through, a bow of two loops
on the lid. Writes icons/harbour-fiatsanta.svg, the four PNG sizes Sailfish
wants and the copy the About page shows in the family list.

    pip install cairosvg
    python3 tools/make_icon.py

The silhouette is the family's: a square whose top-left and bottom-right
corners are replaced by the inscribed circle, drawn as circle, top-right
quadrant and bottom-left quadrant together."""
import os

ACCENT = "#AE3D59"
GLYPH = "#F2E9D8"
SILHOUETTE = ('<circle cx="128" cy="128" r="128"/>'
              '<rect x="128" y="0" width="128" height="128"/>'
              '<rect x="0" y="128" width="128" height="128"/>')

# Lid and box in two halves each, the gap between them the ribbon. The bow is
# two loops drawn as strokes, meeting at a knot on the ribbon.
GLYPH_SVG = f'''
<rect x="66" y="104" width="55" height="26" rx="3" fill="{GLYPH}"/>
<rect x="135" y="104" width="55" height="26" rx="3" fill="{GLYPH}"/>
<rect x="76" y="136" width="45" height="64" rx="2" fill="{GLYPH}"/>
<rect x="135" y="136" width="45" height="64" rx="2" fill="{GLYPH}"/>
<g fill="none" stroke="{GLYPH}" stroke-width="11" stroke-linejoin="round" stroke-linecap="round">
  <path d="M128 96 C 112 62, 80 66, 88 86 C 94 100, 116 98, 128 96 Z"/>
  <path d="M128 96 C 144 62, 176 66, 168 86 C 162 100, 140 98, 128 96 Z"/>
</g>
<circle cx="128" cy="96" r="9" fill="{GLYPH}"/>'''


def svg():
    return (f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 256 256" width="256" height="256">'
            f'<g fill="{ACCENT}">{SILHOUETTE}</g>{GLYPH_SVG}</svg>\n')


def main():
    root = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "icons")
    with open(os.path.join(root, "harbour-fiatsanta.svg"), "w") as f:
        f.write(svg())
    import cairosvg
    for size in (86, 108, 128, 172):
        d = os.path.join(root, f"{size}x{size}")
        os.makedirs(d, exist_ok=True)
        cairosvg.svg2png(bytestring=svg().encode(), write_to=os.path.join(d, "harbour-fiatsanta.png"),
                         output_width=size, output_height=size)
    family = os.path.join(root, "..", "qml", "pages", "images", "family", "harbour-fiatsanta.png")
    cairosvg.svg2png(bytestring=svg().encode(), write_to=family, output_width=172, output_height=172)
    print("icons written")


if __name__ == "__main__":
    main()
