# test

The offline gate. Everything here runs with Python 3 standard library only, no
model, no download and no network.

```bash
./test/test.sh
./test/test.sh --fast
```

## Every step, and what it proves

| Step | Checks | Catches |
| :--- | :--- | :--- |
| 1 | `py_compile` / `ast.parse` over `scripts/` | a syntax error |
| 2 | [`../data/image-prompts.json`](../data/image-prompts.json) | a duplicate id, an empty prompt, an undeclared category |
| 3 | [`../data/video-prompts.json`](../data/video-prompts.json) | the same, for video |
| 4 | [`../profiles/`](../profiles/) | a profile with no licence, no settings or no command |
| 5 | every `![...](...)` in [`../evidence/`](../evidence/) | a page pointing at an image or clip that is not there |
| 6 | [`../docs/reference/LICENSES.md`](../docs/reference/LICENSES.md) | the licence warning being dropped, so a gated model looks open |
| 7 | [`image-benchmark.py --selftest`](../scripts/measure/image-benchmark.py) | a command the harness builds that the PNG reader disagrees with |
| 8 | [`video-benchmark.py --selftest`](../scripts/measure/video-benchmark.py) | a command the harness builds that the `ffprobe` reader disagrees with |
| 9 | [`../reference/`](../reference/) | an absolute path in a committed result, or a headline figure the data does not support |

## What is deliberately **not** here

The real measurements need a downloaded model and a free GPU, so they are not in
this suite:

- [`../scripts/measure/image-benchmark.py`](../scripts/measure/image-benchmark.py)
  without `--selftest`
- [`../scripts/measure/video-benchmark.py`](../scripts/measure/video-benchmark.py)
  without `--selftest`
- [`../scripts/release/export-video-evidence.py`](../scripts/release/export-video-evidence.py)

They are run by hand on the host, and their outputs are committed under
[`../evidence/`](../evidence/) and [`../reference/`](../reference/). The suite
gates what it can gate offline; it does not pretend to reproduce a GPU.

## The whole suite

The consecutive steps are what CI runs — see
[`../.github/workflows/ci.yml`](../.github/workflows/ci.yml) — so a pull request
that breaks a link or a figure fails before review.

## Full lint

`test.sh` is the correctness gate. Whitespace, prose and YAML style are a separate
run: [`../scripts/lint.sh`](../scripts/lint.sh).
