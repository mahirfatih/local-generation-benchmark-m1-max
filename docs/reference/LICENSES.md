# Model licences — download is not a licence

Every model in this benchmark runs **locally**: no account, no API key, no per-call
bill. That is a property of where it runs, not a grant of rights. The weights carry
their own terms, and **"downloadable" and "commercially usable" are not the same
thing**. This file records what each model's own card says, so a reader can tell a
truly open model from a source-available one before shipping it into something
that earns money.

This is a reading of the published terms on Hugging Face. The original five rows
were re-read on **2026-11-12**; the rows for Anima Turbo, `klein-base`, ERNIE, Qwen,
Bonsai, Iris and Boogu record what each card said when its profile was added. It is a summary,
not legal advice; the licence text on each page is the authority.

## Image models (run by mflux)

| Model | Upstream base | Declared licence | Commercial use of outputs | Note |
| :--- | :--- | :--- | :--- | :--- |
| `mflux-community/flux2-klein-4b-mflux-q8` | `black-forest-labs/FLUX.2-klein-4B` | **Apache-2.0** | yes | Clean; no output restrictions beyond Apache-2.0's own. |
| `Runpod/FLUX.2-klein-4B-mflux-4bit` | `black-forest-labs/FLUX.2-klein-4B` | **Apache-2.0** | yes | The 4-bit quant of the same model, nothing added. |
| `mflux-community/flux-2-klein-base-4b-mflux-q8` | `black-forest-labs/FLUX.2-klein-base-4B` | **Apache-2.0** | yes | The non-distilled twin of FLUX.2 klein, same terms. |
| `mflux-community/anima-turbo-mflux-q8` | `circlestone-labs/Anima` | **Circlestone Labs non-commercial licence** | **no** | Not open source and not "free to use": non-commercial only. See below. |
| `mflux-community/z-image-turbo-mflux-q4` | `Tongyi-MAI/Z-Image-Turbo` | **Apache-2.0** | yes | Clean; no output restrictions beyond Apache-2.0's own. Inherited from the base model. |
| `mflux-community/flux-3-image-klein-base-mflux-q8` | `black-forest-labs/flux-3-image-klein-base` | **FLUX Kommunity License v1.0** | **only under US$5M revenue** | Not open source. See below. |
| `mflux-community/iris-3b-turbo-mflux-q8` | `speridlabs/iris-3b` | **Apache-2.0** | yes | Clean; the community quant inherits the base licence unchanged. Pixel-space model, no VAE. |
| `mflux-community/boogu-image-turbo-mflux-q8` | `Boogu/Boogu-Image-0.1-Turbo` | **Apache-2.0** | yes | Clean; the 10B checkpoint and its MLX quant are both Apache-2.0. |

## Image models (run by mlx-gen)

These are image models, so they live in `profiles/mflux-profiles.json`, but they
run through `mlxgen generate` rather than an `mflux-generate-*` script. The runner
does not change the licence.

| Model | Upstream base | Declared licence | Commercial use of outputs | Note |
| :--- | :--- | :--- | :--- | :--- |
| `AbstractFramework/ernie-image-turbo-8bit` | `baidu/ERNIE-Image-Turbo` | **Apache-2.0** | yes | Inherited from the source model. |
| `AbstractFramework/qwen-image-4bit` | `Qwen/Qwen-Image` | **Apache-2.0** | yes | Mixed q4/q8 saved weights; licence unchanged by the quant. |
| `prism-ml/bonsai-image-ternary-4B-mlx-2bit` | `prism-ml/bonsai-image-ternary-4B-unpacked` | **Apache-2.0** | yes | Apache-2.0 like its base. It **does not run** on `mlx-gen 0.38.0`, but the licence is unaffected. |

## Video models (run by VideoX-Fun-mlx, and the Wan2.2 layer by mlx-gen)

**The same tag trap appears here:** the quantised CogVideoX-Fun repositories are
labelled `apache-2.0`, but the model they are built from is not Apache-2.0 at all.

