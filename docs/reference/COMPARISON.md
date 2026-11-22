# Comparing the layers — images and video

Two generation layers, one machine. Both run **locally**: a model on disk, a
one-shot command per prompt, no account and no per-call bill. This page is the
single place to answer "which local model, for what", with every figure traced to
the run file it came from.

**Neither layer runs on oMLX.** oMLX is a text server; images run through
[mflux](https://github.com/filipstrand/mflux) and video through
[VideoX-Fun-mlx](https://github.com/dgrauet/VideoX-Fun-mlx) (or
[mlx-gen](https://github.com/lpalbou/mlx-gen) for the Wan2.2 layer). The text
benchmark lives in its own repository; this one is only the generation layers,
measured on the same M1 Max.

| | This repository | The text benchmark |
| :--- | :--- | :--- |
| Repository | [`Local Image and Video Generation on an Apple M1 Max 64GB`](https://github.com/mahirfatih/local-generation-benchmark-m1-max) | [`omlx-m1-max-benchmark`](https://github.com/mahirfatih/omlx-m1-max-benchmark) |
| Layers | Image (mflux), video (VideoX-Fun-mlx / mlx-gen) | Text (oMLX) |
| Numbers | Seconds per image, per clip, `ffprobe`/PNG verified | tok/s, coding, format, context, hallucination, red-team |

## At a glance

| Task | Model | Tool | Licence | Time | Output |
| :--- | :--- | :--- | :--- | ---: | :--- |
| **Image** | `flux2-klein-4b` (q4) | mflux | Apache-2.0 | **23.0 s** | 1024×1024, 4 steps |
| Image | `flux2-klein-4b` (q8) | mflux | Apache-2.0 | 24.0 s | 1024×1024, 4 steps |
| Image | `anima-turbo` (q8) | mflux | **Circlestone non-commercial** | 36.4 s | 1024×1024, 8 steps |
| Image | `z-image-turbo` | mflux | Apache-2.0 | 95.8 s | 1024×1024, 9 steps |
| Image | `flux2-klein-base-4b` (q8) | mflux | Apache-2.0 | 97.1 s | 1024×1024, **20 steps** |
| Image | `ernie-image-turbo-q8` | mlx-gen | Apache-2.0 | 123.5 s | 1024×1024, 8 steps |
| Image | `qwen-image-4bit` | mlx-gen | Apache-2.0 | 124.9 s | 1024×1024, 9 steps |
| Image | `flux-3-image-klein-base` | mflux | FLUX Kommunity | 180.6 s | 1024×1024, 16 steps |
| **Video** | `CogVideoX-Fun-V1.5-5b-InP` (int4) | VideoX-Fun-mlx | **CogVideoX License** | **247.7 s** | 672×384, 5 frames, GIF |
| Video | `Wan2.2-TI2V-5B` (int8) | mlx-gen | Apache-2.0 | 255.6 s | 480×832, 25 frames, MP4 |
| Video | `CogVideoX-Fun-V1.5-5b-InP` (int8) | VideoX-Fun-mlx | **CogVideoX License** | 262.1 s | 672×384, 5 frames, GIF |

Rows are ordered by time — images first, then clips, each block fastest first.

Read down each column, not across the rows: seconds per image and seconds per
clip are not comparable units, and nor are the two ways they are averaged —
`s/img` is the mean **after the first image**, whose number carries the one-time
model load, while `s/clip` is the mean of all six clips. **23.0 s buys a still;
262.1 s buys 1.6 s of motion.** That gap is the whole story of local generation
on this machine.

## Image generation — a separate layer

Text runs through oMLX; images run through [mflux](https://github.com/filipstrand/mflux),
a different tool. One `mflux-generate-*` process per prompt, wall clock, the
written PNG checked.

| Model | Licence | s/img | s/step | Steps | Size |
| :--- | :--- | ---: | ---: | ---: | :--- |
| `FLUX.2-klein-4B-mflux-4bit` | Apache-2.0 | **23.0** | 5.7 | 4 | 1024×1024 |
| `flux2-klein-4b-mflux-q8` | Apache-2.0 | 24.0 | 6.0 | 4 | 1024×1024 |
| `anima-turbo-mflux-q8` | **Circlestone non-commercial** | 36.4 | 4.6 | 8 | 1024×1024 |
| `z-image-turbo-mflux-q4` | Apache-2.0 | 95.8 | 10.6 | 9 | 1024×1024 |
| `flux-2-klein-base-4b-mflux-q8` | Apache-2.0 | 97.1 | 4.9 | **20** | 1024×1024 |
| `ernie-image-turbo-8bit` (mlx-gen) | Apache-2.0 | 123.5 | 15.4 | 8 | 1024×1024 |
| `qwen-image-4bit` (mlx-gen) | Apache-2.0 | 124.9 | 13.8 | 9 | 1024×1024 |
| `flux-3-image-klein-base-mflux-q8` | FLUX Kommunity | 180.6 | 11.3 | 16 | 1024×1024 |

All eight were run on eight prompts covering the surfaces that separate image
models: photorealism, hands, legible text, composition, style. **The klein pair is
~8× faster than FLUX 3** and is the one to use unless you need FLUX 3
specifically. The **two klein quantisations are a tie** — the 4-bit is the
smallest on disk (4.3 GB) and measured 23.0 s against the 8-bit's 24.0 s this
round, but the previous round of the same pair put the 8-bit 1.3 s ahead, so a
~5 % gap is run-to-run noise rather than a ranking. Choose between them on disk
and memory, where the 4-bit wins: its weights are dequantised on the fly rather
than narrowing the compute, so the saving is storage, not seconds.
**Anima Turbo** is the smallest package
on disk (4.0 GB) and the cheapest per step (**4.6 s**), but at 8 steps it still
needs 36.4 s an image, so it is the *third* fastest, not the first — a small file
is not a short wait. **`klein-base` is the distilled `klein`'s non-distilled
twin at the same size**, and its 97.1 s against 24.0 s is mostly the schedule,
not the architecture: 20 steps instead of 4. Its s/step is *lower* than the
distilled sibling's (4.9 against 6.0), so the difference is step count — read the
two rows together or the base model looks slow for the wrong reason. **Z-Image
Turbo** is the middle option and the Apache-2.0 one: ~4× slower than klein,
~1.9× faster than FLUX 3. **ERNIE Image Turbo** sits just under **Qwen Image**,
both through **mlx-gen** rather than mflux, and neither is a distilled few-step
model: at 8 and 9 steps and 1024×1024 they land between Z-Image Turbo and FLUX 3,
and at **15.4 and 13.8 s/step**
they carry the priciest steps of the measured rows below FLUX 3 — read the
per-image and per-step figures together, because Qwen's per-image figure carries a
real spread (the text-heavy prompts run ~131 s against ~117 s for the rest, where
ERNIE sits within a second of 123.5 s on every prompt and the other rows sit
within a few seconds too). Every image row here is 1024×1024, so the
`s/img` column compares like with like. The PNGs are committed in
[`evidence/images/`](../../evidence/images/); legible text and correct hands came
out clean on all of them.

One further mlx-gen image profile exists but carries **no timing row**, so it is
named here rather than given a number this table cannot support:
**`bonsai-image-ternary-2bit`** does not run at all on `mlx-gen 0.38.0`: its
initializer never builds `compiled_predict_cache`, which the generation path it
inherits then reads, so every run raises `AttributeError` before the first step.
The profile is correct and the fault is upstream, reported as
[mlx-gen issue #22](https://github.com/lpalbou/mlx-gen/issues/22). Its settings
are in
[`docs/reference/PROFILES.md`](PROFILES.md).

The same prompt — a poster whose whole point is whether the two words render as
words — on all four models. The cheap one did not need the others' help here:

| `flux2-klein-4b` q4 (23.0 s) | `flux2-klein-4b` q8 (24.0 s) | `z-image-turbo` (95.8 s) | `flux-3-klein-base` (180.6 s) |
| :---: | :---: | :---: | :---: |
| ![LOCAL FIRST poster, klein-q8](../../evidence/images/klein-q8--text-poster.png) | ![LOCAL FIRST poster, klein-q4](../../evidence/images/klein-q4--text-poster.png) | ![LOCAL FIRST poster, z-image-turbo-q4](../../evidence/images/z-image-turbo-q4--text-poster.png) | ![LOCAL FIRST poster, flux-3-klein q8](../../evidence/images/flux3-klein-q8--text-poster.png) |

Every one of the sixty-four images, with the prompt that produced it, is in
[`evidence/image-benchmark-2026-11-12.md`](../../evidence/image-benchmark-2026-11-12.md),
[`evidence/image-benchmark-flux3-2026-11-12.md`](../../evidence/image-benchmark-flux3-2026-11-12.md),
[`evidence/image-benchmark-zimage-2026-11-14.md`](../../evidence/image-benchmark-zimage-2026-11-14.md),
[`evidence/image-benchmark-klein-q4-2026-11-17.md`](../../evidence/image-benchmark-klein-q4-2026-11-17.md),
[`evidence/image-benchmark-qwen.md`](../../evidence/image-benchmark-qwen.md),
[`evidence/image-benchmark-ernie.md`](../../evidence/image-benchmark-ernie.md),
[`evidence/image-benchmark-anima.md`](../../evidence/image-benchmark-anima.md)
and
[`evidence/image-benchmark-klein-base.md`](../../evidence/image-benchmark-klein-base.md).

## Video generation — a separate layer

Run through [VideoX-Fun-mlx](https://github.com/dgrauet/VideoX-Fun-mlx), measured
with `ffprobe`. Seconds per clip, model load included.

| Model | Licence | Runner | s/clip | Output | Status |
| :--- | :--- | :--- | ---: | :--- | :--- |
| `CogVideoX-Fun-V1.5-5b-InP` (int4) | **The CogVideoX License** | VideoX-Fun-mlx | **247.7** | 672×384, 5 frames, GIF | ✅ 6/6 |
| `Wan2.2-TI2V-5B` (int8) | Apache-2.0 | mlx-gen | **255.6** | 480×832, 25 frames, MP4 | ✅ 6/6 |
| `CogVideoX-Fun-V1.5-5b-InP` (int8) | **The CogVideoX License** | VideoX-Fun-mlx | **262.1** | 672×384, 5 frames, GIF | ✅ 6/6 |

CogVideoX-Fun renders a 5-frame 672×384 clip in **262.1 s on average** (six
prompts, 258.7–274.9 s), which is over four minutes of waiting for a clip that
plays for 1.6 s. The spread is under 17 s, so any single figure in that range is
honest; 262.1 is the mean of the six. The frame count
is a `1 mod 4` choice, not a ceiling: `--frames` is not linear, the pipeline
decodes `(F-1)//4*4+1` frames (4 → 1, 5 and 8 → 5, 13 → 13), and 9, 17 and 25
raise a reshape error. Five is the cheapest usable value, so more frames are
available at more compute — but a larger request does not simply buy more.
All six clips — with
the prompt under each — are in
[`evidence/video-benchmark-2026-11-12.md`](../../evidence/video-benchmark-2026-11-12.md).

The licence column matters more here than anywhere else on this page: the
quantised repository tags itself `apache-2.0` while the base model it derives
from is under **The CogVideoX License**. See
[`LICENSES.md`](LICENSES.md).

## Where the tests come from

Most of them we wrote, because the standard suites measure things this machine
cannot answer. Some are shaped by an existing benchmark, and where that is the
case the upstream project is named below so you can go and read it yourself.

| Suite | Origin | What it measures |
| :--- | :--- | :--- |
| Image | ours, over **mflux** | Seconds per image, PNG verified |
| Video | ours, over **VideoX-Fun-mlx** | Seconds per clip, `ffprobe` verified |
| Licences | ours, from the HF cards | "Downloadable" vs "commercially usable" |

Every harness is runnable offline against itself before it touches a model:
`python3 scripts/measure/<suite>.py --selftest`. `test/test.sh` runs the offline
gate and proves the harnesses agree with their own fixtures.

### The tools we measured through

| Project | What we took from it |
| :--- | :--- |
| [@filipstrand/mflux](https://github.com/filipstrand/mflux) | Image generation. `image-benchmark.py` drives its CLI and times it. |
| [@dgrauet/VideoX-Fun-mlx](https://github.com/dgrauet/VideoX-Fun-mlx) | The CogVideoX-Fun layer. `video-benchmark.py` drives its `quick_infer.py`. |
| [@lpalbou/mlx-gen](https://github.com/lpalbou/mlx-gen) | Text/image-to-video, the Wan2.2 layer. Named for the pending profile. |
| [@ml-explore/mlx](https://github.com/ml-explore/mlx) | The framework under everything here. |

**What is ours and only ours:** the image and video harnesses, the prompt sets,
the licence readings, and the `ffprobe`-verified output checks.

## How to read this

Every figure traces to a JSON file in [`reference/`](../../reference/), produced
by the harness named beside it. Nothing on this page was typed by hand.

**Sample sizes are small.** Eight image prompts, six video prompts. A gap of a
second or two is noise; an 8× gap is not.

Speed and quality are **not a single score**. The images and clips are committed —
[`evidence/images/`](../../evidence/images/), [`evidence/videos/`](../../evidence/videos/) —
so look at them and judge the output rather than trusting a number.
