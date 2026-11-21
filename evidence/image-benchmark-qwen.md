# Image generation — seconds per image

**Date:** 2026-11-21. One `mflux-generate-*` process per prompt, run through [mflux](https://github.com/filipstrand/mflux), which is separate from the oMLX text server. Time is end-to-end wall clock, **model load included** (the CLI is one-shot).

| Model (profile) | Licence | Image | s/img | s/step | Size | OK |
|---|---|---:|---:|---:|---|:---:|
| `AbstractFramework/qwen-image-4bit` (qwen-image-4bit) | apache-2.0 | `photoreal-market` | 29.46 | 3.27 | 512×512, 0.4 MB | ✅ |
| `AbstractFramework/qwen-image-4bit` (qwen-image-4bit) | apache-2.0 | `portrait-hands` | 30.62 | 3.4 | 512×512, 0.3 MB | ✅ |
| `AbstractFramework/qwen-image-4bit` (qwen-image-4bit) | apache-2.0 | `text-poster` | 30.57 | 3.4 | 512×512, 0.3 MB | ✅ |
| `AbstractFramework/qwen-image-4bit` (qwen-image-4bit) | apache-2.0 | `composition-stilllife` | 30.67 | 3.41 | 512×512, 0.3 MB | ✅ |
| `AbstractFramework/qwen-image-4bit` (qwen-image-4bit) | apache-2.0 | `stylised-risograph` | 30.48 | 3.39 | 512×512, 0.4 MB | ✅ |
| `AbstractFramework/qwen-image-4bit` (qwen-image-4bit) | apache-2.0 | `product-headphones` | 30.33 | 3.37 | 512×512, 0.2 MB | ✅ |
| `AbstractFramework/qwen-image-4bit` (qwen-image-4bit) | apache-2.0 | `photoreal-architecture` | 30.36 | 3.37 | 512×512, 0.3 MB | ✅ |
| `AbstractFramework/qwen-image-4bit` (qwen-image-4bit) | apache-2.0 | `text-signage` | 30.69 | 3.41 | 512×512, 0.3 MB | ✅ |

_s/img is what a person waits for one finished image on this machine. Because each CLI call reloads the model, it is a cold number; the steady-state per-step cost is the `s/step` column._
