# Naming conventions

One rule for file names, and each language's own standard for the names inside
the file. This document says what the rule is and where it deliberately gives
way — so a name that looks wrong can be checked against a written decision
rather than a guess.

## File names — scripts and data

Every script and data file is named in **kebab-case**: lowercase letters and
digits, words separated by a single hyphen.

```text
image-benchmark.py     video-benchmark.py
check-naming.py        export-model-catalog.py
profiles/mflux-profiles.json
```

| Applies to | Extensions |
| :--- | :--- |
| Python | `.py` |
| Shell | `.sh` |
| Data | `.json` · `.md` |

The name is everything before the final extension, so `scripts/measure/image-benchmark.py`
is one kebab-case name and `scripts/lint.sh` is another.

**Why kebab-case.** The tooling is Python and shell under one `scripts/` tree, and
the repository keeps *one* file-name rule for all of it rather than one per
language. The cost is stated plainly: [PEP 8](https://peps.python.org/pep-0008/)
prefers `lowercase_with_underscores` for a Python *module*, and a hyphen is not
legal in an importable module name. None of these files is imported — each is
run as a program — so the deviation costs nothing here, and one rule is easier
to remember than two.

## File names — everything else

Kebab-case is the rule for scripts and data only. Everything else follows a
convention the repository does not own:

| Thing | Convention | Owner |
| :--- | :--- | :--- |
| Python packages / modules | `snake_case` | PEP 8 |
| Environment variables | `UPPER_SNAKE_CASE` | POSIX |
| JSON keys | `snake_case` | this repository |
| Profile ids | `kebab-case` matching the file name | this repository |
| Git branches | `type/short-description` (`feat/`, `fix/`, `docs/`) | Conventional Commits |

## Profile ids

A profile id matches its file name stem and its `name` field:
`klein-q8`, `flux3-klein-q8`, `cogvideox-fun-1.5-5b-inp-q8`. The id is the
handle used on the command line (`--profile klein-q8`) and in the reference JSON,
so it must be stable across renames of the model.

## Evidence file names

Evidence files are named `<profile>--<prompt-id>.<ext>`:

```text
evidence/images/klein-q8--photoreal-market.png
evidence/videos/cogvideox-fun-1.5-5b-inp-q8--motion-horse-gallop.gif
```

The double hyphen separates the profile from the prompt; a single hyphen separates
words. This keeps the file name greppable by either axis.

## What is deliberately not enforced

- **Python module names** inside `scripts/` are not importable; they are run as
  programs. `import image_benchmark` is not a supported use.
- **Markdown headings** follow title case in English and sentence case in
  Turkish, per the surrounding document's language.
- **Commit subjects** follow Conventional Commits, not kebab-case.
