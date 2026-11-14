# Image generation — seconds per image

**Date:** 2026-11-14. One `mflux-generate-*` process per prompt, run through [mflux](https://github.com/filipstrand/mflux), which is separate from the oMLX text server. Time is end-to-end wall clock, **model load included** (the CLI is one-shot).

| Model (profile) | Licence | Image | s/img | s/step | Size | OK |
|---|---|---:|---:|---:|---|:---:|
| `mflux-community/z-image-turbo-mflux-q4` (z-image-turbo-q4) | apache-2.0 | `photoreal-market` | 95.63 | 10.63 | 1024×1024, 1.5 MB | ✅ |
| `mflux-community/z-image-turbo-mflux-q4` (z-image-turbo-q4) | apache-2.0 | `portrait-hands` | 95.13 | 10.57 | 1024×1024, 1.4 MB | ✅ |
| `mflux-community/z-image-turbo-mflux-q4` (z-image-turbo-q4) | apache-2.0 | `text-poster` | 95.25 | 10.58 | 1024×1024, 0.5 MB | ✅ |
| `mflux-community/z-image-turbo-mflux-q4` (z-image-turbo-q4) | apache-2.0 | `composition-stilllife` | 95.74 | 10.64 | 1024×1024, 1.3 MB | ✅ |
| `mflux-community/z-image-turbo-mflux-q4` (z-image-turbo-q4) | apache-2.0 | `stylised-risograph` | 95.33 | 10.59 | 1024×1024, 1.6 MB | ✅ |
| `mflux-community/z-image-turbo-mflux-q4` (z-image-turbo-q4) | apache-2.0 | `product-headphones` | 96.4 | 10.71 | 1024×1024, 0.9 MB | ✅ |
| `mflux-community/z-image-turbo-mflux-q4` (z-image-turbo-q4) | apache-2.0 | `photoreal-architecture` | 96.82 | 10.76 | 1024×1024, 1.1 MB | ✅ |
| `mflux-community/z-image-turbo-mflux-q4` (z-image-turbo-q4) | apache-2.0 | `text-signage` | 95.98 | 10.66 | 1024×1024, 1.0 MB | ✅ |

_s/img is what a person waits for one finished image on this machine. Because each CLI call reloads the model, it is a cold number; the steady-state per-step cost is the `s/step` column._

## The images themselves

Same eight prompts as the `klein-q8` and `flux3-klein-q8` runs, the same one-shot
CLI, but Z-Image Turbo — a distilled 6B single-stream DiT at 9 steps, Apache-2.0.
At **95.8 s/img** it lands between the two FLUX models: ~4.3× slower than the
4-step `klein-q8` (22.5 s) and ~1.9× faster than the 16-step `flux3-klein-q8`
(180.6 s). Time is flat across prompts (95.1–96.8 s), so the figure is stable, not
a lucky first draw.

### `photoreal-market` — photoreal

> Photorealistic rainy-night street market in Istanbul, wet cobblestones reflecting red and yellow awnings, steam rising from a food stall, shallow depth of field, shot on 35mm, natural colour grading.

![Rainy-night street market, Z-Image Turbo](images/z-image-turbo-q4--photoreal-market.png)

### `portrait-hands` — portrait

> Close-up portrait of an older fisherman mending a net, weathered hands clearly visible with all fingers, warm low sun from the left, detailed skin and rope texture, neutral background.

![Close-up portrait of a fisherman mending a net, Z-Image Turbo](images/z-image-turbo-q4--portrait-hands.png)

### `text-poster` — text rendering

> Minimalist swiss-style poster with the exact headline "LOCAL FIRST" in bold black Helvetica on an off-white background, a single thin red horizontal rule below the text, generous margins, flat vector look.

![Minimalist poster reading LOCAL FIRST, Z-Image Turbo](images/z-image-turbo-q4--text-poster.png)

### `composition-stilllife` — composition

> Overhead still life on a dark oak table: exactly three objects — a white ceramic mug, a brass pocket watch, and a ripe pomegranate cut in half. Warm side light, soft shadows, each object distinct and fully in frame.

![Overhead still life of three objects, Z-Image Turbo](images/z-image-turbo-q4--composition-stilllife.png)

### `stylised-risograph` — stylised

> Two-colour risograph print of a fox sitting in tall grass at dusk, visible paper grain and slight misregistration, limited palette of teal and warm orange, bold shapes, no outlines.

![Two-colour risograph fox, Z-Image Turbo](images/z-image-turbo-q4--stylised-risograph.png)

### `product-headphones` — product shot

> Studio product shot of matte-black over-ear headphones on a seamless light-grey backdrop, three-point softbox lighting, subtle reflection on the surface below, crisp edges, commercial catalogue style.

![Studio product shot of headphones, Z-Image Turbo](images/z-image-turbo-q4--product-headphones.png)

### `photoreal-architecture` — photoreal

> Wide architectural photograph of a concrete brutalist library at golden hour, long shadows across a plaza, a single figure walking, tilt-shift correction so verticals are straight, high dynamic range.

![Brutalist library at golden hour, Z-Image Turbo](images/z-image-turbo-q4--photoreal-architecture.png)

### `text-signage` — text rendering

> Photograph of a small neighbourhood coffee shop window at night with the hand-painted sign reading "OPEN" in warm neon-green light, condensation on the glass, brass fittings, cinematic bokeh of the street behind.

![Coffee shop window with a legible neon-green OPEN sign, Z-Image Turbo](images/z-image-turbo-q4--text-signage.png)
