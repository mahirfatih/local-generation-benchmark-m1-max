# data

The prompt sets, one JSON per generation layer. They are here rather than inline
in the harnesses so a prompt can be read, quoted and reproduced without opening a
`.py` file.

| File | Layer | Prompts |
| :--- | :--- | ---: |
| [`image-prompts.json`](image-prompts.json) | mflux (image) | 8 |
| [`video-prompts.json`](video-prompts.json) | VideoX-Fun-mlx (video) | 4 |

## Shape

Each file carries a `categories` list and a `prompts` list. Every prompt has a
stable `id`, a `category` that must appear in `categories`, and the `prompt`
text. The `id` is what names the output file, so `text-poster` produces
`klein-q8--text-poster.png`.

## Why these prompts

The image set covers the surfaces that separate image models: photorealism,
hands, legible text, composition and style. The video set asks for motion a
still cannot show — a gallop, an orbit, a pour, weather — because a video model
that only produces a drifting still has not produced a video.

Both are small on purpose. Eight and four prompts are enough to show an 8× gap
and a 265 s-per-clip cost; a gap of a second or two is noise and the sample sizes
are stated wherever the results are.

## Adding a prompt

Add it with a unique `id` and a `category` that exists. `test/test.sh` step 2 and
3 fail if an id repeats, a prompt is empty, or a category is undeclared. Then run
the layer to produce the output — a prompt with no committed output is a claim
without evidence.
