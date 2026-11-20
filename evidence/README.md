# evidence

The runs, committed so a claim can be checked by looking rather than by trusting
a number.

| Page | Layer | What is in it |
| :--- | :--- | :--- |
| [`image-benchmark-2026-11-12.md`](image-benchmark-2026-11-12.md) | mflux / klein-q8 | 8 images, each with its prompt and its seconds |
| [`image-benchmark-flux3-2026-11-12.md`](image-benchmark-flux3-2026-11-12.md) | mflux / FLUX 3 | The same, for the second model |
| [`image-benchmark-zimage-2026-11-14.md`](image-benchmark-zimage-2026-11-14.md) | mflux / Z-Image Turbo | The same, for the third model |
| [`image-benchmark-klein-q4-2026-11-17.md`](image-benchmark-klein-q4-2026-11-17.md) | mflux / klein-q4 | The same, for the fourth model |
| [`video-benchmark-2026-11-12.md`](video-benchmark-2026-11-12.md) | VideoX-Fun-mlx | 4 clips, each with its prompt, its seconds and its `ffprobe` reading, plus a 2-clip quality check outside the timed rows |

The outputs themselves sit beside the pages:

- [`images/`](images/) — 32 PNGs, named `<profile>--<prompt-id>.png`
- [`videos/`](videos/) — 12 clips: 4 GIFs and 4 MP4s over `<profile>--<prompt-id>`,
  and 2 more (a GIF and an MP4) named `<profile>--snowy-fox-s42` for the quality
  check the timed prompt set cannot carry

Every prompt is quoted **verbatim** under its output, so a page can be read
without opening the JSON. Each file is named with the date it was produced.

## Regenerating

```bash
python3 scripts/measure/image-benchmark.py \
  --profile klein-q8 --out evidence/image-benchmark-<date>.md \
  --json-out reference/image-benchmark.json

python3 scripts/measure/video-benchmark.py \
  --profile cogvideox-fun-1.5-5b-inp-q8 \
  --repo ~/Sites/VideoX-Fun-mlx --model ~/Sites/VideoX-Fun-mlx/models/cogvideox-fun-q8 \
  --out evidence/video-benchmark-<date>.md --json-out reference/video-benchmark.json
```

Both need a downloaded model and a free GPU, so they are **not** part of
[`../test/test.sh`](../test/test.sh). The suite checks what it can offline: that
every asset a page embeds exists (step 5), and that the figures trace to the data
(step 9).

## A note on the video page

The runner prints `Saved N frames`, and it is wrong: `--frames 8` logs "Saved 8
frames" while the file holds 5. The page reports the **`ffprobe`** count, read
from the written GIF, not that line.
