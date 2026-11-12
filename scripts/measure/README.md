# `scripts/measure/` — the measurements

What produces the numbers. Each script drives one external tool, times it end to
end, and measures the file it wrote.

| Script | Measures | Needs a model |
| :--- | :--- | :---: |
| [`image-benchmark.py`](image-benchmark.py) | Seconds per image through [`mflux`](https://github.com/filipstrand/mflux), from `profiles/mflux-profiles.json`; the PNG is checked via its IHDR header. Refuses to run while another GPU job is active. `--selftest` is offline. | yes |
| [`video-benchmark.py`](video-benchmark.py) | Seconds per clip through [`VideoX-Fun-mlx`](https://github.com/dgrauet/VideoX-Fun-mlx) or [`mlx-gen`](https://github.com/lpalbou/mlx-gen), from `profiles/video-profiles.json`; the written clip is measured with **ffprobe**. Refuses to run while another GPU job is active. `--selftest` is offline. | yes |

Neither is part of oMLX: oMLX serves text, and the two generation layers are
separate tools. Both harnesses watch for **any** GPU-heavy process — the text
benchmark's scripts included — because one machine has one GPU.

## Running

```bash
python3 scripts/measure/image-benchmark.py --selftest
python3 scripts/measure/image-benchmark.py --profile klein-q8 --out-dir ./out
python3 scripts/measure/image-benchmark.py --all-profiles

python3 scripts/measure/video-benchmark.py --selftest
python3 scripts/measure/video-benchmark.py \
  --profile cogvideox-fun-1.5-5b-inp-q8 \
  --repo ~/Sites/VideoX-Fun-mlx \
  --model ~/Sites/VideoX-Fun-mlx/models/cogvideox-fun-q8 \
  --out-dir /tmp/videorun --json-out /tmp/videorun/results.json
```

Both write Markdown by default and JSON with `--json-out`. The JSON path is what
`reference/` holds; the Markdown is what `evidence/` holds. `--limit N` runs the
first N prompts, which is how a single clip is re-timed without redoing the set.
