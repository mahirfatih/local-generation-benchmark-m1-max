# Image generation — seconds per image

**Date:** 2026-11-21. One `mflux-generate-*` process per prompt, run through [mflux](https://github.com/filipstrand/mflux), which is separate from the oMLX text server. Time is end-to-end wall clock, **model load included** (the CLI is one-shot).

| Model (profile) | Licence | Image | s/img | s/step | Size | OK |
|---|---|---:|---:|---:|---|:---:|
| `AbstractFramework/qwen-image-4bit` (qwen-image-4bit) | apache-2.0 | `photoreal-market` | 117.33 | 13.04 | 1024×1024, 1.4 MB | ✅ |
| `AbstractFramework/qwen-image-4bit` (qwen-image-4bit) | apache-2.0 | `portrait-hands` | 131.69 | 14.63 | 1024×1024, 1.1 MB | ✅ |
| `AbstractFramework/qwen-image-4bit` (qwen-image-4bit) | apache-2.0 | `text-poster` | 116.51 | 12.95 | 1024×1024, 1.0 MB | ✅ |
| `AbstractFramework/qwen-image-4bit` (qwen-image-4bit) | apache-2.0 | `composition-stilllife` | 116.98 | 13.0 | 1024×1024, 0.9 MB | ✅ |
| `AbstractFramework/qwen-image-4bit` (qwen-image-4bit) | apache-2.0 | `stylised-risograph` | 131.28 | 14.59 | 1024×1024, 1.6 MB | ✅ |
| `AbstractFramework/qwen-image-4bit` (qwen-image-4bit) | apache-2.0 | `product-headphones` | 131.04 | 14.56 | 1024×1024, 0.8 MB | ✅ |
| `AbstractFramework/qwen-image-4bit` (qwen-image-4bit) | apache-2.0 | `photoreal-architecture` | 130.32 | 14.48 | 1024×1024, 1.0 MB | ✅ |
| `AbstractFramework/qwen-image-4bit` (qwen-image-4bit) | apache-2.0 | `text-signage` | 116.82 | 12.98 | 1024×1024, 1.0 MB | ✅ |

_s/img is what a person waits for one finished image on this machine. Because each CLI call reloads the model, it is a cold number; the steady-state per-step cost is the `s/step` column._
