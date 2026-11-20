# Profiles — how each generation layer is configured

This repository runs **two** generation layers, each with its own tool and its own
profile file. Neither is oMLX: oMLX serves text, and it cannot generate an image or
a clip. Keeping the layers in separate files is deliberate — nothing here is applied
to the oMLX server, and an image or video entry in an oMLX profile would target a
server that cannot run it.

| Layer | Tool | Profile file |
| :--- | :--- | :--- |
| Image | [`mflux`](https://github.com/filipstrand/mflux) | [`profiles/mflux-profiles.json`](../../profiles/mflux-profiles.json) |
| Video | [`VideoX-Fun-mlx`](https://github.com/dgrauet/VideoX-Fun-mlx), [`mlx-gen`](https://github.com/lpalbou/mlx-gen) | [`profiles/video-profiles.json`](../../profiles/video-profiles.json) |

The text layer and its oMLX profiles live in the companion repository,
[mahirfatih/omlx-m1-max-benchmark](https://github.com/mahirfatih/omlx-m1-max-benchmark);
see [`COMPARISON.md`](COMPARISON.md).

## Image generation — a separate layer (mflux)

The image model is **not** served by oMLX: it is run by
[`mflux`](https://github.com/filipstrand/mflux), a native-MLX diffusion tool, so its
settings live in a separate file,
[`profiles/mflux-profiles.json`](../../profiles/mflux-profiles.json).

| Setting | `klein-q8` | `z-image-turbo-q4` | `flux3-klein-q8` |
| :--- | ---: | ---: | ---: |
| Model | `mflux-community/flux2-klein-4b-mflux-q8` | `mflux-community/z-image-turbo-mflux-q4` | `mflux-community/flux-3-image-klein-base-mflux-q8` |
| Base model | `black-forest-labs/FLUX.2-klein-4B` | `Tongyi-MAI/Z-Image-Turbo` | `black-forest-labs/flux-3-image-klein-base` |
| CLI | `mflux-generate-flux2` | `mflux-generate-z-image-turbo` | `mflux-generate-flux3` |
| Quantization | MLX affine, 8-bit | MLX affine, 4-bit | MLX affine, 8-bit (modified) |
| Width × height | 1024 × 1024 | 1024 × 1024 | 1024 × 1024 |
| Steps | 4 | 9 | 16 |
| Guidance scale | 1.0 | — (tool default) | — (none; distilled) |
| Seed | 42 | 42 | 42 |
| Compute precision | `float16` | — (flag absent in mflux 0.38.0) | `float16` |
| Licence | Apache-2.0 | Apache-2.0 | **FLUX Kommunity License** |

**`klein-q8`** — the quantization is 8-bit MLX affine across the text encoder,
transformer and VAE, stored in the weights (no `--quantize` flag). The 4 steps and
guidance 1.0 are the distilled-sampling values from the [FLUX.2 \[klein\] model
card](https://huggingface.co/black-forest-labs/FLUX.2-klein-4B); width, height
and seed are fixed so a run is reproducible. It inherits Apache-2.0 from the base
model.

**`flux3-klein-q8`** — FLUX 3 Image Klein is a 5.6B transformer with a Qwen3-VL-4B
text encoder; the distilled checkpoint runs **16 steps with no guidance**, and
`--guidance` is ignored on it. The uploader modified the MLX build: the transformer
is 8-bit and the **text encoder is truncated to layers 0–31** and quantized to
8-bit — worth remembering when reading a quality difference. Its licence is the
[FLUX Kommunity License v1.0](https://huggingface.co/black-forest-labs/flux-3-image-klein-base/blob/main/LICENSE.md),
**not** Apache-2.0; the output rules (including the US$5M revenue line) are in
[`LICENSES.md`](LICENSES.md).

**`z-image-turbo-q4`** — Z-Image Turbo is a distilled 6B single-stream DiT (Tongyi
Lab / Alibaba) that reaches quality in **9 steps**; the MLX build is 4-bit affine
across the text encoder, transformer and VAE, stored in the weights. Apache-2.0
inherited from the base model, so it is the profile to reach for when FLUX 3's
[FLUX Kommunity License](https://huggingface.co/black-forest-labs/flux-3-image-klein-base/blob/main/LICENSE.md)
rules it out. It measured **95.8 s/img** — between klein and FLUX 3.

**`klein-q4`** — the same FLUX.2 klein 4B as `klein-q8`, with the weights
quantized one step further: `mlx-affine` 4-bit across the text encoder, transformer
and VAE, stored in the checkpoint (no `--quantize` flag), on
`Runpod/FLUX.2-klein-4B-mflux-4bit`. Apache-2.0. It is the smallest profile on
disk (4.3 GB) and it measured **23.8 s/img** — **+1.3 s (+5.8 %)** *slower* than
the 8-bit sibling, not faster. A smaller quantisation does not buy seconds here:
the checkpoint ships its own 4-bit weights that are dequantised on the fly, so the
saving is disk and memory, not compute. Because the weights carry the level, the
profile needs no `--compute-precision` flag. Eight prompts, 22.8–25.2 s, run
2026-11-17; data in
[`reference/image-benchmark-klein-q4.json`](../../reference/image-benchmark-klein-q4.json).

Both FLUX profiles run **float16 compute** (`--compute-precision float16`): the
Apple M1 family has no native bfloat16, and MLX's matmul and attention kernels are
fastest in float16 there. mflux measured FLUX.2 klein 4B (q4) at 6.8 → 5.0 s/step
(−22%) with the flag. **Z-Image Turbo's profile carries no compute precision:** the
mflux build in the documented venv (`mlx-gen` 0.38.0) no longer accepts
`--compute-precision`, so the harness passes no precision flag for this profile. The
two FLUX profiles keep the `float16` value from the run that produced their figures.

## Image generation through mlx-gen (not mflux)

Two image models ship in
[`profiles/mflux-profiles.json`](../../profiles/mflux-profiles.json) — the file
groups *image* models, not mflux ones — but run through
[`mlx-gen`](https://github.com/lpalbou/mlx-gen)'s `mlxgen` console script, with
their own `invoke` argv. They are **not** benchmarked yet: their timings and peak
memory are unmeasured, and the app shows them as such rather than quoting a guess.

| Setting | `bonsai-image-ternary-2bit` | `ernie-image-turbo-q8` |
| :--- | ---: | ---: |
| Model | `prism-ml/bonsai-image-ternary-4B-mlx-2bit` | `AbstractFramework/ernie-image-turbo-8bit` |
| Base model | `prism-ml/bonsai-image-ternary-4B-unpacked` | `baidu/ERNIE-Image-Turbo` |
| CLI | `mlxgen` | `mlxgen` |
| Quantization | ternary 1.58-bit g128 (transformer); 4-bit text encoder | MLX affine, 8-bit |
| Width × height | 1024 × 1024 | 512 × 512 |
| Steps | 4 | 8 |
| Guidance scale | 1.0 | 1.0 |
| Seed | 42 | 42 |
| On-disk | 3.6 GB | 11.5 GB |
| Licence | Apache-2.0 | Apache-2.0 |

**`bonsai-image-ternary-2bit`** — Bonsai Image 4B is a **ternary** (1.58-bit, one
scale per 128-weight group) deployment of the FLUX.2 Klein 4B architecture
(`model_index.json` → `Flux2KleinPipeline`), 4 steps at guidance 1.0 with a
FlowMatch-Euler sampler (shift 3.0), no CFG. The 3.88 GB payload includes a 4-bit
text encoder that is offloaded after prompt encoding, so the denoising loop keeps
only the compact transformer and VAE resident. Source:
[`prism-ml/bonsai-image-ternary-4B-mlx-2bit`](https://huggingface.co/prism-ml/bonsai-image-ternary-4B-mlx-2bit).

**`ernie-image-turbo-q8`** — ERNIE-Image-Turbo, MLX 8-bit weights in the
mlx-gen saved-weight layout (not a Diffusers `from_pretrained` checkpoint). The
uploader's own example runs **8 steps at guidance 1**. Source:
[`AbstractFramework/ernie-image-turbo-8bit`](https://huggingface.co/AbstractFramework/ernie-image-turbo-8bit).

Neither accepts `--base-model` or `--compute-precision`: the `mlxgen` CLI has
neither flag, which is why each carries an explicit `invoke` template instead of
falling back to the generic mflux argv.

## Video profiles

Video is a **third layer** with its own runners and its own file,
[`profiles/video-profiles.json`](../../profiles/video-profiles.json). Neither mflux
nor oMLX generates video: [**mlx-gen**](https://github.com/lpalbou/mlx-gen) runs
Wan2.2, and [**VideoX-Fun-mlx**](https://github.com/dgrauet/VideoX-Fun-mlx) runs
CogVideoX-Fun.

| Setting | `wan22-ti2v-5b-q8` | `cogvideox-fun-1.5-5b-inp-q8` |
| :--- | ---: | ---: |
| Model (as the runner resolves it) | `AbstractFramework/wan2.2-ti2v-5b-diffusers-8bit` | `dgrauet/CogVideoX-Fun-V1.5-5b-InP-mlx-q8` |
| Base model | `Wan-AI/Wan2.2-TI2V-5B-Diffusers` | `alibaba-pai/CogVideoX-Fun-V1.5-5b-InP` |
| Runner | `mlxgen generate` | `python scripts/quick_infer.py` |
| Quantization | mixed q8 / BF16 | int8 (transformer block linears) |
| Width × height | 480 × 832 | 672 × 384 |
| Frames | 25 | 5 |
| fps | 16 | — (GIF) |
| Steps | 20 | 50 |
| Guidance | 5 | 6.0 |
| Seed | 42 | 42 |
| Output | `.mp4` | animated `.gif` |
| Licence | Apache-2.0 | **The CogVideoX License** |

**`wan22-ti2v-5b-q8`** — Wan2.2 TI2V-5B is a 5B MoE video model with a Wan2.2-VAE
(16×16×4 compression), supporting text- and image-to-video up to 720P@24fps. The
canvas, frame count and step count here are a **conservative baseline for a 64 GB
machine** with `--low-ram`, deliberately smaller than the uploader's validation
profile (1280×704, 17 frames, 20 steps on 128 GB, which peaked near 104 GiB). The
licence is Apache-2.0, inherited from the base model.

Its `invoke` carries `--image {image}` and the profile sets
`accepts_input_image: true`, so a caller that has a first frame can pass it; a
caller with no image resolves the placeholder to nothing and the flag goes with
it, leaving a text-to-video run. Wan is the **only** video profile that takes an
image — `quick_infer.py` has no `--image`, so the CogVideoX profiles stay
text-to-video.

The weights that were measured are `AbstractFramework/wan2.2-ti2v-5b-diffusers-8bit`
(the `model` the profile resolves to); the **base model** they quantise is
upstream `Wan-AI/Wan2.2-TI2V-5B-Diffusers`, and the two are never the same file
on disk. This is not cosmetic: mlx-gen resolves a model from an alias, a Hugging
Face repo id, **or a local directory**. The local-directory form needs the family
hint:
`mlxgen capabilities --model ~/models/AbstractFramework/wan2.2-ti2v-5b-diffusers-8bit --family wan`
reports `wan.text-video`, so routing works. What that does not prove is that the
8-bit quantisation in that folder loads — oMLX's scheme and mlx-gen's expectations
may differ, and only a real run settles it. The Hugging Face cache copy
(`models--Wan-AI--Wan2.2-TI2V-5B-Diffusers`) is incomplete and should be ignored.

**`cogvideox-fun-1.5-5b-inp-q8`** — CogVideoX-Fun V1.5 5B is a diffusers-style DiT
ported to MLX; `quick_infer.py` writes an animated GIF and has its own defaults (used
here: 672×384, 5 frames, 50 steps, guidance 6.0). Its licence is **not** the
`apache-2.0` tag on the quant: the base model is under **The CogVideoX License**
(academic free, commercial registration-gated) — see [`LICENSES.md`](LICENSES.md).
The runner *code* (VideoX-Fun-mlx) is Apache-2.0; the *weights* are not.

A q4 quantisation of the same port (`cogvideox-fun-1.5-5b-inp-q4`, 13 GB) runs
at 247.7 s/clip against q8's 262.1 s (about 5.5% faster) at identical output
settings (672×384, 5 frames, 3.125 fps) — the only change is the weight file. The
q4 download is missing `spiece.model`; it is byte-identical to q8's tokenizer, so
copying that file (773 KB) completes it.

**The q4 is cheaper and more prompt- and seed-sensitive, and the q8 shares the
failure mode.** The timing tables above compare wall clock, not quality, and a
look at the files says they differ: on a snowy-fox prompt at seed 42 the q4 clip
resolved to green dither with a red shape, a q4 sunset at another seed was
coherent, and the q8 itself produced the same dither on that fox prompt at seed
42. So the failure tracks the prompt/seed pair rather than the weight file —
neither quant is "the same output" as the other across seeds, and a clip that
plays is not the same as a clip that shows the prompt. The timing row says which
is faster; only opening the file says which is usable.

A real run of either profile needs its runner installed and its model downloaded;
`scripts/measure/video-benchmark.py` refuses to start while any other GPU job is
active, and reads the finished clip's size, frame count, frame rate and duration
back with **ffprobe** rather than trusting the runner's log.

### `--frames` is not linear

Measured on `cogvideox-fun-1.5-5b-inp-q8`, and worth knowing before you tune it.
The pipeline decodes `(F-1)//4*4+1` frames, so the GIF is nine times out of ten
not the number you asked for, and a value the transformer cannot reshape aborts
the run:

| `--frames` | Frames in the written GIF | Note |
| ---: | ---: | :--- |
| 4 | **1** | Not four. The VAE's temporal compression collapses it. |
| 5 | **5** | The profile's value — and the cheapest usable one. |
| 6 | **5** | Same output as 5; the extra frames are not in the file. |
| 8 | **5** | Same as 5 too. |
| 13 | **13** | More frames *are* available: 13 decodes to 13. |
| 9 | — | `ValueError: [reshape] ...` |
| 17 | — | `ValueError: [reshape] ...` |
| 25 | — | `ValueError: [reshape] ...` |

Three consequences. **`--frames` must be `1 mod 4`** — 1, 5, 9, 13, … — because
the patch size is 2 and `frames // 2` has to divide evenly into the latent grid;
the odd values 9, 17 and 25 are rejected not for being odd but because they land
on the wrong slot. **`--frames 5` is the cheapest value that yields a usable
clip**, which is why the profile ships it; 13 gives a longer clip for more
compute, and this is not a ceiling. And **the runner's own `Saved N frames` log
line is unreliable** — it counts the decoded array, so `--frames 8` logs "Saved 8
frames" while the file holds 5. The harness counts with `ffprobe`, not that line.

## Running these yourself

The tables above describe the settings; these are the commands. Two tools, one GPU
— **never run two generation jobs at once**. The video harness checks this itself
(it refuses to start next to another GPU job), but if you are typing by hand, that
is on you.

### Image — mflux

The CLI is one-shot: it loads the model, generates, writes the PNG, exits. The
first image therefore includes model load and runs slower (~28 s for klein-q8),
which is why every `s/img` figure is the mean of the steady-state images with the
first left out. Output size is whatever `--height`/`--width` say.

```bash
# klein-q8 — the 22.5 s/image profile. Steps and guidance come from the model card.
mflux-generate-flux2 \
  --model mflux-community/flux2-klein-4b-mflux-q8 \
  --base-model flux2-klein-4b \
  --prompt "Photorealistic rainy-night street market in Istanbul, wet cobblestones" \
  --width 1024 --height 1024 --steps 4 --guidance 1.0 --seed 42 \
  --compute-precision float16 \
  --output market.png
```

```bash
# flux3-klein-q8 — the 180.6 s/image profile. Distilled: 16 steps, no guidance.
mflux-generate-flux3 \
  --model mflux-community/flux-3-image-klein-base-mflux-q8 \
  --base-model flux3-klein-base \
  --prompt "Minimalist swiss-style poster with the exact headline \"LOCAL FIRST\"" \
  --width 1024 --height 1024 --steps 16 --seed 42 \
  --compute-precision float16 \
  --output poster.png
```

`--guidance` is ignored on the FLUX 3 distilled checkpoint — passing it does
nothing rather than erroring, which is worth knowing before you tune it.

```bash
# z-image-turbo-q4 — the 95.8 s/image profile. Distilled: 9 steps, tool-default guidance.
mflux-generate-z-image-turbo \
  --model mflux-community/z-image-turbo-mflux-q4 \
  --base-model z-image-turbo \
  --prompt "Studio product shot of matte-black over-ear headphones on a seamless light-grey backdrop" \
  --width 1024 --height 1024 --steps 9 --seed 42 \
  --output headphones.png
```

To run the whole eight-prompt suite instead of one prompt:

```bash
python3 scripts/measure/image-benchmark.py --profile z-image-turbo-q4 --out-dir ~/Desktop/out
```

### Video — mlx-gen and VideoX-Fun-mlx

```bash
# wan22-ti2v-5b-q8 — the venv is not on PATH by default.
export PATH="$HOME/Sites/.mlxgen-venv/bin:$PATH"
mlxgen download --model Wan-AI/Wan2.2-TI2V-5B-Diffusers   # once
mlxgen generate \
  --model Wan-AI/Wan2.2-TI2V-5B-Diffusers \
  --prompt "a cup of coffee steaming on a windowsill, morning light" \
  --width 480 --height 832 --frames 25 --fps 16 \
  --steps 20 --guidance 5 --seed 42 \
  --low-ram --output clip.mp4
```

```bash
# cogvideox-fun-1.5-5b-inp-q8 — the runner writes a GIF, not an mp4.
python3 ~/Sites/VideoX-Fun-mlx/scripts/quick_infer.py \
  --model-path ~/Sites/VideoX-Fun-mlx/models/cogvideox-fun-q8 \
  --prompt "a cup of coffee steaming on a windowsill, morning light" \
  --width 672 --height 384 --frames 5 --steps 50 \
  --guidance-scale 6.0 --seed 42 \
  --output clip.gif
```

Two traps, both already hit here:

- `quick_infer.py`'s `--model-path` defaults to the uploader's own machine
  (`/Users/dgrauet/Work/...`). Always pass your own downloaded path.
- The CogVideoX weights download **very unevenly**. `huggingface_hub` with
  `HF_HUB_ENABLE_HF_TRANSFER=1` measured **0.40 MB/s** for this repo and stalled;
  plain `curl -C -` against the resolve endpoint measured **7.7 MB/s**, 19× faster,
  and resumed cleanly. If a large video download looks stuck, switch to curl.

To run the whole six-prompt video suite instead of one prompt:

```bash
python3 scripts/measure/video-benchmark.py \
  --profile cogvideox-fun-1.5-5b-inp-q8 \
  --repo ~/Sites/VideoX-Fun-mlx \
  --model ~/Sites/VideoX-Fun-mlx/models/cogvideox-fun-q8 \
  --out-dir /tmp/videorun --json-out /tmp/videorun/results.json
```
