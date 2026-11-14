# Changelog

All notable changes to this repository are recorded here. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project uses
date-based snapshots rather than semver releases.

## [Unreleased]

### Added — Z-Image Turbo, a third image profile

- **`z-image-turbo-q4`** — Z-Image Turbo (`Tongyi-MAI/Z-Image-Turbo`), MLX 4-bit via
  `mflux-community/z-image-turbo-mflux-q4`, a 9-step distilled 6B DiT, **Apache-2.0**.
  Eight prompts, **95.8 s/img** (`s/img`: mean of the seven steady-state images, the
  first dropped). It lands between the two FLUX models — ~4.3× slower than `klein-q8`
  (22.5 s) and ~1.9× faster than `flux3-klein-q8` (180.6 s). Profile in
  `profiles/mflux-profiles.json`; data in `reference/image-benchmark-zimage.json`;
  evidence in `evidence/image-benchmark-zimage-2026-11-14.md`.
- **A correction it surfaced:** the documented `--compute-precision float16` no longer
  exists in mflux 0.38.0 (shipped by `mlx-gen` 0.38.0). The new profile carries **no**
  precision flag; the two FLUX profiles retain the value from the run that produced
  their figures, but a fresh run on the current venv fails on that flag until it is
  dropped. Noted in `docs/reference/PROFILES.md` and `profiles/mflux-profiles.json`.

### Fixed — the FLUX 3 average, and a tolerance that let it drift

- **The published `s/img` for FLUX 3 was 180.4 s; the data gives 180.55.** The
  eight runs are 191.0 (the first, which pays model load), then 180.36, 180.42,
  180.41, 180.57, 180.12, 180.47, 181.52 — mean **180.55 s**, which rounds to
  **180.6**, not 180.4. The number had been carried since before the last run
  landed and was never recomputed. Corrected in `README.md`, `README.tr.md`,
  `docs/reference/COMPARISON.md` and `docs/reference/PROFILES.md`.
- **`test/test.sh` step 9 compared with a 0.5 s tolerance, which is why the
  error survived.** The documents round to one decimal, so the widest a correct
  figure can be off is 0.05 s; the test now uses that bound, and names the data
  value to three decimals when it fails. The old tolerance would also have
  accepted 180.5 and 180.0 for the same run.

### Fixed — the video average, frozen paths, and a guard that watched the wrong repository

- **The published `s/clip` was one sample, not the mean.** The four CogVideoX
  clips are 265.17, 267.19, 266.27, 265.96 s — mean **266.15**, median 266.12.
  The documents said **265.9**, which was the last one rounded, presented as the
  model's typical time. Corrected to **266.1**, with the 265.2–267.2 s spread
  stated beside it.
- **The averaged values are now defined, not implied.** `s/img` is the mean of
  the steady-state images with the first (the one that pays model load) left out;
  `s/clip` is the mean of all four clips. The rule is written where the numbers
  are, in `README.md`, `docs/reference/COMPARISON.md` and
  `docs/reference/PROFILES.md`.
- **Committed results pointed at a tree that no longer exists.** Every image in
  `reference/image-benchmark*.json` named its file as an absolute path under
  `~/Sites/omlx-m1-max-benchmark/` — the repository this one was split out of.
  The harnesses now write paths **relative to the repository root**, the
  committed files are repaired back to `evidence/images/...`, and `test/test.sh`
  step 9 fails on an absolute path.
- **The GPU guard watched the wrong repository.** `image-benchmark.py`'s
  busy-check listed the text benchmark's scripts and called them "oMLX benchmark
  processes", while omitting its own sibling `video-benchmark.py`, `mlxgen`,
  `quick_infer.py` and `mflux-generate` — so an image run would happily start
  next to a video run, the one thing the guard exists to prevent. Both harnesses
  now watch every GPU layer (text, image, video).

### Added — the repository is a proper public repository, not a file drop

- `CHANGELOG.md` (this file), `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`,
  `SECURITY.md` and `README.tr.md`.
- `.github/workflows/ci.yml` — the offline gate and the full lint run, manual
  only, because a benchmark's numbers come from a specific machine.
- `scripts/lint.sh` — ruff, shellcheck, actionlint, yamllint and
  markdownlint-cli2 at pinned versions, run identically by hand and by CI.
- `.editorconfig`, `.yamllint`, `pyproject.toml` — the whitespace and lint rules
  the rest of the tree already followed.
- A `README.md` in every directory that holds files: `data/`, `profiles/`,
  `reference/`, `evidence/`, `docs/`, `docs/reference/`, `scripts/`,
  `scripts/measure/`, `scripts/release/` and `test/`.

### Added — the split from the text benchmark

- This repository is the generation half of the local-MLX benchmark: **images**
  (mflux) and **video** (VideoX-Fun-mlx), with their harnesses, prompt sets,
  profiles, machine-readable results and the committed outputs — **16 images and
  4 clips**.
- oMLX serves text and only text; it cannot run either layer, which is why the
  two repositories are apart. The text benchmark is
  [`mahirfatih/omlx-m1-max-benchmark`](https://github.com/mahirfatih/omlx-m1-max-benchmark).

### Added — the video run

- `CogVideoX-Fun-V1.5-5b-InP` (int8) through VideoX-Fun-mlx: four clips, 5 frames
  each at 672×384, ~266 s per clip, model load included, every clip verified with
  `ffprobe`.
- `--frames` is not linear and **5 is this model's ceiling**: 4 → 1 frame, 8 → the
  same 5 as 5, an odd count raises a reshape error. The runner's own
  `Saved N frames` line is unreliable; the harness counts with `ffprobe`.

### Added — the image run

- `flux2-klein-4b-mflux-q8` (`klein-q8`): 8 prompts, ~22.5 s per 1024×1024 image
  at 4 steps.
- `flux-3-image-klein-base-mflux-q8` (`flux3-klein-q8`): 8 prompts, ~180 s per
  image at 16 steps. **klein-q8 wins by 8×.**

### Added — the licence reading

- `docs/reference/LICENSES.md` records what each model's own card says, because
  "downloadable" and "commercially usable" are not the same thing:
  - **FLUX 3 Image Klein** — the FLUX Kommunity License v1.0, not Apache-2.0;
    commercial output use capped at **US$5M** revenue.
  - **CogVideoX-Fun** — the quant is tagged `apache-2.0`, but its base model is
    under **The CogVideoX License** (academic free, commercial
    registration-gated). Do not trust the tag.
