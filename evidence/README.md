# evidence

The runs, committed so a claim can be checked by looking rather than by trusting
a number.

| Page | Layer | What is in it |
| :--- | :--- | :--- |
| [`image-benchmark-2026-11-12.md`](image-benchmark-2026-11-12.md) | mflux / klein-q8 | 8 images, each with its prompt and its seconds |
| [`image-benchmark-flux3-2026-11-12.md`](image-benchmark-flux3-2026-11-12.md) | mflux / FLUX 3 | The same, for the second model |
| [`image-benchmark-zimage-2026-11-14.md`](image-benchmark-zimage-2026-11-14.md) | mflux / Z-Image Turbo | The same, for the third model |
| [`image-benchmark-klein-q4-2026-11-17.md`](image-benchmark-klein-q4-2026-11-17.md) | mflux / klein-q4 | The same, for the fourth model |
| [`image-benchmark-qwen.md`](image-benchmark-qwen.md) | mlx-gen / qwen-image-4bit | 8 images at **1024×1024**, each with its prompt and its seconds — the first mlx-gen profile with a benchmark row |
| [`video-benchmark-2026-11-12.md`](video-benchmark-2026-11-12.md) | VideoX-Fun-mlx / mlx-gen | 18 clips over 3 models and 6 prompts, each with its prompt, its seconds and its `ffprobe` reading |

The outputs themselves sit beside the pages:

- [`images/`](images/) — 40 PNGs, named `<profile>--<prompt-id>.png`
- [`videos/`](videos/) — 18 clips (4 GIF batches and 2 MP4 batches) named
  `<profile>--<prompt-id>`: six CogVideoX int8 and six int4 GIFs, and six Wan2.2
  MP4s

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
