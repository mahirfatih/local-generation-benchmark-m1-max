# Image generation — seconds per image

**Date:** 2026-11-27. One `mflux-generate-*` process per prompt, run through [mflux](https://github.com/filipstrand/mflux), which is separate from the oMLX text server. Time is end-to-end wall clock, **model load included** (the CLI is one-shot).

| Model (profile) | Licence | Image | s/img | s/step | Size | OK |
|---|---|---:|---:|---:|---|:---:|
| `mflux-community/iris-3b-turbo-mflux-q8` (iris-turbo-q8) | apache-2.0 | `photoreal-market` | 28.17 | 7.04 | 1024×1024, 1.8 MB | ✅ |
| `mflux-community/iris-3b-turbo-mflux-q8` (iris-turbo-q8) | apache-2.0 | `portrait-hands` | 23.79 | 5.95 | 1024×1024, 1.8 MB | ✅ |
| `mflux-community/iris-3b-turbo-mflux-q8` (iris-turbo-q8) | apache-2.0 | `text-poster` | 23.93 | 5.98 | 1024×1024, 1.4 MB | ✅ |
| `mflux-community/iris-3b-turbo-mflux-q8` (iris-turbo-q8) | apache-2.0 | `composition-stilllife` | 23.63 | 5.91 | 1024×1024, 1.6 MB | ✅ |
| `mflux-community/iris-3b-turbo-mflux-q8` (iris-turbo-q8) | apache-2.0 | `stylised-risograph` | 24.54 | 6.14 | 1024×1024, 1.9 MB | ✅ |
| `mflux-community/iris-3b-turbo-mflux-q8` (iris-turbo-q8) | apache-2.0 | `product-headphones` | 23.87 | 5.97 | 1024×1024, 1.5 MB | ✅ |
| `mflux-community/iris-3b-turbo-mflux-q8` (iris-turbo-q8) | apache-2.0 | `photoreal-architecture` | 24.88 | 6.22 | 1024×1024, 1.5 MB | ✅ |
| `mflux-community/iris-3b-turbo-mflux-q8` (iris-turbo-q8) | apache-2.0 | `text-signage` | 24.18 | 6.05 | 1024×1024, 1.6 MB | ✅ |

_s/img is what a person waits for one finished image on this machine. Because each CLI call reloads the model, it is a cold number; the steady-state per-step cost is the `s/step` column._
