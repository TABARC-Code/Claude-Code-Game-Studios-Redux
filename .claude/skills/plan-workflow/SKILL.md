---
name: plan-workflow
description: "Builds a written roadmap from where the project is to a goal you choose: the steps in order, what each produces, which are done, and which are left off and why. Writes production/workflow-plan.md; re-run with --refresh to tick off what has been done."
argument-hint: "[goal in your own words] [--refresh] [--optional]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, Edit, AskUserQuestion, Bash(bash "*/.claude/skills/plan-workflow/../../hooks/yaml-helper.sh" resolve_config *), Bash(bash .claude/scripts/project-state.sh*), Bash(bash .claude/scripts/artifact-check.sh*)
model: sonnet
---

!`bash "${CLAUDE_SKILL_DIR}/../../hooks/yaml-helper.sh" resolve_config --keys automation,workflow,project.stage,team.size`

Resolved above; use as-is. No block: `automation: collaborative`, `workflow: minimal`, stage unset,
`team.size: individual`, and say the settings were not read.

# Plan Workflow

A written route from where the project is to somewhere the user wants it to be. It is built from the
workflow catalog (`.claude/docs/workflow-catalog.yaml`) and from what is on disk, so it is the
catalog's own steps in the catalog's own order, tailored to the workflow tier and cut off at the goal.

**How it differs from its neighbours.** `/help` names the one next step and shows what comes after;
it writes nothing. `/project-stage-detect` audits the whole project. `/sprint-plan` plans sprints inside
Production. This writes a roadmap to a goal you pick, keeps it in `production/workflow-plan.md`, and
can be refreshed as steps get done. It plans routes through the catalog; it does not estimate
durations (the plan has a blank column for yours) and it does not run any step.

Ask with the question tool. Without one, list the options numbered and end your turn to wait. A
skipped or dismissed question is not an answer: ask again in plain text. Questions follow
`.claude/docs/automation-modes.md`.

## Phase 1: Observe

Run both helpers and read what they print; do not re-derive it from files by hand.

1. `bash .claude/scripts/project-state.sh`: engine, code root, counts, stage, inferred phase.
2. At `workflow: minimal`: `bash .claude/scripts/artifact-check.sh --path minimal`. Otherwise:
   `bash .claude/scripts/artifact-check.sh` (the whole phase ladder).

Open the report with the **denominators**: catalog steps read (`STEPS`), how many have no
detectable artifact (`NO_CHECK`), and the tier. A helper that fails to run, or a catalog that
cannot be read, is `NOT ASSESSED`: name which one, do not guess a position, and end with
`Verdict: **NOT ASSESSED** — [helper or catalog] could not be read.`

At `minimal`, say once that the phase ladder is not used at this tier and `project.stage` may
sit at Concept for the whole project; the path is what counts.

## Phase 2: Choose the goal

Read the goal from the text typed after the skill name, or ask.

**Derive the candidates from the catalog; do not list them from memory.** At `minimal` the
candidates are the steps on the minimal path; otherwise the end of each phase on the ladder, labelled
as the catalog labels them. Show the candidate list with the user's current position marked (from
`project.stage` and `phase_inferred`, naming which one was used if they differ).

A goal in the user's own words ("a playable demo", "something to show a publisher") is mapped to the
nearest candidate **and shown as a mapping for confirmation**, with the steps that mapping adds or
leaves out. If no candidate fits, say so and ask; do not stretch the nearest one.

Ask once whether to include optional steps (`required: false` in the catalog). The default is
required steps only; `--optional` says yes in advance.

## Phase 3: Build the plan

For each catalog step from the start of the route up to and including the goal's endpoint:

- **Step, command, required or optional**, as the catalog has them.
- **Status**, as the helper reports it: `PRESENT`, `ABSENT`, `SHORT`, `PATTERN_MISS`, or `NO_CHECK`.
  `NO_CHECK` means done-ness cannot be seen from files, and the plan says that; it never shows a
  `NO_CHECK` step as done or as not done. The user ticks those.
- **Produces:** the artifact glob or the catalog's description.
- **Done:** ticked only for `PRESENT`.

Then:

- **Repeats.** A `repeatable` step (one per system, one per story) is listed in its own table with
  the count the helper reports (`gdd_files`, `story`, `adr`, `sprint`). A count the helper does not
  give is "not detectable".
- **Decision points.** Between phases, `/gate-check` is available and its verdicts are advisory. At
  `minimal` there are no phase gates: say so instead of listing any.
- **Skipped on this plan.** Every catalog step in range that the plan leaves out (optional steps
  when the user said no, steps after the goal) is **named in a table with the reason**. A step left
  off the plan is never dropped silently, and the count of later steps is stated.
- **Not detectable.** The `NO_CHECK` steps in range, listed together.
- **Your time:** a blank column. No durations are filled in. If the user wants estimates for a step,
  `/estimate` does that with their own numbers.

If the route is already complete (every required step in range is `PRESENT`), say so, do not invent
work, and offer the next candidate goal.

## Phase 4: Present and write

Show the whole plan in conversation first, then ask as its own question: "May I write this to
`production/workflow-plan.md`?" `Yes, write it` / `Revise first`. Agreeing to the goal is not a yes to
the write. If the file exists and this is not `--refresh`, ask whether to replace it; never overwrite
a plan silently. Fill `.claude/docs/templates/workflow-plan.md`; create `production/` if needed.

## Phase 5: Refresh (`--refresh`)

1. Read `production/workflow-plan.md`. None: say so and offer to build one.
2. Keep the plan's goal and its optional-steps choice. Re-run Phase 1.
3. Compare. Report, by step name: steps that became `PRESENT` since the plan was written; steps whose
   status moved the other way (an artifact was deleted: say so plainly); steps the plan lists that the
   catalog no longer has; steps now in the route that the plan does not list.
4. **Tier changed since the plan was written** (the plan header says `minimal`, the config says
   `standard`): do not patch the old plan. Say the plan was built for another tier and offer a rebuild.
5. Show the changes, ask "May I update `production/workflow-plan.md`?", and edit only the Status,
   Done, Repeats and refresh-date fields. The goal does not change on a refresh.

End with one verdict line:

- `Verdict: **COMPLETE** — plan written: [n] steps, [k] done, [m] not detectable.`
- `Verdict: **COMPLETE** — plan refreshed: [n] steps changed.`
- `Verdict: **BLOCKED** — no goal chosen.`
- `Verdict: **NOT ASSESSED** — [helper or catalog] could not be read.`

## Recommended Next Steps

- `/help`: the single next step, any time
- The first unticked step on the plan, by its command
- `/gate-check`: at a phase boundary on the plan
- `/estimate [task]`: put your own numbers in the "Your time" column
- `/plan-workflow --refresh`: after a few steps are done

<!-- skill-links:start -->
## Links

Generated by `.claude/scripts/skill-links.sh --write`. Change the skill's text, not this block.

Links to: `/estimate`, `/gate-check`, `/help`, `/project-stage-detect`, `/sprint-plan`
Linked from: `/brainstorm`, `/help`, `/one-page-design`
<!-- skill-links:end -->
