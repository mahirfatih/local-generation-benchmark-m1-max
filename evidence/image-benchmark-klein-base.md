# Image generation — seconds per image

**Date:** 2026-11-21. One `mflux-generate-*` process per prompt, run through [mflux](https://github.com/filipstrand/mflux), which is separate from the oMLX text server. Time is end-to-end wall clock, **model load included** (the CLI is one-shot).

| Model (profile) | Licence | Image | s/img | s/step | Size | OK |
|---|---|---:|---:|---:|---|:---:|
| `mflux-community/flux-2-klein-base-4b-mflux-q8` (klein-base-q8) | apache-2.0 | `photoreal-market` | 101.27 | 5.06 | 1024×1024, 1.9 MB | ✅ |
| `mflux-community/flux-2-klein-base-4b-mflux-q8` (klein-base-q8) | apache-2.0 | `portrait-hands` | 107.76 | 5.39 | 1024×1024, 1.5 MB | ✅ |
| `mflux-community/flux-2-klein-base-4b-mflux-q8` (klein-base-q8) | apache-2.0 | `text-poster` | 95.27 | 4.76 | 1024×1024, 0.3 MB | ✅ |
| `mflux-community/flux-2-klein-base-4b-mflux-q8` (klein-base-q8) | apache-2.0 | `composition-stilllife` | 94.96 | 4.75 | 1024×1024, 1.8 MB | ✅ |
| `mflux-community/flux-2-klein-base-4b-mflux-q8` (klein-base-q8) | apache-2.0 | `stylised-risograph` | 95.27 | 4.76 | 1024×1024, 2.3 MB | ✅ |
| `mflux-community/flux-2-klein-base-4b-mflux-q8` (klein-base-q8) | apache-2.0 | `product-headphones` | 94.99 | 4.75 | 1024×1024, 1.1 MB | ✅ |
| `mflux-community/flux-2-klein-base-4b-mflux-q8` (klein-base-q8) | apache-2.0 | `photoreal-architecture` | 95.46 | 4.77 | 1024×1024, 1.9 MB | ✅ |
| `mflux-community/flux-2-klein-base-4b-mflux-q8` (klein-base-q8) | apache-2.0 | `text-signage` | 95.78 | 4.79 | 1024×1024, 1.4 MB | ✅ |

_s/img is what a person waits for one finished image on this machine. Because each CLI call reloads the model, it is a cold number; the steady-state per-step cost is the `s/step` column._
