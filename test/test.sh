#!/usr/bin/env bash
#
# Every check this repository has that needs no model and no network.
#
#     ./test/test.sh              # everything
#     ./test/test.sh --fast       # skip the full py_compile sweep
#
# Python 3 standard library only, no install step. A benchmark repository's
# checks should be runnable by anybody who opened a pull request.

set -euo pipefail

cd "$(dirname "$0")/.."

FAST=0
for arg in "$@"; do
    case "$arg" in
        --fast) FAST=1 ;;
        -h|--help) sed -n '2,8p' "$0"; exit 0 ;;
        *) echo "unknown option: $arg" >&2; exit 2 ;;
    esac
done

step() { printf '\n\033[1m== %s\033[0m\n' "$1"; }

step "1. Python syntax"
if [ "$FAST" -eq 0 ]; then
    python3 -m py_compile scripts/*/*.py
fi
python3 - <<'PY'
import ast, pathlib, sys
bad = 0
for p in pathlib.Path("scripts").rglob("*.py"):
    try:
        ast.parse(p.read_text())
    except SyntaxError as e:
        print(f"{p}: {e}")
        bad += 1
sys.exit(1 if bad else 0)
PY
echo "scripts parse"

step "1b. Naming — source and data files are kebab-case"
python3 scripts/checks/check-naming.py

step "2. Image prompts — every one is complete and the ids are unique"
python3 - <<'PY'
import json, pathlib
d = json.loads(pathlib.Path("data/image-prompts.json").read_text())
prompts = d["prompts"]
ids = [p["id"] for p in prompts]
assert len(ids) == len(set(ids)), "duplicate image prompt ids"
for p in prompts:
    assert p.get("prompt"), f"{p['id']} has no prompt text"
    assert p.get("category") in d["categories"], f"{p['id']} has an unknown category"
print(f"{len(prompts)} image prompts, {len(d['categories'])} categories")
PY

step "3. Video prompts — every one is complete and the categories are declared"
python3 - <<'PY'
import json, pathlib
d = json.loads(pathlib.Path("data/video-prompts.json").read_text())
prompts = d["prompts"]
ids = [p["id"] for p in prompts]
assert len(ids) == len(set(ids)), "duplicate video prompt ids"
for p in prompts:
    assert p.get("prompt"), f"{p['id']} has no prompt text"
    assert p.get("category") in d["categories"], f"{p['id']} has an unknown category"
print(f"{len(prompts)} video prompts, {len(d['categories'])} categories")
PY

step "4. Profiles — every generation profile names a licence and its settings"
python3 - <<'PY'
import json, pathlib
for name, path in (("image", "profiles/mflux-profiles.json"),
                   ("video", "profiles/video-profiles.json")):
    d = json.loads(pathlib.Path(path).read_text())
    gens = d["generation_profiles"]
    assert gens, f"{path} has no generation profiles"
    for key, prof in gens.items():
        assert prof.get("license"), f"{key} has no licence"
        assert prof.get("settings"), f"{key} has no settings block"
        # image profiles name a CLI; video profiles carry the full argv
        assert prof.get("cli") or prof.get("invoke"), f"{key} has no command"
    print(f"{name}: {len(gens)} profiles, each with a licence, settings and a command")
PY

step "4b. Profiles — a source link names the profile's own model"
python3 - <<'PY'
import json, pathlib
# A profile's `sources[0]` is the checkpoint it was benchmarked on, so it must
# be that profile's model — not the sibling quant's. The q4 CogVideoX profile
# shipped the q8 URL: both repos exist, both are valid links, and a reader
# following the row lands on a different precision than the one measured.
# Step 11 cannot see this, because it reads the HF links out of README.md.
for path in ("profiles/mflux-profiles.json", "profiles/video-profiles.json"):
    gens = json.loads(pathlib.Path(path).read_text())["generation_profiles"]
    for key, prof in gens.items():
        model = prof.get("model")
        sources = prof.get("sources", [])
        assert sources, f"{key} has no sources"
        if not model or "/" not in model:
            continue
        assert any(s.rstrip("/").endswith(model) for s in sources), (
            f"{key}: no source links to its own model {model}\n"
            + "\n".join(f"    {s}" for s in sources)
        )
    print(f"{path}: every profile links to its own model")
PY

step "5. Evidence — every clip and image named in the evidence pages exists"
python3 - <<'PY'
import pathlib, re, sys
pages = list(pathlib.Path("evidence").glob("*.md"))
missing = []
for page in pages:
    for target in re.findall(r"!\[[^\]]*\]\(([^)]+)\)", page.read_text()):
        if target.startswith(("http://", "https://")):
            continue
        if not (page.parent / target).exists():
            missing.append(f"{page}: {target}")
for m in missing:
    print(m)
sys.exit(1 if missing else 0)
print(f"every embedded asset in {len(pages)} evidence pages resolves")
PY

step "6. Licences — downloadable is not the same as usable"
python3 - <<'PY'
import json, pathlib
text = pathlib.Path("docs/reference/LICENSES.md").read_text()
for needle in ("FLUX Kommunity License", "CogVideoX", "Apache-2.0"):
    assert needle in text, f"licences doc no longer mentions: {needle}"

# Every profile needs a row here, not just the gated ones. The table was written
# when five models were measured and stayed at five while seven more were added:
# `anima-turbo-q8` is non-commercial outright, with no revenue threshold and no
# registration path, and it appeared in no licence table at all. A reader who
# opened only this page could have shipped it, so the check is coverage, not
# keywords.
#
# It reads the first cell of each table row, not the file: the model id also
# appears in the source list at the bottom, so a plain substring test passes on a
# document whose table has lost the row — which is how the first version of this
# check failed to notice the row it was written for.
rows = {
    line.split("|")[1].strip().strip("`")
    for line in text.splitlines()
    if line.startswith("|")
}
checked = 0
for path in ("profiles/mflux-profiles.json", "profiles/video-profiles.json"):
    for key, prof in json.loads(pathlib.Path(path).read_text())["generation_profiles"].items():
        model = prof["model"]
        assert model in rows, f"{key}: no licence row for {model} in LICENSES.md"
        checked += 1
print(f"licences documented; all {checked} profiles have a row, the conditional ones are flagged")
PY

step "7. Image harness — the mflux command and the PNG reader agree"
python3 scripts/measure/image-benchmark.py --selftest

step "8. Video harness — the runner command and the ffprobe reader agree"
python3 scripts/measure/video-benchmark.py --selftest

step "9. Reference data — relative paths, and the headline figures match it"
python3 - <<'PY'
import json, pathlib, re, statistics, sys

rows = {}
for f in sorted(pathlib.Path("reference").glob("*.json")):
    d = json.loads(f.read_text())
    rows[f.name] = d

bad = []

# 1. A committed result must not carry a machine-specific absolute path. The
#    files move (this repository was split out of another one) and a frozen
#    /Users/<someone>/... path is broken the moment they do.
for name, d in rows.items():
    for row in d["rows"]:
        for key in ("images", "videos"):
            for item in row.get(key, []):
                for field in ("image", "video"):
                    v = item.get(field, "")
                    if v.startswith("/"):
                        bad.append(f"{name}: {item.get('id')} {field} is absolute: {v}")

# 2. The s/img and s/clip figures the documents quote must be derivable from the
#    raw data, and under the same definition the documents state: s/img is the
#    mean with the first (model-load) image dropped, s/clip the mean of all.
#
#    The tolerance is 0.05 s, not 0.5: the documents round to one decimal, so
#    0.05 is the widest a correct rounding can be off. A looser bound hid a real
#    error — flux3 was published as 180.4 while the data gives 180.55 — because
#    the drift fit inside it. A figure that does not round to the stated one is
#    a wrong figure, not a rounding difference.
TOLERANCE = 0.05


def image_mean(name):
    ts = [i["seconds"] for i in rows[name]["rows"][0]["images"]]
    return statistics.mean(ts[1:])

def clip_mean(name):
    ts = [v["seconds"] for v in rows[name]["rows"][0]["videos"]]
    return statistics.mean(ts)

checks = [
    ("image-benchmark.json", image_mean, 24.0),
    ("image-benchmark-flux3.json", image_mean, 180.6),
    ("image-benchmark-klein-q4.json", image_mean, 23.0),
    ("image-benchmark-qwen.json", image_mean, 124.9),
    ("image-benchmark-ernie.json", image_mean, 123.5),
    ("image-benchmark-anima.json", image_mean, 36.4),
    ("image-benchmark-klein-base.json", image_mean, 97.1),
    ("image-benchmark-zimage.json", image_mean, 95.8),
    ("video-benchmark.json", clip_mean, 255.6),
]
for name, fn, claimed in checks:
    got = fn(name)
    if abs(got - claimed) > TOLERANCE:
        bad.append(f"{name}: documents say {claimed} s, data gives {got:.3f} s")

# 3. A headline figure written in the prose has to be one the data produces.
#
#    The table rows are checked above, but the same number also lives in
#    sentences, table headings and code comments — "23.0 s buys a still", "the
#    24.0 s/image profile" — and those are the copies a person reads as current
#    fact while the table beside them is right. Three of them survived a
#    re-measurement precisely because this step only looked at tables.
#
#    What makes a figure a headline claim, and not an honest derived one:
#      - an explicit per-unit marker — `N.N s/img`, `N.N s/clip`, `N.N s/image`;
#      - the comparison sentence's bare `N.N s buys a still`, which is the image
#        headline restated;
#      - a bare `N.N s` that neither names a unit nor is that sentence is not a
#        claim about a run at all — a clip's length in seconds, a step cost
#        (`N.N s/step`) and a range bound (`22.5–25.7 s`) all look like this and
#        all move with the run rather than restating it, so they are skipped.
#
#    CHANGELOG.md and the dated `evidence/*-YYYY-MM-DD.md` run reports are
#    skipped: they record what the figures were on their date, and a later
#    re-measurement supersedes their numbers without making the record wrong.
#    Everywhere else a superseded figure has to say so on its own line.
known = {
    "klein-q8": 24.0, "klein-q4": 23.0, "anima-turbo-q8": 36.4,
    "z-image-turbo-q4": 95.8, "klein-base-q8": 97.1,
    "ernie-image-turbo-q8": 123.5, "qwen-image-4bit": 124.9,
    "flux3-klein-q8": 180.6,
    "iris-turbo-q8": 24.1, "boogu-turbo-q8": 160.8,
    "cogvideox-fun-1.5-5b-inp-q4": 247.7, "wan22-ti2v-5b-q8": 255.6,
    "cogvideox-fun-1.5-5b-inp-q8": 262.1,
}
# A line that keeps an old figure on purpose says so; then it is history, not a
# claim. Kept deliberately short so a figure cannot be excused by accident.
HISTORY_MARKERS = ("earlier", "older", "eski", "used to", "was ", "previously", "once ")

DOCS = [p for p in pathlib.Path(".").rglob("*.md")
        if ".git" not in p.parts
        and "evidence/images" not in str(p)
        and p.name != "CHANGELOG.md"
        and not re.search(r"-\d{4}-\d{2}-\d{2}\.md$", p.name)]
# An explicit per-unit figure, the "buys a still" restatement of the image
# headline, or a parenthesised figure right after a model name — `(23.0 s)`,
# which is how a table heading names each model's seconds. Nothing else: a bare
# `N.N s` in a sentence is a clip length or a derived cost.
HEADLINE = re.compile(
    r"\b(\d{1,3}\.\d)\s*(?:s/(?:img|clip|image)\b)"
    r"|(?<![\d.–-])(\d{1,3}\.\d)\s+s\s+buys\s+a\s+still\b"
    r"|\((\d{1,3}\.\d)\s+s\)"
)

for path in DOCS:
    for lineno, line in enumerate(path.read_text().splitlines(), 1):
        if any(marker in line for marker in HISTORY_MARKERS):
            continue
        for m in HEADLINE.finditer(line):
            value = float(m.group(1) or m.group(2) or m.group(3))
            if any(abs(value - v) <= TOLERANCE for v in known.values()):
                continue
            bad.append(
                f"{path}:{lineno}: {m.group(0).strip()!r} is not one of the "
                f"measured figures: {line.strip()[:90]}"
            )

if bad:
    print("\n".join(bad))
    sys.exit(1)
print("paths are repo-relative; every s/img and s/clip figure matches the committed data")
PY

printf '\n\033[1;32mAll checks passed.\033[0m\n'

step "10. Mermaid — every diagram is closed and renders"
python3 - <<'PY'
import pathlib, re, sys
blocks = []
for p in pathlib.Path(".").rglob("*.md"):
    if ".git" in p.parts:
        continue
    text = p.read_text()
    for m in re.finditer(r"```mermaid\n(.*?)```", text, re.S):
        blocks.append((str(p), m.group(1)))
if not blocks:
    print("no mermaid blocks found")
    sys.exit(0)
bad = 0
for path, body in blocks:
    # structure: non-empty, balanced subgraph/end
    if not body.strip():
        print(f"{path}: empty mermaid block")
        bad += 1
        continue
    depth = 0
    for line in body.splitlines():
        t = line.strip()
        if t.startswith("subgraph"):
            depth += 1
        elif t == "end":
            depth -= 1
            if depth < 0:
                depth = 0
    if depth != 0:
        print(f"{path}: unbalanced subgraph/end (depth {depth})")
        bad += 1
print(f"{len(blocks)} mermaid blocks checked for structure")
sys.exit(1 if bad else 0)
PY
# render check, only if mmdc and a browser are available
CHROME=""
for c in /Applications/Chromium.app/Contents/MacOS/Chromium \
         /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome; do
    if [ -x "$c" ]; then CHROME="$c"; break; fi
done
if command -v mmdc >/dev/null 2>&1 && [ -n "$CHROME" ]; then
    tmpdir="$(mktemp -d)"
    trap 'rm -rf "$tmpdir"' EXIT
    i=0
    fail=0
    # shellcheck disable=SC2013
    for f in $(grep -rl '```mermaid' --include='*.md' . | grep -v .git); do
        python3 - "$f" "$tmpdir" <<'PY'
import re, pathlib, sys
src, outdir = sys.argv[1], sys.argv[2]
text = pathlib.Path(src).read_text()
for idx, m in enumerate(re.finditer(r"```mermaid\n(.*?)```", text, re.S)):
    pathlib.Path(f"{outdir}/{idx}.mmd").write_text(m.group(1))
PY
        for mmd in "$tmpdir"/*.mmd; do
            [ -e "$mmd" ] || continue
            i=$((i+1))
            if ! PUPPETEER_EXECUTABLE_PATH="$CHROME" mmdc -i "$mmd" -o "$tmpdir/out-$i.svg" >/dev/null 2>&1; then
                echo "render failed: $f (block $i)"
                fail=1
            fi
        done
    done
    rm -rf "$tmpdir"
    trap - EXIT
    if [ "$fail" -ne 0 ]; then
        echo "mermaid render FAILED"
        exit 1
    fi
    echo "all mermaid blocks render with mmdc"
else
    echo "mmdc or a browser not found; structure check only"
fi

step "11. Model map — files, PNGs, and HF links agree"
python3 - <<'PY'
import json, pathlib, re, struct
root = pathlib.Path(".")
base = root / "docs" / "diagrams" / "model-map"
for name in ["model-map.html", "model-map-dark.png", "model-map-light.png", "README.md"]:
    assert (base / name).exists(), f"missing {name}"
html = (base / "model-map.html").read_text()
for png_name in ["model-map-dark.png", "model-map-light.png"]:
    data = (base / png_name).read_bytes()
    w, h = struct.unpack(">II", data[16:24])
    assert w == 2000, f"{png_name}: width {w} != 2000"
    assert 1000 < h < 8000, f"{png_name}: height {h} out of range"
# every HF URL published in the profiles must appear in the poster
urls = set()
readme = (root / "README.md").read_text()
for line in readme.splitlines():
    if "[HF](" in line:
        urls.update(re.findall(r"https://huggingface\.co/[A-Za-z0-9._/-]+", line))
assert urls, "no HF URLs found in profiles"
missing = [u for u in urls if u not in html]
assert not missing, f"HF URLs missing from poster: {missing}"
assert "<script src" not in html and "<link rel=\"stylesheet\"" not in html, "external resource found"
print(f"model map OK · {len(urls)} HF links agree · PNG 2000 px")
PY

step "12. Every profile appears in every document that lists models"
python3 - <<'PY'
import json, pathlib, sys

# A profile is added once and copied into many places: the two READMEs, the
# comparison page, the model map. Fixing one copy and stopping has shipped a
# model the page answering "which model" did not mention — Qwen Image was added
# to the Models table but left out of the summary table of both READMEs and both
# tables of the comparison page, and each gap was found separately.
#
# The check is a search, not a memory. A document names a model by whichever
# handle reads best there: the profile key (`klein-q8`), the model id
# (`mflux-community/flux2-klein-4b-mflux-q8`), or a human name (`FLUX.2 klein 4B`).
# A profile counts as present when the document carries any of them, so this does
# not force one spelling on every page — it fails only when a model is genuinely
# absent.
profiles = {}
for source in ("profiles/mflux-profiles.json", "profiles/video-profiles.json"):
    doc = json.loads(pathlib.Path(source).read_text())
    for key, prof in doc["generation_profiles"].items():
        profiles[key] = {h for h in (key, prof.get("model"), prof.get("base_model")) if h}

# Documents whose job is to enumerate the models. Deliberately not every markdown
# file: an evidence page is one run's record and names only what that run
# measured, and profiles/README.md explains the file format without listing
# models — neither is a gap.
LISTING_DOCS = [
    "README.md",
    "README.tr.md",
    "docs/reference/COMPARISON.md",
    "docs/reference/PROFILES.md",
    "docs/diagrams/model-map/model-map.html",
]

# A human name cannot be derived from the profile, so the ones a document uses are
# declared here. The poster reads best with "Qwen Image", not "qwen-image-4bit";
# without this the check would report it missing a model it plainly draws. A page
# also drops the owner prefix and the quant suffix — `CogVideoX-Fun-V1.5-5b-InP`
# for `dgrauet/CogVideoX-Fun-V1.5-5b-InP-mlx-q8` — so each spelling a page actually
# carries belongs on its line, or the check reports a model the page does list.
DISPLAY_NAMES = {
    "klein-q8": ["FLUX.2 klein 4B", "flux2-klein-4b"],
    "klein-q4": ["FLUX.2 klein 4B", "FLUX.2-klein-4B"],
    "z-image-turbo-q4": ["Z-Image Turbo", "z-image-turbo"],
    "flux3-klein-q8": ["FLUX 3 Image Klein", "flux-3-image-klein-base"],
    "qwen-image-4bit": ["Qwen Image", "qwen-image"],
    "ernie-image-turbo-q8": ["ERNIE Image Turbo", "ernie-image-turbo"],
    "anima-turbo-q8": ["Anima Turbo", "anima-turbo"],
    "klein-base-q8": ["FLUX.2 klein 4B Base", "FLUX.2-klein-base-4B", "flux2-klein-base-4b", "flux-2-klein-base-4b"],
    "bonsai-image-ternary-2bit": ["Bonsai Image 4B", "bonsai-image-ternary"],
    "iris-turbo-q8": ["Iris 3B Turbo", "Iris-3B", "iris-3b"],
    "boogu-turbo-q8": ["Boogu Image", "Boogu-Image"],
    "cogvideox-fun-1.5-5b-inp-q8": ["CogVideoX-Fun 5B", "CogVideoX-Fun-V1.5-5b-InP"],
    "cogvideox-fun-1.5-5b-inp-q4": ["CogVideoX-Fun 5B", "CogVideoX-Fun-V1.5-5b-InP"],
    "wan22-ti2v-5b-q8": ["Wan2.2 TI2V 5B", "Wan2.2-TI2V-5B"],
}

bad = []
for name in LISTING_DOCS:
    text = pathlib.Path(name).read_text()
    missing = []
    for key, handles in sorted(profiles.items()):
        probe = set(handles) | set(DISPLAY_NAMES.get(key, []))
        if not any(h in text for h in probe):
            missing.append(key)
    if missing:
        bad.append(f"{name} does not name: {', '.join(missing)}")

if bad:
    print("\n".join(bad))
    print("Add the model to the document, or add its human name to DISPLAY_NAMES")
    print("above if that page names it differently.")
    sys.exit(1)
print(f"{len(profiles)} profiles named in all {len(LISTING_DOCS)} listing documents")
PY

step "13. Model inventory — the disk total claims add up"
python3 - <<'PY'
import pathlib, re, sys

# A model table and the sentence under it are two statements of one total, and
# they drift apart: both READMEs said ~96 GB while their own twelve rows summed
# to 115.9, and ENVIRONMENT.md said 68 GB and called it "the same total the
# README states". Two wrong numbers agreeing looked like a source; only du
# settled it. So the sum of each table is now checked against the number the
# document claims, and the documents against each other.
ROW = re.compile(r"^\| `[^`]+` \| (\d+(?:\.\d+)?) GB \|")

DOCS = [
    ("README.md", r"\*\*Total on disk:\*\* ~(\d+) GB"),
    ("README.tr.md", r"\*\*Diskte toplam:\*\* ~(\d+) GB"),
    ("docs/reference/ENVIRONMENT.md", r"Roughly (\d+) GB"),
]

bad, claimed = [], {}
for name, pattern in DOCS:
    text = pathlib.Path(name).read_text()
    rows = [float(m.group(1)) for line in text.splitlines() if (m := ROW.match(line))]
    total = re.search(pattern, text)
    if not rows:
        bad.append(f"{name}: no model rows matched the table shape")
        continue
    if not total:
        bad.append(f"{name}: no total sentence matched")
        continue
    stated = int(total.group(1))
    claimed[name] = stated
    if abs(sum(rows) - stated) > 1:
        bad.append(f"{name}: {len(rows)} rows sum to {sum(rows):.1f} GB, the text says ~{stated} GB")

# The three documents describe one inventory. If they disagree with each other,
# one of them is describing a repository that no longer exists.
if len(set(claimed.values())) > 1:
    detail = ", ".join(f"{k} ~{v} GB" for k, v in claimed.items())
    bad.append(f"the documents disagree on the total: {detail}")

if bad:
    print("\n".join(bad))
    sys.exit(1)
print(f"three totals agree at ~{list(claimed.values())[0]} GB and match their tables")
PY
