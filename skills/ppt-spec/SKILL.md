---
name: ppt-spec
description: Spec a PowerPoint through discussion, turning an idea dump, outline, scope, or repo into an approved spec. Use when the user wants to plan, outline, or spec a presentation.
---

Spec a deck with the user as a discussion, in three stages. Each stage ends on the user's explicit approval. The skill ends at an approved spec in `PROJECT_SPEC_DIR`; `ppt-generate` builds the PowerPoint from it.

## Start

`ARCHITECTURE_FILE` and the other names in the PowerPoint map's reference table are file references. Resolve each one through that table, never from a remembered path. The map is in `CLAUDE.md`, or in `MAP.md` or another file `CLAUDE.md` points to. With no reference table, ask the user to run `/ppt-init` and stop.

Take whatever the user gives: an idea dump, a current outline, a scope, a repo, or a mix.

- **Repo URL:** clone it into `CONTEXT_REPO_DIR` and read what bears on the presentation.
- **Project already in `SPEC_DIR`:** read `ARCHITECTURE_FILE` and resume at the first section whose status is not `approved`.

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

Stage 1 is complete when the user has approved and every item in their input sits in a section or was cut with their agreement. Then write `ARCHITECTURE_FILE`. If the user named no project, choose a short kebab-case name and tell them.

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
3. **Present it.** Link the file and ask the current frontier round from `Blocked by`.
4. **Integrate each answer.** Update the slides to reflect it, then remove the item from `Blocked by`. Add any new questions or assumptions that the answers raise.
5. **Repeat from step 3.** The section is approved when `Blocked by` is empty and the user has explicitly approved it.

If the discussion shows that a section should split, merge, or move, propose the change. Update `ARCHITECTURE_FILE` once the user approves it.

```markdown
# <Section name>

## Blocked by

### Open questions

### Assumptions

## Slides

### Slide 1: <descriptor>
**Purpose:** <why this slide exists>

**Content:**
<the exact text and phrasing that will appear on the slide, plus any visual>

**Speaker notes:**
<what the presenter says>
```

### Slide content

Follow the user's guidance on language and concision, recorded in the Brief. Every fact on a slide traces to the user's input, `CONTEXT_DIR`, or an answered question. Anything else is an assumption, so list it in `Blocked by`.

### Layout

`ppt-layout` adds a `**Layout:**` field to slides and may raise layout questions in `Blocked by`. Keep the field when editing a slide, and settle a layout question by writing the chosen name into it.

### Visuals

- **Picture exists:** copy it to `RESOURCE_DIR` and reference it from the slide.
- **Data exists:** create draft graphs in `GRAPH_DIR`, with the data and script that produce them, and reference the draft from the slide.
- **Nothing exists, and you judge a visual is needed:** write a short description on the slide and add an open question.

## Stage 3: Final scan

Start once every section is approved. Read the whole spec and check all of these:

- **Correctness:** every fact and number matches its source, and every resource reference resolves.
- **Slide links:** each slide's content follows from the slide before it, for every consecutive pair in every section.
- **Section links:** each section boundary delivers the hand-off in `ARCHITECTURE_FILE`, and the sections still match their stated purpose.
- **Transitions:** each slide pair and section boundary where a written transition would help.

Transition fields are optional, and the user can settle any transition themselves. When one is used, record it on the slide it leads out of, in either place:

```markdown
**Transition (slide):** <text shown on the slide>
**Transition (notes):** <line spoken by the presenter>
```

Present findings as a frontier round, each with the exact edit you propose. Apply only what the user approves.

Stage 3 is complete when every pair and boundary has been checked, every finding has been applied or declined, and the user confirms the spec is final. Then set **Spec status** in `ARCHITECTURE_FILE` to `final`.
