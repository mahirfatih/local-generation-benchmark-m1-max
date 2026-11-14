# Model map

One page that answers a single question: **which local generation model for which job**, and
what it cost in seconds on this machine.

- [`model-map-dark.png`](model-map-dark.png) — the poster, dark theme, 2000 px wide
- [`model-map-light.png`](model-map-light.png) — the same poster, light theme
- [`model-map.html`](model-map.html) — the interactive original; the theme button switches
  between the two without a reload

## What it shows

Two bands, because the two units are not comparable. Images: seconds per 1024×1024 image
over mflux — 22.5 s for FLUX.2 klein, 95.8 s for Z-Image Turbo and 180.6 s for FLUX 3, an
8× spread. Video:
seconds per clip over VideoX-Fun-mlx and mlx-gen — 256.3 / 266.1 / 285.9 s, which looks like
a tie until you count frames: 5 frames against 25, so 51–53 s per frame against 11.4 s.

Licence differences are on the poster, not in a footnote: FLUX 3 carries a US$5M commercial
output cap, the CogVideoX quant says Apache-2.0 while the base model does not, and Wan2.2 is
the only video profile that is Apache-2.0 outright.

Every number comes from the tables in this repository; none of it is new measurement.

## Scope

Generation only. Text models run on oMLX, in a different repository, with a different unit.

## Regenerating the PNGs

```sh
python3 scripts/render/render-model-map.py docs/diagrams/model-map/model-map.html \
  docs/diagrams/model-map/model-map-dark.png dark
python3 scripts/render/render-model-map.py docs/diagrams/model-map/model-map.html \
  docs/diagrams/model-map/model-map-light.png light
```

The script needs Chromium at `/Applications/Chromium.app/Contents/MacOS/Chromium` and
nothing else — it renders at 2×, finds the last non-background row, and crops to it, so the
PNG never carries empty space and never cuts the footer. It deletes its own temporary files.

If a number in the poster changes, change it in the HTML, re-run both commands, and commit
the HTML and both PNGs together — `test/test.sh` fails if they disagree with the tables.
