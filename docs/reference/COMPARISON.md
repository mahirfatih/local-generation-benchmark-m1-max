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
| Repository | [`local-generation-benchmark-m1-max`](https://github.com/mahirfatih/local-generation-benchmark-m1-max) | [`omlx-m1-max-benchmark`](https://github.com/mahirfatih/omlx-m1-max-benchmark) |
| Layers | Image (mflux), video (VideoX-Fun-mlx / mlx-gen) | Text (oMLX) |
| Numbers | Seconds per image, per clip, `ffprobe`/PNG verified | tok/s, coding, format, context, hallucination, red-team |

## At a glance

| Task | Model | Tool | Licence | Time | Output |
| :--- | :--- | :--- | :--- | ---: | :--- |
| **Image** | `flux2-klein-4b` | mflux | Apache-2.0 | **22.5 s** | 1024×1024, 4 steps |
| Image | `flux-3-image-klein-base` | mflux | FLUX Kommunity | 180.6 s | 1024×1024, 16 steps |
| **Video** | `CogVideoX-Fun-V1.5-5b-InP` | VideoX-Fun-mlx | **CogVideoX License** | **266.1 s** | 672×384, 5 frames, GIF |

Read down each column, not across the rows: seconds per image and seconds per
clip are not comparable units, and nor are the two ways they are averaged —
`s/img` is the mean **after the first image**, whose number carries the one-time
model load, while `s/clip` is the mean of all four clips. **22.5 s buys a still;
266.1 s buys 1.6 s of motion.** That gap is the whole story of local generation
on this machine.

## Image generation — a separate layer

Text runs through oMLX; images run through [mflux](https://github.com/filipstrand/mflux),
a different tool. One `mflux-generate-*` process per prompt, wall clock, the
written PNG checked.

| Model | Licence | s/img | s/step | Steps | Size |
| :--- | :--- | ---: | ---: | ---: | :--- |
| `flux2-klein-4b-mflux-q8` | Apache-2.0 | **22.5** | 5.6 | 4 | 1024×1024 |
| `flux-3-image-klein-base-mflux-q8` | FLUX Kommunity | 180.6 | 11.3 | 16 | 1024×1024 |

Both were run on eight prompts covering the surfaces that separate image
models: photorealism, hands, legible text, composition, style. **klein-q8 wins
by 8×** and is the one to use unless you need FLUX 3 specifically. The PNGs are
committed in [`evidence/images/`](../../evidence/images/); legible text and
correct hands came out clean on both.

The same prompt — a poster whose whole point is whether the two words render as
words — on both models. The cheap one did not need the expensive one's help here:

| `flux2-klein-4b` (22.5 s) | `flux-3-klein-base` (180.6 s) |
| :---: | :---: |
| ![LOCAL FIRST poster, klein-q8](../../evidence/images/klein-q8--text-poster.png) | ![LOCAL FIRST poster, flux-3-klein q8](../../evidence/images/flux3-klein-q8--text-poster.png) |

Every one of the sixteen images, with the prompt that produced it, is in
[`evidence/image-benchmark-2026-11-12.md`](../../evidence/image-benchmark-2026-11-12.md)
and
[`evidence/image-benchmark-flux3-2026-11-12.md`](../../evidence/image-benchmark-flux3-2026-11-12.md).

## Video generation — a separate layer

Run through [VideoX-Fun-mlx](https://github.com/dgrauet/VideoX-Fun-mlx), measured
with `ffprobe`. Seconds per clip, model load included.

| Model | Licence | Runner | s/clip | Output | Status |
| :--- | :--- | :--- | ---: | :--- | :--- |
| `CogVideoX-Fun-V1.5-5b-InP` (int8) | **The CogVideoX License** | VideoX-Fun-mlx | **266.1** | 672×384, 5 frames, GIF | ✅ 4/4 |
| `CogVideoX-Fun-V1.5-5b-InP` (int4) | **The CogVideoX License** | VideoX-Fun-mlx | **256.3** | 672×384, 5 frames, GIF | ✅ 4/4 |
| `Wan2.2-TI2V-5B` (int8) | Apache-2.0 | mlx-gen | **285.9** | 480×832, 25 frames, MP4 | ✅ 4/4 |

CogVideoX-Fun renders a 5-frame 672×384 clip in **266.1 s on average** (four
prompts, 265.2–267.2 s), which is ~4.4 minutes of waiting for a clip that plays
for 1.6 s. The spread is under 2 s, so any single figure in that range is honest;
266.1 is the mean of the four. The frame count
is this model's ceiling, not a choice: `--frames` is not linear and 5 is as far as
it decodes, so more steps or a larger request buys nothing. All four clips — with
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

**Sample sizes are small.** Eight image prompts, four video prompts. A gap of a
second or two is noise; an 8× gap is not.

Speed and quality are **not a single score**. The images and clips are committed —
[`evidence/images/`](../../evidence/images/), [`evidence/videos/`](../../evidence/videos/) —
so look at them and judge the output rather than trusting a number.
