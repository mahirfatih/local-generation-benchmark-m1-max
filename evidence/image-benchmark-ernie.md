# Image generation — seconds per image

**Date:** 2026-11-21. One `mflux-generate-*` process per prompt, run through [mflux](https://github.com/filipstrand/mflux), which is separate from the oMLX text server. Time is end-to-end wall clock, **model load included** (the CLI is one-shot).

| Model (profile) | Licence | Image | s/img | s/step | Size | OK |
|---|---|---:|---:|---:|---|:---:|
| `AbstractFramework/ernie-image-turbo-8bit` (ernie-image-turbo-q8) | apache-2.0 | `photoreal-market` | 123.33 | 15.42 | 1024×1024, 1.9 MB | ✅ |
| `AbstractFramework/ernie-image-turbo-8bit` (ernie-image-turbo-q8) | apache-2.0 | `portrait-hands` | 123.18 | 15.4 | 1024×1024, 1.8 MB | ✅ |
| `AbstractFramework/ernie-image-turbo-8bit` (ernie-image-turbo-q8) | apache-2.0 | `text-poster` | 123.51 | 15.44 | 1024×1024, 0.8 MB | ✅ |
| `AbstractFramework/ernie-image-turbo-8bit` (ernie-image-turbo-q8) | apache-2.0 | `composition-stilllife` | 123.2 | 15.4 | 1024×1024, 1.7 MB | ✅ |
| `AbstractFramework/ernie-image-turbo-8bit` (ernie-image-turbo-q8) | apache-2.0 | `stylised-risograph` | 123.4 | 15.42 | 1024×1024, 2.2 MB | ✅ |
| `AbstractFramework/ernie-image-turbo-8bit` (ernie-image-turbo-q8) | apache-2.0 | `product-headphones` | 123.24 | 15.4 | 1024×1024, 1.2 MB | ✅ |
| `AbstractFramework/ernie-image-turbo-8bit` (ernie-image-turbo-q8) | apache-2.0 | `photoreal-architecture` | 123.91 | 15.49 | 1024×1024, 1.5 MB | ✅ |
| `AbstractFramework/ernie-image-turbo-8bit` (ernie-image-turbo-q8) | apache-2.0 | `text-signage` | 123.74 | 15.47 | 1024×1024, 1.8 MB | ✅ |

_s/img is what a person waits for one finished image on this machine. Because each CLI call reloads the model, it is a cold number; the steady-state per-step cost is the `s/step` column._
