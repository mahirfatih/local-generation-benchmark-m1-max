# Image generation — seconds per image

**Date:** 2026-11-21. One `mflux-generate-*` process per prompt, run through [mflux](https://github.com/filipstrand/mflux), which is separate from the oMLX text server. Time is end-to-end wall clock, **model load included** (the CLI is one-shot).

| Model (profile) | Licence | Image | s/img | s/step | Size | OK |
|---|---|---:|---:|---:|---|:---:|
| `mflux-community/anima-turbo-mflux-q8` (anima-turbo-q8) | circlestone-labs-non-commercial-license | `photoreal-market` | 37.45 | 4.68 | 1024×1024, 1.7 MB | ✅ |
| `mflux-community/anima-turbo-mflux-q8` (anima-turbo-q8) | circlestone-labs-non-commercial-license | `portrait-hands` | 35.93 | 4.49 | 1024×1024, 1.7 MB | ✅ |
| `mflux-community/anima-turbo-mflux-q8` (anima-turbo-q8) | circlestone-labs-non-commercial-license | `text-poster` | 36.97 | 4.62 | 1024×1024, 0.2 MB | ✅ |
| `mflux-community/anima-turbo-mflux-q8` (anima-turbo-q8) | circlestone-labs-non-commercial-license | `composition-stilllife` | 36.99 | 4.62 | 1024×1024, 1.5 MB | ✅ |
| `mflux-community/anima-turbo-mflux-q8` (anima-turbo-q8) | circlestone-labs-non-commercial-license | `stylised-risograph` | 36.19 | 4.52 | 1024×1024, 1.7 MB | ✅ |
| `mflux-community/anima-turbo-mflux-q8` (anima-turbo-q8) | circlestone-labs-non-commercial-license | `product-headphones` | 36.4 | 4.55 | 1024×1024, 0.9 MB | ✅ |
| `mflux-community/anima-turbo-mflux-q8` (anima-turbo-q8) | circlestone-labs-non-commercial-license | `photoreal-architecture` | 36.56 | 4.57 | 1024×1024, 1.5 MB | ✅ |
| `mflux-community/anima-turbo-mflux-q8` (anima-turbo-q8) | circlestone-labs-non-commercial-license | `text-signage` | 35.89 | 4.49 | 1024×1024, 1.5 MB | ✅ |

_s/img is what a person waits for one finished image on this machine. Because each CLI call reloads the model, it is a cold number; the steady-state per-step cost is the `s/step` column._