| Model | Upstream base | Declared licence | Commercial use of outputs | Note |
| :--- | :--- | :--- | :--- | :--- |
| `dgrauet/CogVideoX-Fun-V1.5-5b-InP-mlx-q8` | `alibaba-pai/CogVideoX-Fun-V1.5-5b-InP` | **tagged `apache-2.0`, actually the CogVideoX License** | **academic free; commercial needs registration** | Do **not** trust the `apache-2.0` tag on the quant. See below. |
| `dgrauet/CogVideoX-Fun-V1.5-5b-InP-mlx-q4` | `alibaba-pai/CogVideoX-Fun-V1.5-5b-InP` | **tagged `apache-2.0`, actually the CogVideoX License** | **academic free; commercial needs registration** | Same base as the q8, same terms. 13 GB, 247.7 s/clip. |
| `AbstractFramework/wan2.2-ti2v-5b-diffusers-8bit` | `Wan-AI/Wan2.2-TI2V-5B-Diffusers` | **Apache-2.0** | yes | Clean, and the only measured video profile that is Apache-2.0 outright. Text- and image-to-video, 5B. |

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

## The Anima case — the smallest file is the one you cannot ship

Anima Turbo is the smallest package in the benchmark (4.0 GB) and has the cheapest
step at 4.6 s/step, which makes it the obvious first choice until the licence is
read.
The upstream model, `circlestone-labs/Anima`, is released under the **Circlestone
Labs non-commercial licence**, and the MFlux-Community Q8 conversion inherits it
unchanged — a community conversion cannot loosen the terms of what it converts.

- **Non-commercial only.** There is no revenue threshold to clear and no
  registration that unlocks commercial use, unlike FLUX 3 or CogVideoX.
- **The quant's card is not a new grant.** It republishes the weights; the
  `LICENSE.md` on the base model is the authority.
- **Nothing about running locally changes this.** No account, no API key and no
  per-call bill is a property of where it runs, not a licence.

For a commercial pipeline the Apache-2.0 image rows (`klein` q4/q8, `klein-base`,
Z-Image Turbo, ERNIE, Qwen) are the ones that carry no output restriction at all.

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
- **A non-commercial licence is not a free trial.** Anima's terms carry no revenue
  threshold and no registration path: either the use is non-commercial or it is
  outside the licence.
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
- FLUX.2 klein q4: <https://huggingface.co/Runpod/FLUX.2-klein-4B-mflux-4bit>
  (base model: <https://huggingface.co/black-forest-labs/FLUX.2-klein-4B>)
- FLUX.2 klein base q8: <https://huggingface.co/mflux-community/flux-2-klein-base-4b-mflux-q8>
- Anima Turbo q8: <https://huggingface.co/mflux-community/anima-turbo-mflux-q8>
  (base model and licence: <https://huggingface.co/circlestone-labs/Anima>)
- Z-Image Turbo q4: <https://huggingface.co/mflux-community/z-image-turbo-mflux-q4>
  (base model: <https://huggingface.co/Tongyi-MAI/Z-Image-Turbo>)
- FLUX 3 klein q8: <https://huggingface.co/mflux-community/flux-3-image-klein-base-mflux-q8>
- ERNIE Image Turbo 8-bit: <https://huggingface.co/AbstractFramework/ernie-image-turbo-8bit>
- Qwen Image 4-bit: <https://huggingface.co/AbstractFramework/qwen-image-4bit>
- Bonsai Image ternary 2-bit: <https://huggingface.co/prism-ml/bonsai-image-ternary-4B-mlx-2bit>
- CogVideoX-Fun quant: <https://huggingface.co/dgrauet/CogVideoX-Fun-V1.5-5b-InP-mlx-q8>
- CogVideoX-Fun base: <https://huggingface.co/alibaba-pai/CogVideoX-Fun-V1.5-5b-InP>
- Wan2.2 TI2V-5B: <https://huggingface.co/Wan-AI/Wan2.2-TI2V-5B-Diffusers>
