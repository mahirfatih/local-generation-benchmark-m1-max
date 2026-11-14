# Environment

What the numbers in this repository were produced with. Every figure assumes this
environment exactly; a different Python patch level, a different `mlx`, or a
different quantisation will move the seconds per image and per clip.

Hardware is in the [README](../../README.md#hardware--software). This document is
the software half: the stack, the install, and the four things people get wrong.

## The stack, bottom to top

```text
5. this repository   scripts/measure/{image,video}-benchmark.py
                     spawns one engine process per prompt, times it end to end,
                     verifies the output (PNG IHDR / ffprobe)
4. CLI surface       mflux-generate-flux2 · mflux-generate-flux3 ·
                     mflux-generate-z-image-turbo · mflux-generate
                     mlxgen generate · scripts/quick_infer.py
3. inference engine  mflux (FLUX · Z-Image) · mlx-gen (Wan2.2) · VideoX-Fun-mlx (CogVideoX-Fun)
                     model graph, sampler, VAE, tokenizer — Python
2. MLX 0.32.4        tensors, ops, Metal kernels, unified memory
1. Metal             Apple GPU driver
```

MLX is the runtime, not the engine: it knows how to run a matmul on the GPU, not
what a FLUX transformer is. The engines are the three Python packages in row 3.
Nothing in rows 1–5 is `llama.cpp`, `ollama`, or GGUF — those serve text models,
and text models live in the
[companion repository](https://github.com/mahirfatih/omlx-m1-max-benchmark).

## Install, from a clean macOS

```bash
xcode-select --install                              # git, compiler
brew install python@3.15 ffmpeg                     # interpreter, ffprobe
python3.15 -m venv ~/Sites/.mlxgen-venv             # 1.4 GB, isolated
~/Sites/.mlxgen-venv/bin/pip install mlx-gen mlx-arsenal
export PATH="$HOME/Sites/.mlxgen-venv/bin:$PATH"
git clone https://github.com/dgrauet/VideoX-Fun-mlx ~/Sites/VideoX-Fun-mlx
```

`mlx-gen` brings `mlx`, `mlx-metal`, `numpy`, `torch`, `transformers`,
`tokenizers`, `sentencepiece`, `safetensors`, `huggingface-hub`, `hf-transfer`,
`pillow`, `opencv-python`, `av`. `mlx-arsenal` is separate and required: it is
where VideoX-Fun-mlx imports its spatial ops from
(`videox_fun_mlx/models/cogvideox_vae.py`).

Verify:

```bash
mflux-generate --help | head -1
mlxgen capabilities --model flux2-klein-4b | head -3
ffprobe -version | head -1
```

## Which binary each profile calls

| Profile | Command | Engine |
| :--- | :--- | :--- |
| `klein-q8` | `mflux-generate-flux2` | mflux |
| `z-image-turbo-q4` | `mflux-generate-z-image-turbo` | mflux |
| `flux3-klein-q8` | `mflux-generate-flux3` | mflux |
| `cogvideox-fun-1.5-5b-inp-q8` | `python3 scripts/quick_infer.py` | VideoX-Fun-mlx |
| `cogvideox-fun-1.5-5b-inp-q4` | `python3 scripts/quick_infer.py` | VideoX-Fun-mlx |
| `wan22-ti2v-5b-q8` | `mlxgen generate --family wan` | mlx-gen |

`mlxgen` resolves `--model` from an alias, a Hugging Face repo id, **or a local
directory** — the local-directory form needs the family hint
(`--model ~/models/AbstractFramework/wan2.2-ti2v-5b-diffusers-8bit --family wan`),
and `mlxgen capabilities` confirms the routing before a run costs you 20 minutes.

## Four things that go wrong

1. **`pip install mflux` next to `mlx-gen`.** Both ship `mflux-generate*` console
   scripts; the second install owns them and the versions drift. One virtualenv,
   `mlx-gen` only.
2. **The system Python.** macOS's `/usr/bin/python3` has no `numpy` and no
   `pillow`, so `quick_infer.py` dies on import. The harness invokes
   `~/Sites/.mlxgen-venv/bin/python` for that reason.
3. **VideoX-Fun-mlx's `requirements.txt`.** It describes the torch training stack
   (`deepspeed`, `decord`, `librosa`, `gradio`, …). The MLX path needs `mlx`,
   `numpy`, `mlx-arsenal` and nothing else.
4. **The environment is not on `PATH`.** The harnesses call `mflux-generate-flux2`
   and `mlxgen` by name. Without the `export PATH` line the run fails at spawn,
   not at inference, and the error reads like a missing model.

## Models

Weights are read from disk, never from an API. Roughly 68 GB for everything
measured here — the same total the [README](../../README.md) states.

| Model | Local size |
| :--- | ---: |
| `mflux-community/flux2-klein-4b-mflux-q8` | 8.0 GB |
| `mflux-community/z-image-turbo-mflux-q4` | 5.5 GB |
| `mflux-community/flux-3-image-klein-base-mflux-q8` | 9.2 GB |
| `dgrauet/CogVideoX-Fun-V1.5-5b-InP-mlx-q8` | 15 GB |
| `dgrauet/CogVideoX-Fun-V1.5-5b-InP-mlx-q4` | 13 GB |
| `AbstractFramework/wan2.2-ti2v-5b-diffusers-8bit` | 17 GB |

```bash
hf download mflux-community/flux2-klein-4b-mflux-q8 \
  --local-dir ~/models/mflux-community/flux2-klein-4b-mflux-q8
```

Downloads are a licence question as much as a disk question: see
[`LICENSES.md`](LICENSES.md) before you assume a downloadable weight is a usable
one.
