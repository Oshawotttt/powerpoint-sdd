# powerpoint-sdd

A plugin that applies spec-driven development (SDD) to making and drafting PowerPoint presentations.

## Install

Prerequisites:

- **Node.js and Python** installed on your machine. `/ppt-generate` installs the packages it needs by itself, into a temporary folder, so your repo stays free of `node_modules` and virtual environments.
- **Anthropic's `pptx` skill.** `/ppt-generate` uses it for the build mechanics and QA. Skip this if you already have it enabled on claude.ai.

  ```
  /plugin marketplace add anthropics/skills
  ```
  ```
  /plugin install document-skills@anthropic-agent-skills
  ```

- **A design system** made with Claude Design. `/ppt-layout` and `/ppt-generate` read it.

Install the plugin, then start a spec in the repo you want to keep your decks in:

```
/plugin install powerpoint-sdd --marketplace Oshawotttt/powerpoint-sdd
```

Every skill takes `--dir <folder>` to say where your PowerPoint files live, except `/ppt-generate`, which takes `--spec <folder>` and `--out <folder>`. Without them, a skill uses the map `/ppt-init` saved, or asks you.

On Claude Code before 2.1.275, add the marketplace first: `/plugin marketplace add Oshawotttt/powerpoint-sdd`, then `/plugin install powerpoint-sdd@powerpoint-sdd`.

## The problem

When people use AI for slides, they usually give it some context or access to a repo, then generate the slides from that. Making slides is repetitive, and most of the time goes into formatting, so it looks like a good use of AI. But it goes against how I think AI should be used.

AI should handle the routine, tedious work, while high-level thinking and decisions stay with humans (i.e. the human thinks and plans -> the AI executes). The conventional approach flips this.

- **The AI does the thinking:** It is hard to supply enough information in one go, so the AI fills the gaps itself and makes assumptions you might not want in your presentation.
- **You still do the formatting:** You have to edit the generated slides, so if a lot has to change, you end up doing the formatting.
- **Iterating with AI doesn't fix it:** Working through the changes with AI is expensive and tedious, and it is prone to context bloat. The AI's work degrades as the context grows, and the result is often still AI slop and cognitive surrender on the human's side.

Building apps with AI had the same problem a few years ago, and SDD solved it.

## The approach

This plugin flips the process back: you settle the content in a spec first, and the AI builds the slides from it afterwards.

### 1. Spec

Specs are cheap and easy to generate and change, because they are only text files. They hold the actual content that goes onto the slides, so you can go in and edit things like language and phrasing yourself.

The `ppt-spec` skill creates the spec through discussion, starting from whatever you have: an idea dump, an outline, a scope or a repo.

Two things in the spec's design prevent cognitive surrender:

- **You control the flow.** Every open question and assumption is noted down in the section it affects, so you can address whatever you want first.
- **It follows a discussion format.** The AI finds the facts, and you make the decisions about what to include, what to emphasise and how to phrase it. Nothing moves forward until you approve it.

### 2. Draft

The `ppt-draft` skill drafts a few slides in HTML, because HTML is cheaper to edit. This reduces formatting errors later on and reduces the tedious work left to the human.

### 3. Generate

The `ppt-generate` skill builds the deck. Little support is needed here, because design systems are created outside this repo with Claude Design. Generation is built on these existing tools, courtesy of Anthropic.

## Other skills

### `ppt-init`

Optional. Saves where your PowerPoint files live: it creates the folders, writes a map of the file structure into `CLAUDE.md`, and can gitignore the folders. After that, the other skills stop asking for the folder. Without it, they ask for a folder.

### `ppt-layout`

Specifies the layout of each slide. It is optional in the workflow.

The AI makes the first layer of decisions, because most layout options are obvious. You can then choose or edit any layout, so decision making and personalisation still lie with you.

For more control over the layout, run `/ppt-layout suggest`. The AI still picks a best fit for every slide, but it also raises the slides where the choice is contested as open questions for you to settle.
