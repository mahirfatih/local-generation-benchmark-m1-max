# Model map

One page that answers a single question: **which local generation model for which job**, and
what it cost in seconds on this machine.

- [`model-map-light.png`](model-map-light.png) — the poster, light theme, 2000 px wide — the default
- [`model-map-dark.png`](model-map-dark.png) — the same poster, dark theme
- [`model-map.html`](model-map.html) — the interactive original; the theme button switches
  between the two without a reload

## What it shows

Two bands, because the two units are not comparable, and each band fastest first.
Images: seconds per 1024×1024 image
over mflux and mlx-gen — 22.5 s for FLUX.2 klein (q8), 23.8 s for its 4-bit sibling
(smallest on disk
but not the fastest), 95.8 s for Z-Image Turbo, 124.9 s for Qwen Image and 180.6 s
for FLUX 3, an
8× spread. Video:
seconds per clip over VideoX-Fun-mlx and mlx-gen — 247.7 / 255.6 / 262.1 s, which looks like
a tie until you count frames: 5 frames against 25, so 49.5–52.4 s per frame against 10.2 s.

Every image row is 1024×1024, so the image band compares like with like. ERNIE and
Bonsai are drawn without a bar: Bonsai has never produced a frame, and ERNIE has a
smoke run rather than a benchmark row.

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
