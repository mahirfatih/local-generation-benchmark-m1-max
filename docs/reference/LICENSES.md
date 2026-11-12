# Model licences — download is not a licence

Every model in this benchmark runs **locally**: no account, no API key, no per-call
bill. That is a property of where it runs, not a grant of rights. The weights carry
their own terms, and **"downloadable" and "commercially usable" are not the same
thing**. This file records what each model's own card says, so a reader can tell a
truly open model from a source-available one before shipping it into something
that earns money.

This is a reading of the published terms on Hugging Face, retrieved **2026-11-12**.
It is a summary, not legal advice; the licence text on each page is the authority.

## Image models (run by mflux)

| Model | Upstream base | Declared licence | Commercial use of outputs | Note |
| :--- | :--- | :--- | :--- | :--- |
| `mflux-community/flux2-klein-4b-mflux-q8` | `black-forest-labs/FLUX.2-klein-4B` | **Apache-2.0** | yes | Clean; no output restrictions beyond Apache-2.0's own. |
| `mflux-community/flux-3-image-klein-base-mflux-q8` | `black-forest-labs/flux-3-image-klein-base` | **FLUX Kommunity License v1.0** | **only under US$5M revenue** | Not open source. See below. |

## Video models (run by VideoX-Fun-mlx, and the Wan2.2 layer by mlx-gen)

**The same tag trap appears here:** the quantised CogVideoX-Fun repository is
labelled `apache-2.0`, but the model it is built from is not Apache-2.0 at all.

| Model | Upstream base | Declared licence | Commercial use of outputs | Note |
| :--- | :--- | :--- | :--- | :--- |
| `dgrauet/CogVideoX-Fun-V1.5-5b-InP-mlx-q8` | `alibaba-pai/CogVideoX-Fun-V1.5-5b-InP` | **tagged `apache-2.0`, actually the CogVideoX License** | **academic free; commercial needs registration** | Do **not** trust the `apache-2.0` tag on the quant. See below. |
| `Wan-AI/Wan2.2-TI2V-5B-Diffusers` | — | **Apache-2.0** | yes | Clean. Text- and image-to-video, 720P@24fps, 5B. Download not completed in this run. |

### The CogVideoX-Fun case

The quant card says `apache-2.0`; the base model's `LICENSE` is **The CogVideoX
License**, which is where the real terms live:

- **Academic research is free.** Commercial use requires **registering for a basic
  commercial licence** (<https://open.bigmodel.cn/mla/form>); once registered it is
  free, but the commercial service must stay **under 1 million visits per month**,
  above which a separate licence is needed.
- Generation IP belongs to the user "to the extent permitted by applicable local
  laws". Military and illegal uses are banned, with China-specific restrictions.
- It is governed by the **laws of the People's Republic of China**, disputes to the
  Haidian District People's Court in Beijing.

So the licence *tag* on the quant contradicts the licence that actually applies.
Follow the base model.

## The FLUX 3 case — the reason this file exists

FLUX 3 Image Klein is released under the **FLUX Kommunity License v1.0**. It is not
Apache-2.0 like FLUX.2 klein, and the difference is not cosmetic:

- **Outputs are yours.** §1.a: outputs are not "Derivatives". §2.d: *"We claim no
  ownership rights in and to the Outputs."* The image a user generates belongs to the
  user.
- **Commercial use of those outputs is capped by revenue.** §2.a grants commercial
  output use only to a *Qualifying User*: §1.e, you plus affiliates under
  **US$5M gross annualized revenue**. Above that, a paid licence is required (§2.b,
  <https://bfl.ai/licensing>).
- **Some uses are off-limits at any revenue.** §4 bans military, surveillance,
  biometric processing, rights-infringing, unlawful, CSAM and non-consensual-intimate
  uses, and §4.b forbids using the model or its outputs to improve a competing model.
- **Attribution travels with the weights.** §3 requires the Attribution Notice if the
  weights or a derivative are redistributed (not when an image is generated).

Read the full text in
[`LICENSE.md`](https://huggingface.co/black-forest-labs/flux-3-image-klein-base/blob/main/LICENSE.md).

## How to read the columns

- **Apache-2.0** means the weights may be used, modified and distributed, including
  commercially, with attribution. This is the only licence here that is unconditionally
  permissive.
- **A licence tag can contradict its own base.** The CogVideoX quant is tagged
  `apache-2.0` yet derives from a model under the CogVideoX License. When the two
  disagree, follow the base model's `LICENSE` file.

## This repository's own licence

The benchmark **code and documents** here are MIT (see [`../../LICENSE`](../../LICENSE)).
That covers this repository, not the models it measures: the model licences above are
the property of their authors and travel with the weights, not with this repo. Nothing
here redistributes model weights.

## Sources

- FLUX.2 klein q8: <https://huggingface.co/mflux-community/flux2-klein-4b-mflux-q8>
- FLUX 3 klein q8: <https://huggingface.co/mflux-community/flux-3-image-klein-base-mflux-q8>
- CogVideoX-Fun quant: <https://huggingface.co/dgrauet/CogVideoX-Fun-V1.5-5b-InP-mlx-q8>
- CogVideoX-Fun base: <https://huggingface.co/alibaba-pai/CogVideoX-Fun-V1.5-5b-InP>
- Wan2.2 TI2V-5B: <https://huggingface.co/Wan-AI/Wan2.2-TI2V-5B-Diffusers>
