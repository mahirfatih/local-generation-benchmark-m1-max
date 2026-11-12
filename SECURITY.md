# Security

This repository runs local generation models. Its security story is smaller than
a network service's, but it is not empty.

## Secrets

**No API key, token or private key is committed**, and no generation tool here
needs one. The harnesses call a local CLI; there is no remote endpoint and no
authentication material anywhere in the tree.

If you fork this and add a hosted backend, keep its key out of the repository. A
pre-commit check is cheap:

```bash
grep -rnE "hf_[A-Za-z0-9]{20,}|sk-[A-Za-z0-9]{20,}|Bearer [A-Za-z0-9]{20,}" . --exclude-dir=.git
```

The only path that reaches the network is a model download, and that is a
one-time `curl` or a runner's own command, not something a script here performs.

## Licence hygiene is a security-adjacent control

The models here are **not all open**. Two are capped or gated:

- **FLUX 3 Image Klein** — the FLUX Kommunity License, commercial output use
  limited to under **US$5M** revenue.
- **CogVideoX-Fun** — the quant is tagged `apache-2.0`, but its base model is
  under **The CogVideoX License** (academic free, commercial registration-gated).

Shipping output from one of these into a commercial product without checking
[`docs/reference/LICENSES.md`](docs/reference/LICENSES.md) is the mistake this
repository exists to prevent. It is not a CVE, but it is the risk that actually
bites.

## Running these tools

- The harnesses are designed to run on **your own machine**. They read and write
  files under this repository and execute the local `mflux` / video runner CLI.
- `quick_infer.py` defaults its `--model-path` to the uploader's own machine
  (`/Users/dgrauet/...`). Always pass your own path; a wrong one is a confusing
  failure, not a compromise.
- **Never run two generation jobs at once** on a 64 GB M1 Max. Both harnesses
  refuse to start while another GPU job is active; that guard protects the
  hardware and the validity of the measurement, not just the numbers.

## Reporting

A security issue in **this repository** (a leaked secret in history, a path that
could be abused): email `irtibat@mahirfatih.com`. Do not open a public issue for
a live leak. An issue in a model or a runner belongs upstream — `mflux`,
[`VideoX-Fun-mlx`](https://github.com/dgrauet/VideoX-Fun-mlx) or
[`mlx-gen`](https://github.com/lpalbou/mlx-gen).
