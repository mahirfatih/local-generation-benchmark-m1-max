# reference

Machine-readable copies of every number this repository states. A figure in a
document should trace here, and `test/test.sh` step 9 recomputes the headline
figures from these files to prove it does.

| File | Produced by | What it holds |
| :--- | :--- | :--- |
| [`image-benchmark.json`](image-benchmark.json) | `scripts/measure/image-benchmark.py --profile klein-q8` | 8 images: seconds, PNG dimensions, bytes, sha256 |
| [`image-benchmark-flux3.json`](image-benchmark-flux3.json) | `scripts/measure/image-benchmark.py --profile flux3-klein-q8` | The same, for FLUX 3 |
| [`video-benchmark.json`](video-benchmark.json) | `scripts/measure/video-benchmark.py --profile cogvideox-fun-1.5-5b-inp-q8` | 4 clips: seconds, `ffprobe` output, bytes, sha256 |

## What each record carries

Every run records the model, the profile, the licence, the runner, and per item:
`seconds`, `returncode`, `ok`, the output path, its size and a short SHA-256, and
the tail of the runner's own stderr. The video records also carry the `ffprobe`
result — codec, size, **frame count**, frame rate, duration — because the
runner's `Saved N frames` line is unreliable and the file is not.

## Two conventions, both checked

- **Paths are repository-relative** (`evidence/images/klein-q8--text-poster.png`),
  never an absolute path from the machine that ran it. The split out of the text
  repository left a frozen `/Users/.../omlx-m1-max-benchmark/...` path in two of
  these files; step 9 now fails if it happens again.
- **`s/img` is the mean after the first image** (the first pays the one-time
  model load), and **`s/clip` is the mean of all clips**. Step 9 recomputes both
  and fails if a document quotes a figure the data does not support.
