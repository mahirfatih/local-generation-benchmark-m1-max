# Image generation — seconds per image

**Date:** 2026-11-21. One `mflux-generate-*` process per prompt, run through [mflux](https://github.com/filipstrand/mflux), which is separate from the oMLX text server. Time is end-to-end wall clock, **model load included** (the CLI is one-shot).

| Model (profile) | Licence | Image | s/img | s/step | Size | OK |
|---|---|---:|---:|---:|---|:---:|
| `Runpod/FLUX.2-klein-4B-mflux-4bit` (klein-q4) | apache-2.0 | `photoreal-market` | 22.78 | 5.69 | 1024×1024, 2.0 MB | ✅ |
| `Runpod/FLUX.2-klein-4B-mflux-4bit` (klein-q4) | apache-2.0 | `portrait-hands` | 24.44 | 6.11 | 1024×1024, 1.8 MB | ✅ |
| `Runpod/FLUX.2-klein-4B-mflux-4bit` (klein-q4) | apache-2.0 | `text-poster` | 22.68 | 5.67 | 1024×1024, 0.3 MB | ✅ |
| `Runpod/FLUX.2-klein-4B-mflux-4bit` (klein-q4) | apache-2.0 | `composition-stilllife` | 22.58 | 5.64 | 1024×1024, 1.6 MB | ✅ |
| `Runpod/FLUX.2-klein-4B-mflux-4bit` (klein-q4) | apache-2.0 | `stylised-risograph` | 22.81 | 5.7 | 1024×1024, 2.2 MB | ✅ |
| `Runpod/FLUX.2-klein-4B-mflux-4bit` (klein-q4) | apache-2.0 | `product-headphones` | 22.87 | 5.72 | 1024×1024, 1.0 MB | ✅ |
| `Runpod/FLUX.2-klein-4B-mflux-4bit` (klein-q4) | apache-2.0 | `photoreal-architecture` | 22.78 | 5.7 | 1024×1024, 1.8 MB | ✅ |
| `Runpod/FLUX.2-klein-4B-mflux-4bit` (klein-q4) | apache-2.0 | `text-signage` | 22.63 | 5.66 | 1024×1024, 1.7 MB | ✅ |

_s/img is what a person waits for one finished image on this machine. Because each CLI call reloads the model, it is a cold number; the steady-state per-step cost is the `s/step` column._
