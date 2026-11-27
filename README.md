# Local Image and Video Generation on an Apple M1 Max 64GB

[![Platform](https://img.shields.io/badge/platform-Apple%20Silicon%20(arm64)-000?logo=apple&logoColor=white)](#hardware--software)
[![mflux](https://img.shields.io/badge/image-mflux-blue)](https://github.com/filipstrand/mflux)
[![VideoX-Fun-mlx](https://img.shields.io/badge/video-VideoX--Fun--mlx-blue)](https://github.com/dgrauet/VideoX-Fun-mlx)
[![Outputs](https://img.shields.io/badge/outputs-64%20PNG%20%2B%2018%20clips-purple)](evidence/)
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)

| 🎯 Purpose | 🧩 Engines | 📊 Evidence | ⚖️ License |
| :---: | :---: | :---: | :---: |
| Measured local image/video generation on M1 Max | mflux · mlx-gen · VideoX-Fun-mlx | 80 PNG + 18 clips | MIT |

> **New here?** [Overview](#overview) · [What was measured](#what-was-measured) · [Images](#image-generation) · [Videos](#video-generation) · [Profiles](#profiles)

[English](README.md) · [Türkçe](README.tr.md)

---

<a id="contents"></a>

## 🧭 Contents

| # | Section | What it answers |
| :---: | :--- | :--- |
| 01 | [📖 Overview](#overview) | What this repo measures, and why |
| 02 | [💻 Hardware & Software](#hardware--software) | The exact machine, toolchain and versions |
| 03 | [🧩 Models](#models) | Weights, quantisation and licence on disk |
| 04 | [🗺️ Model map](#model-map) | Which model for which job, at a glance |
| 05 | [📊 What was measured](#what-was-measured) | Harnesses, gates and provenance |
| 06 | [🖼️ Image generation](#image-generation) | Every 1024×1024 image row |
| 07 | [🎬 Video generation](#video-generation) | Every clip row |
| 08 | [⚙️ Profiles](#profiles) | Settings behind each row |
| 09 | [🔁 Reproducing](#reproducing) | Commands to rerun a measurement |
| 10 | [📂 Repository structure](#repository-structure) | Where each file lives |
| 11 | [🔗 Links](#links) | Companion repo, tools and papers |
| 12 | [🤝 Contributing](#contributing) | How to add a profile |
| 13 | [⚠️ Notes & disclaimer](#notes--disclaimer) | What the numbers do and do not say |
| 14 | [📄 License](#license) | Distribution terms |

<details>
<summary>🔎 <b>Jump into the measurements</b></summary>

- [🧪 The environment](#the-environment)
- [🖼️ Image table](#image-generation)
- [🎬 Video table](#video-generation)
- [🧩 Model inventory](#models)
- [🗺️ Model map](#model-map)

</details>

---

<a id="overview"></a>

## 📖 Overview

**Local image and video generation on an Apple M1 Max — measured, and the output
committed so you can look at it.**

This is the generation half of a local-MLX benchmark. Text runs on
[oMLX](https://omlx.ai) and lives in the companion repository
[mahirfatih/omlx-m1-max-benchmark](https://github.com/mahirfatih/omlx-m1-max-benchmark);
here are the two layers oMLX cannot serve:

| Layer | Tool | Model | Time | Output |
| :--- | :--- | :--- | ---: | :--- |
| **Image** | [mflux](https://github.com/filipstrand/mflux) | FLUX.2 klein 4B (q4) | **23.0 s** | 1024×1024 PNG |
| Image | mflux | FLUX.2 klein 4B (q8) | 24.0 s | 1024×1024 PNG |
| Image | mflux | Anima Turbo (q8) | 36.4 s | 1024×1024 PNG |
| Image | mflux | Z-Image Turbo (q4) | 95.8 s | 1024×1024 PNG |
| Image | mflux | FLUX.2 klein 4B Base (q8) | 97.1 s | 1024×1024 PNG |
| Image | [mlx-gen](https://github.com/lpalbou/mlx-gen) | ERNIE Image Turbo (q8) | 123.5 s | 1024×1024 PNG |
| Image | [mlx-gen](https://github.com/lpalbou/mlx-gen) | Qwen Image (mixed q4/q8) | 124.9 s | 1024×1024 PNG |
| Image | mflux | FLUX 3 Image Klein | 180.6 s | 1024×1024 PNG |
| **Video** | [VideoX-Fun-mlx](https://github.com/dgrauet/VideoX-Fun-mlx) | CogVideoX-Fun V1.5 5B (int4) | **247.7 s** | 672×384, 5-frame GIF |
| Video | [mlx-gen](https://github.com/lpalbou/mlx-gen) | Wan2.2 TI2V 5B (int8) | 255.6 s | 480×832, 25-frame MP4 |
| Video | VideoX-Fun-mlx | CogVideoX-Fun V1.5 5B (int8) | 262.1 s | 672×384, 5-frame GIF |

Every number is wall clock on this one machine, **model load included**, and every
output is verified against the file it wrote — the PNG header for images, `ffprobe`
for clips — not against a tool's log line. Rows are ordered by time, images first
and then clips, fastest first — the two units are not comparable, so the video
block restarts at the top of its own scale. The image figures are the mean **after
the first image**, which is the one that pays the one-time model load; each video
figure is that model's own mean over its six clips. **Every image row is now
1024×1024**, so the image column compares like with like. Two image rows do not run
through mflux — `ernie-image-turbo-q8` and `qwen-image-4bit` run through mlx-gen,
and Qwen's per-image figure carries a real spread (the text-heavy prompts cost
~131 s against ~117 s for the rest), while ERNIE sits within a second of 123.5 s on
every prompt. The images and clips are in
[`evidence/`](evidence/) so the claim can be checked by looking, not by trusting.

**Pick by what you are doing.** The chart and the flowchart below settle most
choices; the full comparison with every figure traced to its run file is in
[`docs/reference/COMPARISON.md`](docs/reference/COMPARISON.md).

```mermaid
flowchart TD
    A[What do you need?] --> B{Image or video?}
    B -->|Image| C{Commercial use?}
    B -->|Video| D{Commercial use?}
    C -->|Yes| E[klein-q4 · 23.0 s · Apache-2.0 · 4.3 GB]
    C -->|Yes, room for 8-bit| E4[klein-q8 · 24.0 s · Apache-2.0 · 8.0 GB]
    C -->|No, quality first| F[flux3-klein-q8 · 180.6 s · FLUX Kommunity]
    D -->|Yes| G[Wan2.2 TI2V 5B · Apache-2.0 · 255.6 s/clip]
    D -->|No / research| H[cogvideox q4 · 247.7 s/clip · CogVideoX License]
    E --> I[Fast, text renders clean]
    E4 --> I4[Same speed class, smallest on disk]
    F --> J[Hands and text look better, 8x slower]
    G --> K[Best licence, 25 frames, 16 fps]
    H --> L[4% faster than q8, both prompt/seed-sensitive]
```

---

<a id="hardware--software"></a>

## 💻 Hardware & Software

| Item | Value |
|---|---|
| Machine | **Apple MacBook Pro (16-inch, 2021)**, model `MacBookPro18,2` |
| Chip | **Apple M1 Max** (10-core CPU: 8P + 2E, 32-core GPU, 16-core Neural Engine) |
| Memory | **64 GB** unified |
| OS | **macOS 26.7.2** (build 25G332), arm64 |
| Image tool | **mflux** — native-MLX diffusion CLI, one process per prompt |
| Video tool | **VideoX-Fun-mlx** (CogVideoX-Fun), **mlx-gen** (Wan2.2) |
| Measurement | PNG IHDR for images, **`ffprobe`** for clips |

The exact model matters, so it is named rather than described — the 32-core GPU
and 400 GB/s of memory bandwidth are what the timings below are against:

- Apple's own specification: [support.apple.com/en-us/111901](https://support.apple.com/en-us/111901)
- EveryMac's breakdown of this exact configuration:
  [MacBook Pro M1 Max 10-core CPU, 32-core GPU (16-inch, 2021)](https://everymac.com/systems/apple/macbook_pro/specs/macbook-pro-m1-max-10-core-cpu-32-core-gpu-16-2021-specs.html)

<a id="the-environment"></a>

### 🧪 The environment

Hardware is half the story; the other half is what the weights are executed by.
Nothing in this repository calls `llama.cpp`, `ollama`, or a GGUF runtime — text
LLMs are the companion repository's job. Both layers here are model-specific
Python inference engines on Apple's [MLX](https://github.com/ml-explore/mlx)
framework, which is the tensor runtime (the PyTorch-shaped layer), not the engine:

| Layer | What runs the model | What that sits on |
| :--- | :--- | :--- |
| Image | **mflux** — FLUX graph, sampler, VAE, tokenizer | MLX → Metal |
| Video (Wan) | **mlx-gen** — Wan2.2 graph and sampler | MLX → Metal |
| Video (CogVideoX) | **VideoX-Fun-mlx** — CogVideoX-Fun graph and sampler | MLX → Metal |
| Measurement | `scripts/measure/*.py` — spawns the engine, times it, verifies the file | Python 3 stdlib |

Exact versions this was measured on:

| Item | Value |
|---|---|
| Python | **3.15.2** (CPython, arm64, from Homebrew) |
| Virtualenv | `~/Sites/.mlxgen-venv` (1.4 GB, isolated — not Homebrew's site-packages) |
| `mlx` | **0.32.4** |
| `mlx-metal` | **0.32.4** |
| `mlx-gen` | **0.38.0** (ships the `mflux-generate*` commands *and* `mlxgen`) |
| `mlx-arsenal` | **0.19.0** (required by VideoX-Fun-mlx, not pulled in by mlx-gen) |
| `ffmpeg` / `ffprobe` | **9.0.2** |

`pip install mflux` does **not** appear anywhere on purpose: mflux arrives inside
the `mlx-gen` package, and installing both into one environment makes the two
disagree about who owns the `mflux-generate*` scripts. That clash is why this is
a dedicated virtualenv rather than a `uv tool install`.

```bash
python3.15 -m venv ~/Sites/.mlxgen-venv
~/Sites/.mlxgen-venv/bin/pip install mlx-gen mlx-arsenal
export PATH="$HOME/Sites/.mlxgen-venv/bin:$PATH"   # the harnesses call tools by name
```

One GPU job at a time: the harnesses refuse to start while another `mflux`,
`mlxgen`, or `quick_infer` process is alive — two of these do not fit in 64 GB of
unified memory at once.

```mermaid
flowchart TB
    A[Your prompt] --> B{Layer?}
    B -->|Image| C[mflux-generate-flux2 / flux3]
    B -->|Video| D[quick_infer.py / mlxgen]
    C --> E[MLX 0.32.4]
    D --> E
    E --> F[Metal GPU · M1 Max 32-core]
    F --> G[Unified memory 64 GB]
    G --> H[PNG / GIF on disk]
    H --> I[ffprobe / PNG IHDR verify]
```

**No API, no account, no per-call bill.** Every model runs from weights on disk.

<a id="models"></a>

## 🧩 Models

| Model | Disk | Quant | Licence | Source |
|---|---:|---|---|---|
| `flux2-klein-4b-mflux-q8` | 8.0 GB | int8 | Apache-2.0 | [HF](https://huggingface.co/mflux-community/flux2-klein-4b-mflux-q8) |
| `FLUX.2-klein-4B-mflux-4bit` | 4.3 GB | int4 | Apache-2.0 | [HF](https://huggingface.co/Runpod/FLUX.2-klein-4B-mflux-4bit) |
| `flux-3-image-klein-base-mflux-q8` | 9.2 GB | int8 | FLUX Kommunity | [HF](https://huggingface.co/mflux-community/flux-3-image-klein-base-mflux-q8) |
| `anima-turbo-mflux-q8` | 4.0 GB | int8 | Circlestone non-commercial | [HF](https://huggingface.co/mflux-community/anima-turbo-mflux-q8) |
| `flux-2-klein-base-4b-mflux-q8` | 8.6 GB | int8 | Apache-2.0 | [HF](https://huggingface.co/mflux-community/flux-2-klein-base-4b-mflux-q8) |
| `z-image-turbo-mflux-q4` | 5.5 GB | int4 | Apache-2.0 | [HF](https://huggingface.co/mflux-community/z-image-turbo-mflux-q4) |
| `iris-3b-turbo-mflux-q8` | 8.0 GB | int8 | Apache-2.0 | [HF](https://huggingface.co/mflux-community/iris-3b-turbo-mflux-q8) |
| `boogu-image-turbo-mflux-q8` | 20.3 GB | int8 | Apache-2.0 | [HF](https://huggingface.co/mflux-community/boogu-image-turbo-mflux-q8) |
| `bonsai-image-ternary-4B-mlx-2bit` | 3.6 GB | ternary 1.58-bit | Apache-2.0 | [HF](https://huggingface.co/prism-ml/bonsai-image-ternary-4B-mlx-2bit) |
| `ernie-image-turbo-8bit` | 11.5 GB | int8 | Apache-2.0 | [HF](https://huggingface.co/AbstractFramework/ernie-image-turbo-8bit) |
| `qwen-image-4bit` | 16.2 GB | mixed q4/q8 | Apache-2.0 | [HF](https://huggingface.co/AbstractFramework/qwen-image-4bit) |
| `CogVideoX-Fun-V1.5-5b-InP-mlx-q8` | 15 GB | int8 | CogVideoX License | [HF](https://huggingface.co/dgrauet/CogVideoX-Fun-V1.5-5b-InP-mlx-q8) |
| `CogVideoX-Fun-V1.5-5b-InP-mlx-q4` | 13 GB | int4 | CogVideoX License | [HF](https://huggingface.co/dgrauet/CogVideoX-Fun-V1.5-5b-InP-mlx-q4) |
| `wan2.2-ti2v-5b-diffusers-8bit` | 17 GB | int8 | Apache-2.0 | [HF](https://huggingface.co/AbstractFramework/wan2.2-ti2v-5b-diffusers-8bit) |

**Total on disk:** ~144 GB · **Runtime memory:** up to ~30 GB per loaded model on 64 GB unified memory. Every model runs from weights on disk — no API, no account.

<a id="model-map"></a>

## 🗺️ Model map

![Model map (light)](docs/diagrams/model-map/model-map-light.png)

[`docs/diagrams/model-map/model-map.html`](docs/diagrams/model-map/model-map.html) — the interactive version (theme toggle). [`model-map-dark.png`](docs/diagrams/model-map/model-map-dark.png) for the dark theme.

Which generation model for which job, at the seconds it actually cost, in one picture.

<a id="what-was-measured"></a>

## 📊 What was measured

| Suite | Origin | What it measures |
| :--- | :--- | :--- |
| Image | ours, over **mflux** and **mlx-gen** | Seconds per image, PNG verified |
| Video | ours, over **VideoX-Fun-mlx** and **mlx-gen** | Seconds per clip, `ffprobe` verified |
| Licences | ours, from the HF cards | "Downloadable" vs "commercially usable" |

Both harnesses run offline against themselves before they touch a model:
`python3 scripts/measure/<suite>.py --selftest`. `test/test.sh` runs the gate and
proves the harnesses agree with their own fixtures. The gate is thirteen steps —
syntax and naming, prompt sets, profiles, evidence links, licences, both
selftests, the reference figures recomputed from the JSON, the Mermaid diagrams,
the model map's files, PNGs and Hugging Face links, that every profile is
named in every document that lists models, and that the disk totals add up.
Step 6 is coverage rather than keywords: every profile needs a licence row, so a
non-commercial model cannot be measured and left undocumented. Step 9 reads the
prose as well as the tables: a figure carrying a unit, or the image headline
restated, has to be one the data produces, so a second copy of a sentence goes
red instead of drifting. Step 13 sums the model tables and compares the result
with the total each document claims, because two documents once agreed on a
wrong number.

The tools we measured **through**, without which there would be no column at all:
[mflux](https://github.com/filipstrand/mflux),
[VideoX-Fun-mlx](https://github.com/dgrauet/VideoX-Fun-mlx),
[mlx-gen](https://github.com/lpalbou/mlx-gen), over
[MLX](https://github.com/ml-explore/mlx). The full reading — including what is
ours and what is borrowed — is in
[`docs/reference/COMPARISON.md`](docs/reference/COMPARISON.md).

<a id="image-generation"></a>

## 🖼️ Image generation

Image runs through [mflux](https://github.com/filipstrand/mflux), a native-MLX
diffusion tool. One `mflux-generate-*` process per prompt, timed end to end, the
written PNG verified.

| Model (profile) | Licence | s/img | s/step | Steps | Size |
| :--- | :--- | ---: | ---: | ---: | :--- |
| [`FLUX.2-klein-4B-mflux-4bit`](https://huggingface.co/Runpod/FLUX.2-klein-4B-mflux-4bit) (`klein-q4`) | Apache-2.0 | **23.0** | 5.7 | 4 | 1024×1024 |
| [`flux2-klein-4b-mflux-q8`](https://huggingface.co/mflux-community/flux2-klein-4b-mflux-q8) (`klein-q8`) | Apache-2.0 | 24.0 | 6.0 | 4 | 1024×1024 |
| [`iris-3b-turbo-mflux-q8`](https://huggingface.co/mflux-community/iris-3b-turbo-mflux-q8) (`iris-turbo-q8`) | Apache-2.0 | 24.1 | 6.0 | 4 | 1024×1024 |
| [`anima-turbo-mflux-q8`](https://huggingface.co/mflux-community/anima-turbo-mflux-q8) (`anima-turbo-q8`) | **Circlestone non-commercial** | 36.4 | 4.6 | 8 | 1024×1024 |
| [`z-image-turbo-mflux-q4`](https://huggingface.co/mflux-community/z-image-turbo-mflux-q4) (`z-image-turbo-q4`) | Apache-2.0 | 95.8 | 10.6 | 9 | 1024×1024 |
| [`flux-2-klein-base-4b-mflux-q8`](https://huggingface.co/mflux-community/flux-2-klein-base-4b-mflux-q8) (`klein-base-q8`) | Apache-2.0 | 97.1 | 4.9 | **20** | 1024×1024 |
| [`ernie-image-turbo-8bit`](https://huggingface.co/AbstractFramework/ernie-image-turbo-8bit) (`ernie-image-turbo-q8`) | Apache-2.0 | 123.5 | 15.4 | 8 | 1024×1024 |
| [`qwen-image-4bit`](https://huggingface.co/AbstractFramework/qwen-image-4bit) (`qwen-image-4bit`) | Apache-2.0 | 124.9 | 13.8 | 9 | 1024×1024 |
| [`boogu-image-turbo-mflux-q8`](https://huggingface.co/mflux-community/boogu-image-turbo-mflux-q8) (`boogu-turbo-q8`) | Apache-2.0 | 160.8 | 20.1 | 8 | 1024×1024 |
| [`flux-3-image-klein-base-mflux-q8`](https://huggingface.co/mflux-community/flux-3-image-klein-base-mflux-q8) (`flux3-klein-q8`) | FLUX Kommunity | 180.6 | 11.3 | 16 | 1024×1024 |

Rows are ordered by `s/img`, fastest first. Every row here is **1024×1024**, so the
column compares like with like. `ernie-image-turbo-q8` and `qwen-image-4bit` run
through **mlx-gen**, not mflux, and neither is a distilled few-step model: at 8 and
9 steps and 1024×1024 they land between Z-Image Turbo and FLUX 3, and at **15.4 and
13.8 s/step** they carry the priciest steps of the measured rows below FLUX 3 —
read the per-image and per-step figures together, because Qwen's per-image spread
is real rather than load: the prompts that need a long text render run ~131 s, the
rest ~117 s, where ERNIE sits within a second of 123.5 s on every prompt.

Two rows are new and neither is a FLUX model. **`iris-turbo-q8`** is a 3B
**pixel-space** model: there is no VAE and no latent, the transformer predicts RGB
directly, and it lands at **24.1 s/img** — inside the klein pair's noise, on a
different architecture. **`boogu-turbo-q8`** is a 10B DMD-distilled checkpoint and
the largest image package here at **20.3 GB**; at 1024×1024 it needs **8 steps**
(mflux's port notes 4 steps is enough up to ~768 px) and takes **160.8 s/img**, so
it is the second-slowest row, ahead only of FLUX 3. Its 20.1 s/step is the price of
the parameter count, not of the schedule.

`bonsai-image-ternary-2bit` is the one mlx-gen image profile with **no row**: on
stock `mlx-gen 0.38.0` its initializer omits `compiled_predict_cache`, which the
inherited generation path reads, so runs fail before the first step. A local
patch that builds that field produced images; the fix is upstream and not in a
released wheel yet, so the profile stays unmeasured here. The diagnosis, patch
and verified run are in [mlx-gen issue #22](https://github.com/lpalbou/mlx-gen/issues/22),
with settings in [`PROFILES.md`](docs/reference/PROFILES.md).

```mermaid
xychart-beta horizontal
    title "Seconds per image (lower is better, model load included)"
    x-axis ["klein-q4", "klein-q8", "iris-turbo", "anima-turbo", "z-image-turbo-q4", "klein-base-q8", "ernie-image", "qwen-image", "boogu-turbo", "flux3-klein-q8"]
    y-axis "seconds" 0 --> 200
    bar [23.0, 24.0, 24.1, 36.4, 95.8, 97.1, 123.5, 124.9, 160.8, 180.6]
```

A 4-step distilled 4B model runs ~24 s per 1024×1024 image (the first is slower,
~28 s, because the model loads); FLUX 3 at 16 steps and a 5.6B transformer takes
~180 s. **Anima Turbo** is the smallest package on disk (4.0 GB) and the cheapest
per step (**4.6 s**), but at 8 steps it still needs 36.4 s an image — the *third*
fastest, not the first; a small file is not a short wait. **`klein-base`** is the
distilled `klein`'s non-distilled twin at the same size, and its 97.1 s against
24.0 s is mostly the schedule, not the architecture — 20 steps instead of 4 — with
a *lower* s/step than its distilled sibling (4.9 against 6.0). Z-Image Turbo — a
9-step distilled 6B model, Apache-2.0 — sits between them at **95.8 s**, ~4× slower
than klein and ~1.9× faster than FLUX 3. Both klein quantisations are within a
second of each other and the order between them is **not stable**: the 4-bit
(`klein-q4`, 4.3 GB, the smallest on disk) measured **23.0 s** against the 8-bit
sibling's **24.0 s**, but on the previous run of the same pair the 8-bit was ahead
by 1.3 s. A ~5 % gap on one machine is run-to-run noise, so read the two as a tie
and choose on disk and memory, where the 4-bit does win — its saving is storage,
not seconds. Earlier runs of this pair used mflux's default guidance 3.5 rather
than the profiles' 1.0 (`build_argv` dropped the field; see `CHANGELOG.md`), which
is why the older figures are 22.5 / 23.8. All figures are the mean of the seven
steady-state images, with the first — the one that includes model load — left out;
that is the `s/img` column. **The klein pair is ~8× faster than FLUX 3** and is the
one to use unless you need FLUX 3 specifically. Legible text and correct hands —
the classic failure surfaces — come out clean across the latent models; the one
exception is the pixel-space row, Iris-3B Turbo, whose poster adds a clipped second
line and whose hands are the least certain. Z-Image Turbo is the
Apache-2.0 alternative when FLUX 3's commercial-output cap rules it out but klein's
speed is not the priority.

Eighty images, each with the prompt that produced it:

[`evidence/image-benchmark-2026-11-12.md`](evidence/image-benchmark-2026-11-12.md),
[`evidence/image-benchmark-flux3-2026-11-12.md`](evidence/image-benchmark-flux3-2026-11-12.md),
[`evidence/image-benchmark-zimage-2026-11-14.md`](evidence/image-benchmark-zimage-2026-11-14.md),
[`evidence/image-benchmark-klein-q4-2026-11-17.md`](evidence/image-benchmark-klein-q4-2026-11-17.md),
[`evidence/image-benchmark-qwen.md`](evidence/image-benchmark-qwen.md),
[`evidence/image-benchmark-ernie.md`](evidence/image-benchmark-ernie.md),
[`evidence/image-benchmark-anima.md`](evidence/image-benchmark-anima.md),
[`evidence/image-benchmark-klein-base.md`](evidence/image-benchmark-klein-base.md),
[`evidence/image-benchmark-iris-2026-11-27.md`](evidence/image-benchmark-iris-2026-11-27.md)
and [`evidence/image-benchmark-boogu-2026-11-27.md`](evidence/image-benchmark-boogu-2026-11-27.md).

<a id="video-generation"></a>

## 🎬 Video generation

Video runs through [VideoX-Fun-mlx](https://github.com/dgrauet/VideoX-Fun-mlx)
driving CogVideoX-Fun V1.5 5B and [mlx-gen](https://github.com/lpalbou/mlx-gen)
driving Wan2.2 TI2V 5B. One runner process per prompt, timed end to end, and every
clip verified with `ffprobe` — the file, not the runner's log line.

| Model (profile) | Licence | s/clip | Output | Frames | OK |
| :--- | :--- | ---: | :--- | ---: | :---: |
| [`dgrauet/CogVideoX-Fun-V1.5-5b-InP-mlx-q4`](https://huggingface.co/dgrauet/CogVideoX-Fun-V1.5-5b-InP-mlx-q4) (`cogvideox-fun-1.5-5b-inp-q4`) | **The CogVideoX License** | **247.7** | 672×384, 1.6 s, GIF | 5 | ✅ 6/6 |
| [`AbstractFramework/wan2.2-ti2v-5b-diffusers-8bit`](https://huggingface.co/AbstractFramework/wan2.2-ti2v-5b-diffusers-8bit) (`wan22-ti2v-5b-q8`) | Apache-2.0 | **255.6** | 480×832, 1.6 s, MP4 | 25 | ✅ 6/6 |
| [`dgrauet/CogVideoX-Fun-V1.5-5b-InP-mlx-q8`](https://huggingface.co/dgrauet/CogVideoX-Fun-V1.5-5b-InP-mlx-q8) (`cogvideox-fun-1.5-5b-inp-q8`) | **The CogVideoX License** | **262.1** | 672×384, 1.6 s, GIF | 5 | ✅ 6/6 |

```mermaid
xychart-beta horizontal
    title "Seconds per clip (lower is better, model load included)"
    x-axis ["cogvideox q4", "wan2.2", "cogvideox q8"]
    y-axis "seconds" 0 --> 350
    bar [247.7, 255.6, 262.1]
```

**262.1 s** for a 5-frame 672×384 clip — the mean of six prompts spanning
258.7–274.9 s — so a clip that plays for 1.6 s costs over four minutes of GPU.
Five frames is the cheapest usable value, not a ceiling: `--frames` must be
`1 mod 4` and the pipeline decodes `(F-1)//4*4+1` frames, so 4 gives 1, 8 gives
the same 5 as 5, and 13 gives 13 — while 9, 17 and 25 raise a reshape error.

A q4 quantisation of the same model runs at 247.7 s/clip (about 5.5% faster) with
the same output shape but **no quality guarantee on either quant**: both are
prompt- and seed-sensitive, so a fast row is a compute measurement — the file is
the proof. Wan2.2's `s/clip` is the most prompt-dependent of the three
(233.7–299.8 s across the same six prompts) against CogVideoX's under-17 s spread.
All three rows are in
[`evidence/video-benchmark-2026-11-12.md`](evidence/video-benchmark-2026-11-12.md).

The eighteen clips, each with the prompt that produced it, are in
[`evidence/video-benchmark-2026-11-12.md`](evidence/video-benchmark-2026-11-12.md).

<a id="profiles"></a>

## ⚙️ Profiles

Each layer has its own profile file — **no image or video setting is an oMLX
profile**, because oMLX cannot run either:

| Setting | `klein-q8` | `flux3-klein-q8` | `cogvideox-fun-1.5-5b-inp-q8` |
| :--- | ---: | ---: | ---: |
| Layer | image | image | video |
| Size | 1024×1024 | 1024×1024 | 672×384 |
| Steps | 4 | 16 | 50 |
| Guidance | 1.0 | — (distilled) | 6.0 |
| Seed | 42 | 42 | 42 |
| Output | PNG | PNG | GIF, 5 frames |

Full settings, why each value was chosen, and the exact commands to reproduce a
run are in [`docs/reference/PROFILES.md`](docs/reference/PROFILES.md).

<a id="reproducing"></a>

## 🔁 Reproducing

1. Build the environment once — Python 3.15, one virtualenv, two installs:

   ```bash
   brew install python@3.15 ffmpeg
   python3.15 -m venv ~/Sites/.mlxgen-venv
   ~/Sites/.mlxgen-venv/bin/pip install mlx-gen mlx-arsenal
   export PATH="$HOME/Sites/.mlxgen-venv/bin:$PATH"
   git clone https://github.com/dgrauet/VideoX-Fun-mlx ~/Sites/VideoX-Fun-mlx
   ```

   Why each piece, and what is deliberately *not* installed, is in
   [`docs/reference/ENVIRONMENT.md`](docs/reference/ENVIRONMENT.md).
2. Download the model weights (see [`docs/reference/PROFILES.md`](docs/reference/PROFILES.md)
   for the exact model ids).
3. Run the harness or the one-shot CLI — both are in
   [`docs/reference/PROFILES.md`](docs/reference/PROFILES.md#running-these-yourself).

```bash
# Image: the whole eight-prompt suite
python3 scripts/measure/image-benchmark.py --profile klein-q8 --out-dir ./out

# Video: the whole six-prompt suite
python3 scripts/measure/video-benchmark.py \
  --profile cogvideox-fun-1.5-5b-inp-q8 \
  --repo ~/Sites/VideoX-Fun-mlx \
  --model ~/Sites/VideoX-Fun-mlx/models/cogvideox-fun-q8 \
  --out-dir /tmp/videorun --json-out /tmp/videorun/results.json
```

The offline gate needs no model and no network:

```bash
./test/test.sh
```

<a id="repository-structure"></a>

## 📂 Repository structure

```text
Local Image and Video Generation on an Apple M1 Max 64GB/
├── README.md · README.tr.md
├── CHANGELOG.md · CONTRIBUTING.md · CODE_OF_CONDUCT.md · SECURITY.md
├── data/                       # the prompt sets, one JSON per layer
│   ├── image-prompts.json
│   └── video-prompts.json
├── profiles/
│   ├── mflux-profiles.json     # image settings
│   └── video-profiles.json     # video settings
├── evidence/                   # the runs: pages, and the images/clips themselves
│   ├── image-benchmark-*.md
│   ├── video-benchmark-*.md
│   ├── images/                 # 40 PNGs
│   └── videos/                 # 18 clips
├── reference/                  # machine-readable copies of every number
├── docs/
│   ├── README.md
│   ├── diagrams/               # the model-map poster: HTML original + rendered PNGs
│   ├── guides/                 # naming conventions
│   └── reference/              # comparison · profiles · licences · environment
├── scripts/
│   ├── measure/                # image-benchmark.py, video-benchmark.py
│   ├── release/                # export-video-evidence.py
│   ├── render/                 # render-model-map.py — poster HTML → PNG
│   └── lint.sh                 # every linter, at pinned versions
├── test/test.sh                # offline gate
└── .github/workflows/ci.yml    # the gate and the lint run, on demand
```

<a id="links"></a>

## 🔗 Links

The tools behind the numbers, and the text half of the benchmark:

- [oMLX](https://omlx.ai) — the local text server. The
  [text benchmark](https://github.com/mahirfatih/omlx-m1-max-benchmark) lives in
  its own repository because oMLX cannot generate an image or a clip.
- [mflux](https://github.com/filipstrand/mflux) — the native-MLX diffusion CLI
  behind the FLUX, Z-Image, Anima and klein image profiles.
- [VideoX-Fun-mlx](https://github.com/dgrauet/VideoX-Fun-mlx) — the CogVideoX-Fun
  port behind the video profiles.
- [mlx-gen](https://github.com/lpalbou/mlx-gen) — ships the `mflux-generate*`
  commands, runs Wan2.2, and drives the ERNIE and Qwen Image profiles.

<a id="contributing"></a>

## 🤝 Contributing

Corrections and additional data points are welcome — see
[`CONTRIBUTING.md`](CONTRIBUTING.md). A timing must arrive with the output it
timed. Run `./test/test.sh` before you push; [`scripts/lint.sh`](scripts/lint.sh)
runs every linter at once.

<a id="notes--disclaimer"></a>

## ⚠️ Notes & disclaimer

- **Timings are for this machine only.** A different M1/M2/M3/M4 changes them.
- **Sample sizes are small.** Eight image prompts, six video prompts. A gap of a
  second or two is noise; an 8× gap is not.
- **Speed and quality are not one score.** Look at
  [`evidence/images/`](evidence/images/) and [`evidence/videos/`](evidence/videos/)
  and judge the output.
- **Download is not a licence.** FLUX 3 and CogVideoX carry terms that Apache-2.0
  does not; see [`docs/reference/LICENSES.md`](docs/reference/LICENSES.md) before
  shipping anything into something that earns money.
- This repository redistributes **no model weights** — only measurements and the
  outputs those models produced.

<a id="license"></a>

## 📄 License

The code and documents here are **MIT** (see [`LICENSE`](LICENSE)). That covers
this repository, not the models it measures: the model licences are the property
of their authors and travel with the weights.
