# Image generation — seconds per image

**Date:** 2026-11-17. One `mflux-generate-*` process per prompt, run through [mflux](https://github.com/filipstrand/mflux), which is separate from the oMLX text server. Time is end-to-end wall clock, **model load included** (the CLI is one-shot).

| Model (profile) | Licence | Image | s/img | s/step | Size | OK |
|---|---|---:|---:|---:|---|:---:|
| `Runpod/FLUX.2-klein-4B-mflux-4bit` (klein-q4) | apache-2.0 | `photoreal-market` | 23.83 | 5.96 | 1024×1024, 2.0 MB | ✅ |
| `Runpod/FLUX.2-klein-4B-mflux-4bit` (klein-q4) | apache-2.0 | `portrait-hands` | 25.16 | 6.29 | 1024×1024, 1.8 MB | ✅ |
| `Runpod/FLUX.2-klein-4B-mflux-4bit` (klein-q4) | apache-2.0 | `text-poster` | 25.13 | 6.28 | 1024×1024, 0.3 MB | ✅ |
| `Runpod/FLUX.2-klein-4B-mflux-4bit` (klein-q4) | apache-2.0 | `composition-stilllife` | 23.37 | 5.84 | 1024×1024, 1.6 MB | ✅ |
| `Runpod/FLUX.2-klein-4B-mflux-4bit` (klein-q4) | apache-2.0 | `stylised-risograph` | 22.77 | 5.69 | 1024×1024, 2.2 MB | ✅ |
| `Runpod/FLUX.2-klein-4B-mflux-4bit` (klein-q4) | apache-2.0 | `product-headphones` | 23.0 | 5.75 | 1024×1024, 1.0 MB | ✅ |
| `Runpod/FLUX.2-klein-4B-mflux-4bit` (klein-q4) | apache-2.0 | `photoreal-architecture` | 24.63 | 6.16 | 1024×1024, 1.8 MB | ✅ |
| `Runpod/FLUX.2-klein-4B-mflux-4bit` (klein-q4) | apache-2.0 | `text-signage` | 22.79 | 5.7 | 1024×1024, 1.7 MB | ✅ |

_s/img is what a person waits for one finished image on this machine. Because each CLI call reloads the model, it is a cold number; the steady-state per-step cost is the `s/step` column._

## The images themselves

Same eight prompts as the `klein-q8` and `flux3-klein-q8` runs and the same
one-shot CLI, but the **4-bit** klein weights rather than the 8-bit ones. At
**23.8 s/img** the q4 profile is **+1.3 s (+5.8 %)** slower than `klein-q8`
(22.5 s) on this machine, which is the opposite of the usual expectation that a
smaller quantisation runs faster.

The reason is that the two profiles are not the same pipeline. `--compute-precision`
is absent from this run: the q4 checkpoint ships its own `mlx-affine` 4-bit weights
for the text encoder, transformer and VAE, so the model is dequantised on the fly
rather than the compute being narrowed. The saving is in **disk and memory**
(4.3 GB on disk against the q8's larger footprint), not in the seconds an image
takes. The per-step cost is flat across prompts (5.69–6.29 s/step), so the figure
is stable, not a lucky first draw.

The first image (23.83 s) pays the one-time model load; the `s/img` figure is the
mean of the remaining seven, per the repository convention. The eight runs span
22.77–25.16 s.

### `photoreal-market` — photoreal

> Photorealistic rainy-night street market in Istanbul, wet cobblestones reflecting red and yellow awnings, steam rising from a food stall, shallow depth of field, shot on 35mm, natural colour grading.

### `portrait-hands` — portrait

> Close-up portrait of an older fisherman mending a net, weathered hands, cold overcast harbour light.

### `text-poster` — text

> Minimalist swiss-style poster with the exact headline "LOCAL FIRST" in heavy grotesque type on an off-white field.

### `composition-stilllife` — composition

> Overhead still life on a dark oak table: exactly three objects — a white ceramic bowl, a lemon, a brass key.

### `stylised-risograph` — stylised

> Two-colour risograph print of a fox sitting in tall grass at dusk, visible grain and misregistration.

### `product-headphones` — product

> Studio product shot of matte-black over-ear headphones on a seamless light-grey background, soft top light.

### `photoreal-architecture` — photoreal

> Wide architectural photograph of a concrete brutalist library at golden hour, long shadows, clear sky.

### `text-signage` — text

> Photograph of a small neighbourhood coffee shop window at night with the sign reading "OPEN" in warm backlit letters.

The PNGs are in [`evidence/images/`](images/) alongside the `klein-q8` run's; each
name carries the profile so the two sets cannot be confused.
