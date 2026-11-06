# powerpoint-sdd

## PowerPoint map

Spec-driven PowerPoint decks: draft each project in `SPEC_DIR`, then build the deck into `OUTPUT_DIR`.

Skills refer to files by the names below. To move a file, change its path here. Each `<project>` is the same name in every path.

| Reference | Path | Use |
|---|---|---|
| `SPEC_DIR` | `spec/` | All specs. `/ppt-draft`, `/ppt-layout` and `/ppt-generate` list it to choose a project. |
| `PROJECT_SPEC_DIR` | `spec/<project>/` | One project's spec. `/ppt-plan` creates it. |
| `ARCHITECTURE_FILE` | `spec/<project>/ARCHITECTURE.md` | Overall outline that joins the sections: Brief, design system, section statuses. `/ppt-plan` writes it, `/ppt-layout` updates it, `/ppt-draft` and `/ppt-generate` read it. |
| `SECTION_FILE` | `spec/<project>/<section>.md` | Draft of one section, one file per section. `/ppt-plan` writes it, `/ppt-layout` adds layouts, `/ppt-draft` and `/ppt-generate` read it. |
| `RESOURCE_DIR` | `spec/<project>/resources/<section>/` | Pictures and draft graphs used by that section. `/ppt-plan` fills it, `/ppt-draft` and `/ppt-generate` place them. |
| `GRAPH_DIR` | `spec/<project>/resources/<section>/<graph-name>/` | One draft graph with its data and script. `/ppt-plan` creates it, `/ppt-draft` and `/ppt-generate` redraw from it. |
| `DRAFT_FILE` | `spec/<project>/drafts/<section>-slide-<n>-<descriptor>.html` | HTML draft of one slide. `/ppt-draft` writes it, `/ppt-generate` follows its arrangement. |
| `OUTPUT_DIR` | `output/` | All finished decks and their build scripts. |
| `DECK_FILE` | `output/<project>/<project>.pptx` | Finished PowerPoint file. `/ppt-generate` writes it. |
| `BUILD_SCRIPT` | `output/<project>/build/build.js` | Script that generates the deck. `/ppt-generate` writes and reruns it. |
| `TEMPLATES_DIR` | `templates/` | Templates and local design systems. `/ppt-layout` and `/ppt-generate` list it to choose a design system. |
| `TEMPLATE_DIR` | `templates/<name>/` | One local design system. `/ppt-layout`, `/ppt-draft` and `/ppt-generate` read it. |
| `TEMPLATE_FILE` | `templates/<name>.pptx` or `.potx` | One PowerPoint template. `/ppt-layout`, `/ppt-draft` and `/ppt-generate` read it. |
| `CONTEXT_DIR` | `context/` | All cloned repos. `/ppt-plan` searches it for facts. |
| `CONTEXT_REPO_DIR` | `context/<repo>/` | One cloned repo, for reference when drafting. `/ppt-plan` clones into it. |

Skill sources, in `.claude/skills/`: `ppt-init` sets up the folders and this map in a repo. `ppt-plan` creates a spec through discussion. `ppt-layout` assigns a design system's layouts to the spec's slides. `ppt-draft` drafts the hardest slides in HTML. `ppt-generate` builds the deck from an approved spec and a design system.

`OUTPUT_DIR`, `SPEC_DIR`, `TEMPLATES_DIR` and `CONTEXT_DIR` are gitignored, so their contents exist only on this machine. Ripgrep-based search skips them by default; pass `--no-ignore` or target the path directly.
