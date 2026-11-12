# profiles

The settings each generation layer runs with — the machine-readable source of
the tables in [`../docs/reference/PROFILES.md`](../docs/reference/PROFILES.md).

| File | Layer | Tool |
| :--- | :--- | :--- |
| [`mflux-profiles.json`](mflux-profiles.json) | Image | [`mflux`](https://github.com/filipstrand/mflux) |
| [`video-profiles.json`](video-profiles.json) | Video | [`VideoX-Fun-mlx`](https://github.com/dgrauet/VideoX-Fun-mlx), [`mlx-gen`](https://github.com/lpalbou/mlx-gen) |

**These are not oMLX profiles.** oMLX serves text and cannot run a diffusion
model, so there is no `omlx-profiles.json` here and an image or video entry in
one would target a server that cannot use it. The text profiles live in the
[companion repository](https://github.com/mahirfatih/omlx-m1-max-benchmark).

## Shape

Every entry under `generation_profiles` carries:

- `model` / `base_model` — the quantised id and what it derives from
- `license` and `license_note` — the terms, read from the HF card
- `settings` — width, height, steps, guidance, seed, frames, compute precision
- a run command: `cli` for an image profile (a single `mflux-generate-*`), or
  `invoke` for a video profile (the full argv, with `{repo}`/`{model}`
  placeholders the harness fills)

`test/test.sh` step 4 fails if a profile has no licence, no settings or no
command.

## Adding a profile

Copy the nearest existing one, change the model and the settings, and state why
each value was chosen — the doc's "why" column is not decoration. A profile with
no committed run behind it cannot appear in the comparison tables; mark it
`pending` in the docs until it has one, as the Wan2.2 profile is now.
