# Contributing

Thanks for your interest! This repository is primarily a benchmark snapshot, but
corrections and additional data points are welcome.

## Reporting a measurement

If you run either layer on different hardware, please include:

- Chip, RAM, macOS version
- The tool and its version (`mflux`, `VideoX-Fun-mlx` or `mlx-gen`)
- The model id and quantization
- The prompt and the per-run settings (size, steps, guidance, seed)
- The raw `--json-out` file, and the output itself

Open an issue or a pull request with the generated Markdown page under
`evidence/` and the JSON under `reference/`.

**A number without its output is not accepted.** The whole point of this
repository is that an image or a clip can be looked at, so a timing claim must
arrive with the file it timed.

## Pull requests

1. Fork the repository and create a topic branch.
2. Keep changes focused and reproducible.
3. Update `README.md` if you add or change results.
4. Run `./test/test.sh` before you push; it must pass. It needs no model and no
   network: syntax and naming, prompt sets, profiles, evidence links, licences,
   both harness selftests, the reference figures recomputed from the JSON, the
   Mermaid diagrams, the model map's files, PNGs and Hugging Face links, and that
   every profile is named in every document that lists models.
5. Do **not** commit API keys, tokens or other secrets.

## A table of measured things is ordered by the measurement

When a page lists runs with their seconds, the rows go **fastest first** — images
as one block, clips as another, because the two units are not comparable and the
second block restarts at the top of its own scale. A row left where it was
inserted is how a model measured at 30 s ended up below one at 96 s on three
pages, and how a model re-measured at 512×512 kept its old 30 s row next to
1024×1024 neighbours: the number was right and the placement told a different
story.

The same list is written in more than one place — `README.md`, `README.tr.md`,
`docs/reference/COMPARISON.md`, the model map — so fix the order everywhere the
table appears. Search for the number to find them; `test/test.sh` step 12 catches a
model that is missing, not one that is merely out of order.

**A number that was never measured must not look like one that was.** A profile
setting is not a result: `bonsai-image-ternary-2bit` asks for 1024×1024 and has
never produced a frame, so its row carries no `s/img` even though it names a size.
Side by side in one column a measured row and an unmeasured one read alike, so say
which is which **in the table itself**, not only in the prose around it — and when
two rows were measured at different sizes, say why the sizes differ, or the reader
cannot tell a cheap model from a cheap measurement.

## Which layer does my change belong to?

- **Images or video** — here.
- **Text, tokens per second, coding, hallucination, red-team** — the companion
  repository, [`mahirfatih/omlx-m1-max-benchmark`](https://github.com/mahirfatih/omlx-m1-max-benchmark).
  Nothing text-related belongs in this repository: oMLX cannot generate an image
  or a clip, which is why the two were split apart.

## This repository is the source; the app is a consumer

The macOS app
[`mahirfatih/mlx-media-studio`](https://github.com/mahirfatih/mlx-media-studio)
ships the models this repository measures. The split is deliberate and it has a
direction:

| Repository | Local path | GitHub |
| :--- | :--- | :--- |
| This benchmark | `~/Sites/local-generation-benchmark-m1-max` | [`mahirfatih/local-generation-benchmark-m1-max`](https://github.com/mahirfatih/local-generation-benchmark-m1-max) |
| The app | `~/Sites/mlx-media-studio` | [`mahirfatih/mlx-media-studio`](https://github.com/mahirfatih/mlx-media-studio) |

Both are checked out **side by side under `~/Sites/`**, and the app's exporter
reads this checkout by default, so a model added here reaches the app by being
here and the app re-running its exporter.

**The measurement lives here. The app carries the result.**

| Thing | Lives here | The app's copy |
| :--- | :--- | :--- |
| `profiles/mflux-profiles.json`, `profiles/video-profiles.json` — argv, steps, seed, size, licence | **yes** | generated into `model-catalog.json` |
| `data/image-prompts.json`, `data/video-prompts.json` — the prompt sets | **yes** | none |
| `reference/image-benchmark.json` and its siblings — the raw seconds | **yes** | none; the app reads the figure its exporter derives |
| `evidence/` — the pages and the output images | **yes** | none |

So: **do not add app-side artifacts here, and do not let a copy of these files
live in the app.** A second copy is a copy that drifts — one did, and it fell to
3 of 7 image profiles, so a wrong path in the app's exporter quietly wrote a
catalog missing four models. The app now fails loudly instead of falling back.
If a change of yours needs to reach the app, it reaches it by being here and the
app re-running its exporter; never by hand-editing `model-catalog.json` there.

## Code style

- Python scripts should stay dependency-free (standard library only). The
  harnesses drive an external CLI; they do not import the model.
- Use clear, commented code and keep output human-readable.
- A new harness must have a `--selftest` that runs offline, and `test/test.sh`
  must call it.
