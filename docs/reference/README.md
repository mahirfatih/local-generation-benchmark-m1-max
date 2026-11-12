# `docs/reference/` — what is in it right now

The facts: every model, every profile, every measured number for the two
generation layers. Written from the data the scripts produced, not generated, but
easy to re-derive.

- [`COMPARISON.md`](COMPARISON.md) — **the single page to start from**: which
  layer, which model, for what, with every figure traced to the run file it came
  from and the averaging rule stated.
- [`PROFILES.md`](PROFILES.md) — every image and video setting, why each value,
  and the commands to reproduce a run.
- [`LICENSES.md`](LICENSES.md) — the terms on each model's output, and the two
  traps: FLUX 3's US$5M revenue cap and the CogVideoX quant's misleading tag.

## Provenance of these numbers

| Number | Comes from | Command |
| :--- | :--- | :--- |
| Seconds per image | `reference/image-benchmark*.json` | `python3 scripts/measure/image-benchmark.py --profile <p>` |
| Seconds per clip | `reference/video-benchmark.json` | `python3 scripts/measure/video-benchmark.py --profile <p>` |
| Clip frames / size | the written GIF, via `ffprobe` | (recorded in the JSON as `probe`) |
| Licences | the Hugging Face model cards | (read by hand, dated in the doc) |

`test/test.sh` step 9 recomputes the headline figures from these files, so a
document cannot drift from the data it cites. The text numbers — tokens per
second, coding, hallucination, red-team — are in the
[companion repository](https://github.com/mahirfatih/omlx-m1-max-benchmark);
oMLX cannot generate an image or a clip, which is why they are apart.
