# Image generation — seconds per image

**Date:** 2026-11-27. One `mflux-generate-*` process per prompt, run through [mflux](https://github.com/filipstrand/mflux), which is separate from the oMLX text server. Time is end-to-end wall clock, **model load included** (the CLI is one-shot).

| Model (profile) | Licence | Image | s/img | s/step | Size | OK |
|---|---|---:|---:|---:|---|:---:|
| `mflux-community/boogu-image-turbo-mflux-q8` (boogu-turbo-q8) | apache-2.0 | `photoreal-market` | 144.26 | 18.03 | 1024×1024, 1.7 MB | ✅ |
| `mflux-community/boogu-image-turbo-mflux-q8` (boogu-turbo-q8) | apache-2.0 | `portrait-hands` | 151.79 | 18.97 | 1024×1024, 1.4 MB | ✅ |
| `mflux-community/boogu-image-turbo-mflux-q8` (boogu-turbo-q8) | apache-2.0 | `text-poster` | 153.08 | 19.13 | 1024×1024, 1.1 MB | ✅ |
| `mflux-community/boogu-image-turbo-mflux-q8` (boogu-turbo-q8) | apache-2.0 | `composition-stilllife` | 158.94 | 19.87 | 1024×1024, 1.6 MB | ✅ |
| `mflux-community/boogu-image-turbo-mflux-q8` (boogu-turbo-q8) | apache-2.0 | `stylised-risograph` | 164.58 | 20.57 | 1024×1024, 2.2 MB | ✅ |
| `mflux-community/boogu-image-turbo-mflux-q8` (boogu-turbo-q8) | apache-2.0 | `product-headphones` | 161.33 | 20.17 | 1024×1024, 1.1 MB | ✅ |
| `mflux-community/boogu-image-turbo-mflux-q8` (boogu-turbo-q8) | apache-2.0 | `photoreal-architecture` | 169.74 | 21.22 | 1024×1024, 1.1 MB | ✅ |
| `mflux-community/boogu-image-turbo-mflux-q8` (boogu-turbo-q8) | apache-2.0 | `text-signage` | 166.44 | 20.8 | 1024×1024, 1.4 MB | ✅ |

_s/img is what a person waits for one finished image on this machine. Because each CLI call reloads the model, it is a cold number; the steady-state per-step cost is the `s/step` column._
