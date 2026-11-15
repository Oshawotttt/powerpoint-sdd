---
name: ppt-spec
description: Spec a PowerPoint through discussion, turning an idea dump, outline, scope, or repo into an approved spec. Use when the user wants to plan, outline, or spec a presentation.
argument-hint: "[--dir folder]"
---

Spec a deck with the user as a discussion, in three stages. Each stage ends on the user's explicit approval. The skill ends at an approved spec in `SPEC_DIR`; `ppt-generate` builds the PowerPoint from it.

## Start

**Folder:** the `--dir <folder>` argument, or else the folder an earlier `ppt-` skill used in this conversation. Otherwise, if the repo's `CLAUDE.md` or a file it points to has a `PowerPoint map` heading, take the paths below from that section. Otherwise ask the user for the folder path and wait. Create folders as you first write into them, and write nothing outside the folder.

Paths, relative to the folder. The folder holds one deck:

- `SPEC_DIR`: `spec/`
- `ARCHITECTURE_FILE`: `spec/ARCHITECTURE.md`
- `SECTION_FILE`: `spec/<section>.md`
- `RESOURCE_DIR`: `spec/resources/<section>/`
- `GRAPH_DIR`: `spec/resources/<section>/<graph-name>/`
- `CONTEXT_DIR`: `context/`
- `CONTEXT_REPO_DIR`: `context/<repo>/`

`<section>` is the section's number in `ARCHITECTURE_FILE` as two digits, a hyphen, and its name in kebab-case, such as `01-problem`. The number keeps the files in presentation order in a file explorer.

Take whatever the user gives: an idea dump, a current outline, a scope, a repo, or a mix.

- **Repo URL:** clone it into `CONTEXT_REPO_DIR` and read what bears on the presentation.
- **`ARCHITECTURE_FILE` already exists:** read it and resume at the first section whose status is not `approved`.

## Frontier questioning

Run every discussion below as frontier questioning, adapted from the `grilling` skill by Matt Pocock.

Map everything undecided as a **design tree**: each decision branches into the decisions that hang off it. The audience sets the depth, the depth sets which slides exist, and the slides set which visuals are needed.

The **frontier** is every decision whose prerequisites are settled. Work in **rounds**: ask the whole frontier, then wait. A question that depends on another question still open belongs to a later round. After each round, recompute the frontier from the answers.

Finding facts is your job: look in the user's input, `CONTEXT_DIR`, and `RESOURCE_DIR` before asking. Decisions are the user's: what to include, what to emphasise, and how to phrase it. The discussion is done when the frontier is empty and nothing is silently assumed.

## Stage 1: Architecture

Organise the material into sections that make sense for a presentation. Weigh section size: too large confuses and bores the audience, and too small forces too many transitions. Each section should hold one idea the audience could name, with enough material for multiple slides.

Present every section in this form, with the current frontier round after the list:

```
### <Section name / descriptor>
**Purpose:** <what this section does for the audience>
**Contains:**
- <bullets, as concise as possible>
```

If the sections span multiple dimensions, such as several products each covered across problem, solution, and results, put a map above the list showing how they cross. The section descriptions below the map stay linear, in presentation order.

The frontier here includes audience, duration, goal, and the language and concision of slide text. Revise until the user approves.

Stage 1 is complete when the user has approved and every item in their input sits in a section or was cut with their agreement. Then write `ARCHITECTURE_FILE`.

```markdown
# <Presentation title>

## Map
<only when sections span multiple dimensions: how the sections cross those dimensions>

## Brief
- **Audience:**
- **Duration:**
- **Goal:**
- **Language and concision:**
- **Sources:** <inputs and `CONTEXT_REPO_DIR` repos used>
- **Spec status:** draft | final

## Sections

### 1. <Section name>
- **File:** <this section's `SECTION_FILE` path>
- **Status:** not started | in discussion | approved
- **Purpose:**
- **Contains:** <concise bullets>
- **Leads into next section:** <how this section hands off to the next>
```

## Stage 2: Sections

Work through the sections in architecture order, one at a time, unless the user picks another. Set each section's status in `ARCHITECTURE_FILE` as it changes. For each section:

