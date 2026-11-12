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
import pathlib
text = pathlib.Path("docs/reference/LICENSES.md").read_text()
for needle in ("FLUX Kommunity License", "CogVideoX", "Apache-2.0"):
    assert needle in text, f"licences doc no longer mentions: {needle}"
print("licences documented; the conditional ones are flagged")
PY

step "7. Image harness — the mflux command and the PNG reader agree"
python3 scripts/measure/image-benchmark.py --selftest

step "8. Video harness — the runner command and the ffprobe reader agree"
python3 scripts/measure/video-benchmark.py --selftest

step "9. Reference data — relative paths, and the headline figures match it"
python3 - <<'PY'
import json, pathlib, statistics, sys

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
    ("image-benchmark.json", image_mean, 22.5),
    ("image-benchmark-flux3.json", image_mean, 180.6),
    ("video-benchmark.json", clip_mean, 266.1),
]
for name, fn, claimed in checks:
    got = fn(name)
    if abs(got - claimed) > TOLERANCE:
        bad.append(f"{name}: documents say {claimed} s, data gives {got:.3f} s")

if bad:
    print("\n".join(bad))
    sys.exit(1)
print("paths are repo-relative; s/img and s/clip match the committed data")
PY

printf '\n\033[1;32mAll checks passed.\033[0m\n'
