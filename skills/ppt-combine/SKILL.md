---
name: ppt-combine
description: Combine a deck's spec into one markdown file, ARCHITECTURE.md then every section file, to read or share the whole spec at once. Use when the user wants to combine, merge, or read the whole spec as one file.
argument-hint: "[--dir folder]"
---

Write the whole spec into one generated file, `FULL_FILE`, by running this skill's script. The script does all the work: you resolve the folder, run it, and report.

**Folder:** the `--dir <folder>` argument, or else the folder an earlier `ppt-` skill used in this conversation. Otherwise, if the repo's `CLAUDE.md` or a file it points to has a `PowerPoint map` heading, take the paths below from that section. Otherwise ask the user for the folder path and wait. Write nothing yourself: the script writes the only file.

Paths, relative to the folder. The folder holds one deck:

- `SPEC_DIR`: `spec/`
- `FULL_FILE`: `spec/FULL.md`

## 1. Run the script

`combine.sh` sits in this skill's base directory. Run it with `SPEC_DIR`:

```bash
bash "<skill base directory>/combine.sh" "<SPEC_DIR>"
```

It writes `FULL_FILE`, overwriting any earlier one: a generated banner, then `ARCHITECTURE.md`, then every `[0-9][0-9]-*.md` section file in file-name order, each after a `---` line. Contents are copied verbatim, and `FULL_FILE` sits in `SPEC_DIR` so resource paths still resolve.

## 2. Report

- **Exit 0:** link `FULL_FILE`. Tell the user it is generated, so edits belong in `ARCHITECTURE.md` and the section files, then rerun `/ppt-combine`.
- **Any other exit:** report the script's stderr and exit code verbatim. Fix nothing and write nothing.
