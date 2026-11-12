# scripts

Every script in this repository, grouped by what it does. Nothing here imports a
model: each one drives an external CLI and reads the file that CLI wrote.

| Directory | What lives there |
| :--- | :--- |
| [`measure/`](measure/) | The two harnesses: seconds per image and per clip |
| [`release/`](release/) | Turning a run into a committed evidence page |
| [`lint.sh`](lint.sh) | Every linter at a pinned version, run by hand and by CI |

## Rules

- **Python 3 standard library only.** No install step, so any contributor can run
  a check.
- **A harness has a `--selftest`** that runs offline, and
  [`../test/test.sh`](../test/test.sh) calls it.
- **The output is the evidence.** A harness measures the file it wrote — the PNG
  header, or `ffprobe` — never the runner's own log line.
- **One GPU.** A harness refuses to start while another GPU job is active; that
  guard is a feature, not an obstacle.

The text benchmark's scripts live in the
[companion repository](https://github.com/mahirfatih/omlx-m1-max-benchmark).
