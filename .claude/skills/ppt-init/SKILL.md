---
name: ppt-init
description: Set up a repo for spec-driven PowerPoint decks by creating the folders and the map, and optionally gitignoring the folders.
disable-model-invocation: true
---

Set up the repo root: `git rev-parse --show-toplevel`, or the working directory outside git.

This skill owns every PowerPoint file reference. The map template in step 5 gives each file a name, a default path, and its use cases. The other `ppt-` skills use only the names and resolve them through the map, so a path changes in one place. Add any new file to the template before a skill refers to it.

The root folders are `SPEC_DIR`, `OUTPUT_DIR` and `CONTEXT_DIR`. Their default paths are in the template.

## 1. Inspect

- **Earlier init:** a map already exists if `CLAUDE.md`, `MAP.md`, or a file `CLAUDE.md` points to for the map contains `ARCHITECTURE_FILE`. An older map with no names contains `<project>/ARCHITECTURE.md` instead. Keep the paths the map uses and treat its folders as yours. Update that map in place in step 5.
- **Overlaps:** list every root folder default that already exists at the root and is not yours from an earlier init. Compare names case-insensitively, and count a file of the same name as an overlap.
- **`CLAUDE.md`:** count its lines.

## 2. Ask

Ask these together with `AskUserQuestion`. Skip a question that has nothing to settle.

- **Each overlap:** which name to use instead. Offer `ppt-<name>/` as the suggestion and sharing the existing folder as the alternative. The user may type their own name. Check that any new name is free too, and ask again if it is taken.
- **Gitignore:** whether to gitignore the PowerPoint folders. Their contents would then exist only on this machine.

The step is complete when every root folder has a name that is free or that the user chose to share.

## 3. Create the folders

Create each root folder under its settled name. Leave the contents of existing folders untouched.

## 4. Gitignore

If the user said yes, add each root folder to `.gitignore` as `<folder>/`, creating the file if needed. Append only entries that are missing, and keep the existing lines.

Leave out any folder the user chose to share, because ignoring it would hide their existing files. Name the left-out folders in the report.

## 5. Write the map

Fill in the template below with the settled folder names, changing every path under a renamed root folder. Keep any path an earlier map already sets. Include the gitignore paragraph only if step 4 added folders, naming only those folders.

Replace an earlier map where it is. Otherwise, where the map goes depends on `CLAUDE.md`:

- **Missing:** create `CLAUDE.md` with a `# <repo name>` heading, then the map.
- **100 lines or fewer:** add the map as a new section at the end.
- **More than 100 lines:** write the map to `MAP.md` at the root, then add this one line to `CLAUDE.md`:

  ```markdown
  For any PowerPoint-related feature, view the map in `MAP.md`.
  ```

  If `MAP.md` already exists and is not the map from an earlier init, ask the user for another file name and use it in the line.

Map template, with `#` in place of `##` when it is the whole of `MAP.md`:

````markdown
## PowerPoint map

Spec-driven PowerPoint decks: draft each project in `SPEC_DIR`, then build the deck into `OUTPUT_DIR`.

Skills refer to files by the names below. To move a file, change its path here. Each `<project>` is the same name in every path.

| Reference | Path | Use |
|---|---|---|
| `SPEC_DIR` | `spec/` | All specs. `/ppt-draft`, `/ppt-layout` and `/ppt-generate` list it to choose a project. |
| `PROJECT_SPEC_DIR` | `spec/<project>/` | One project's spec. `/ppt-spec` creates it. |
| `ARCHITECTURE_FILE` | `spec/<project>/ARCHITECTURE.md` | Overall outline that joins the sections: Brief, design system, section statuses. `/ppt-spec` writes it, `/ppt-layout` updates it, `/ppt-draft` and `/ppt-generate` read it. |
| `SECTION_FILE` | `spec/<project>/<section>.md` | Draft of one section, one file per section. `/ppt-spec` writes it, `/ppt-layout` adds layouts, `/ppt-draft` and `/ppt-generate` read it. |
| `RESOURCE_DIR` | `spec/<project>/resources/<section>/` | Pictures and draft graphs used by that section. `/ppt-spec` fills it, `/ppt-draft` and `/ppt-generate` place them. |
| `GRAPH_DIR` | `spec/<project>/resources/<section>/<graph-name>/` | One draft graph with its data and script. `/ppt-spec` creates it, `/ppt-draft` and `/ppt-generate` redraw from it. |
| `DRAFT_FILE` | `spec/<project>/drafts/<section>-slide-<n>-<descriptor>.html` | HTML draft of one slide. `/ppt-draft` writes it, `/ppt-generate` follows its arrangement. |
| `OUTPUT_DIR` | `output/` | All finished decks and their build scripts. |
| `DECK_FILE` | `output/<project>/<project>.pptx` | Finished PowerPoint file. `/ppt-generate` writes it. |
| `BUILD_SCRIPT` | `output/<project>/build/build.js` | Script that generates the deck. `/ppt-generate` writes and reruns it. |
| `CONTEXT_DIR` | `context/` | All cloned repos. `/ppt-spec` searches it for facts. |
| `CONTEXT_REPO_DIR` | `context/<repo>/` | One cloned repo, for reference when drafting. `/ppt-spec` clones into it. |

Skills: `/ppt-spec` creates a spec through discussion. `/ppt-layout` assigns a design system's layouts to the spec's slides. `/ppt-draft` drafts the hardest slides in HTML. `/ppt-generate` builds the deck from an approved spec and a design system.

`OUTPUT_DIR`, `SPEC_DIR` and `CONTEXT_DIR` are gitignored, so their contents exist only on this machine. Ripgrep-based search skips them by default; pass `--no-ignore` or target the path directly.
````

## 6. Report

Name the folders created, any renamed or shared folders, the file that holds the map, and the `.gitignore` entries added. Leave the changes uncommitted.
