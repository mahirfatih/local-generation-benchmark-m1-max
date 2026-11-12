# `scripts/release/` — turning a run into a committed page

A harness writes Markdown and JSON. The script here turns a **re-run** of the
video suite into the evidence page that ships, so the page always matches the
clips it embeds.

| Script | Does |
| :--- | :--- |
| [`export-video-evidence.py`](export-video-evidence.py) | Reads a `video-benchmark.py --json-out` file and writes `evidence/video-benchmark-<date>.md`, copying each clip into `evidence/videos/` and quoting its prompt verbatim. |

## Why it exists

The video harness can write its own page, but a clip is measured with `ffprobe`
from the file on disk. This exporter re-reads the finished clip and writes the
frame count, size and duration it finds there — so the page cannot claim a frame
count the GIF does not have. It is the `Saved N frames` problem, closed at the
export step.

## Running

```bash
python3 scripts/release/export-video-evidence.py \
  --run reference/video-benchmark.json \
  --out evidence/video-benchmark-2026-11-12.md \
  --clips-dir evidence/videos
```

`--source-dir` overrides where the raw clips are read from when they are not
already beside the JSON. The image pages are written directly by
`image-benchmark.py`, so there is no exporter for them.
