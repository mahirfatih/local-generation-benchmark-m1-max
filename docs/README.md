# docs

The written record behind the numbers. The top-level
[`README.md`](../README.md) is the quick tour; start here when you want the
reasoning behind a figure, a setting or a licence reading.

| Document | The question it answers |
| :--- | :--- |
| [`reference/COMPARISON.md`](reference/COMPARISON.md) | Which layer, which model, for what — both layers on one page, every figure traced. |
| [`reference/PROFILES.md`](reference/PROFILES.md) | What settings each layer runs with, why each value, and the exact commands to reproduce a run. |
| [`reference/LICENSES.md`](reference/LICENSES.md) | What may be done with each model's output — "downloadable" is not "commercially usable". |
| [`reference/ENVIRONMENT.md`](reference/ENVIRONMENT.md) | What it all ran on: the stack from Metal to the harness, a clean-macOS install, which binary each profile calls, and the four failures that look like something else. |

## How the two documents differ

- **COMPARISON.md** is the answer to a choice: it puts image and video side by
  side and says which to reach for. It is short and every row points at the run
  it came from.
- **PROFILES.md** is the answer to "how was it run": it carries the tables of
  settings, the reasoning, and the copy-pasteable commands, including the two
  traps already hit here (`quick_infer.py`'s default model path, and the uneven
  CogVideoX download).

## Where the detail is not

There is no `docs/reference/MODELS.md` and no results page here: the model
inventory and the text results belong to the
[companion repository](https://github.com/mahirfatih/omlx-m1-max-benchmark). This
repository documents two generation layers and nothing else.
