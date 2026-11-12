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
4. Run `./test/test.sh` before you push; it must pass.
5. Do **not** commit API keys, tokens or other secrets.

## Which layer does my change belong to?

- **Images or video** — here.
- **Text, tokens per second, coding, hallucination, red-team** — the companion
  repository, [`mahirfatih/omlx-m1-max-benchmark`](https://github.com/mahirfatih/omlx-m1-max-benchmark).
  Nothing text-related belongs in this repository: oMLX cannot generate an image
  or a clip, which is why the two were split apart.

## Code style

- Python scripts should stay dependency-free (standard library only). The
  harnesses drive an external CLI; they do not import the model.
- Use clear, commented code and keep output human-readable.
- A new harness must have a `--selftest` that runs offline, and `test/test.sh`
  must call it.