1. **Test the context.** There is enough when you can draft the exact text of most slides and every gap is a specific question or assumption. If there is not enough, run frontier rounds until there is. Create the section file only after this test passes.
2. **Write `SECTION_FILE`** in the format below, with multiple slides. List every open question and assumption in `Blocked by`, and note any question that waits on another.
3. **Check flow, immediately.** Before presenting the file or asking any question, read the slides in order and apply [Transitions and overviews](#transitions-and-overviews). Write each proposal into the slides and list it under `Assumptions`, so the user decides it in the same round as the content.
4. **Present it.** Link the file and ask the current frontier round from `Blocked by`.
5. **Integrate each answer.** Update the slides to reflect it, then remove the item from `Blocked by`. Add any new questions or assumptions that the answers raise. When an answer changes the slide order or adds or removes a slide, repeat step 3 for the affected slides before asking the next round.
6. **Repeat from step 4.** The section is approved when `Blocked by` is empty and the user has explicitly approved it.

If the discussion shows that a section should split, merge, or move, propose the change. Once the user approves it, update `ARCHITECTURE_FILE` and renumber the sections in their new order. For every section whose number changed, rename its `SECTION_FILE`, its `RESOURCE_DIR`, and any draft in `spec/drafts/` that starts with its old `<section>`. Then update every reference to the old paths: the **File** fields, the section heading, and resource paths in slides.

```markdown
# <n>. <Section name>

## Blocked by

### Open questions

### Assumptions

## Slides

### Slide 1: <descriptor>
**Title:** <the exact title shown on the slide>

**Purpose:** <why this slide exists>

**Content:**
<the exact text and phrasing that will appear on the slide below the title, plus any visual>

**Speaker notes:**
<what the presenter says>
```

### Slide content

Follow the user's guidance on language and concision, recorded in the Brief. The **Title** is audience-facing text, distinct from the descriptor, which is only a build label. Omit **Title** only on a slide with no title, such as a full-bleed image. Every fact on a slide traces to the user's input, `CONTEXT_DIR`, or an answered question. Anything else is an assumption, so list it in `Blocked by`.

### Transitions and overviews

Check each of these in the section:

- **Slide pairs:** each consecutive pair where the jump between ideas needs a written transition.
- **Outgoing boundary:** whether the last slide needs a transition into the next section, based on **Leads into next section** in `ARCHITECTURE_FILE`. The last section has no outgoing boundary.
- **Section overview:** whether the section needs an overview slide at its start, previewing its parts. Propose one when the section has several distinct parts or enough slides that the audience needs a map.
- **Deck overview:** in the first section only, whether the deck needs an agenda slide listing the sections. Weigh the duration and the number of sections in the Brief.

Overview slides and transitions are both optional, so propose them only where they help. An overview slide is an ordinary slide in the section file, with its own **Title**, **Purpose**, **Content**, and **Speaker notes**. A transition goes on the slide it leads out of. Its two fields are each optional, so use either one or both:

```markdown
**Transition (slide):** <text shown on the slide>
**Transition (notes):** <line spoken by the presenter>
```

### Layout

`ppt-layout` adds a `**Layout:**` field to slides and may raise layout questions in `Blocked by`. Keep the field when editing a slide, and settle a layout question by writing the chosen name into it.

### Visuals

- **Picture exists:** copy it to `RESOURCE_DIR` and reference it from the slide.
- **Data exists:** create draft graphs in `GRAPH_DIR`, with the data and script that produce them, and reference the draft from the slide.
- **Nothing exists, and you judge a visual is needed:** write a short description on the slide and add an open question.

## Stage 3: Final scan

Start once every section is approved. Read the whole spec and check all of these. `FULL.md` in `SPEC_DIR` is generated by `/ppt-combine` and is not a section file, so skip it.

- **Correctness:** every fact and number matches its source, and every resource reference resolves.
- **Slide links:** each slide's content follows from the slide before it, for every consecutive pair in every section.
- **Section links:** each section boundary delivers the hand-off in `ARCHITECTURE_FILE`, and the sections still match their stated purpose.
- **Transitions and overviews:** recheck every section boundary and the deck overview against the final spec, as in [Transitions and overviews](#transitions-and-overviews). Earlier sections were checked before later ones existed.

Present findings as a frontier round, each with the exact edit you propose. Apply only what the user approves.

Stage 3 is complete when every pair and boundary has been checked, every finding has been applied or declined, and the user confirms the spec is final. Then set **Spec status** in `ARCHITECTURE_FILE` to `final`.
