# Skill Test Spec: /plan-workflow

## Skill Summary

`/plan-workflow` writes `production/workflow-plan.md`: a roadmap from the project's current position to
a goal the user picks. It runs `.claude/scripts/project-state.sh` and `.claude/scripts/artifact-check.sh`
(`--path minimal` at the minimal tier), opens with the denominators (steps read, NO_CHECK count, tier),
derives the goal candidates from the catalog, maps a free-text goal to a candidate for confirmation, and
builds the plan from the catalog's steps up to the goal: status, produces, done, repeats, decision points,
skipped steps (named, with reasons) and not-detectable steps. It guesses no durations. `--refresh` updates
status and ticks without changing the goal. It runs nothing and estimates nothing.

---

## Static Assertions (Structural)

- [ ] Frontmatter has `name`, `description`, `argument-hint`, `user-invocable`, `allowed-tools`
- [ ] 2+ phase headings found
- [ ] Contains `COMPLETE`, `BLOCKED` and `NOT ASSESSED`
- [ ] `allowed-tools` includes Write/Edit and "May I write" language is present
- [ ] `allowed-tools` has no bare `Bash`; the shell grants are the config helper, `project-state.sh` and `artifact-check.sh`
- [ ] Goal candidates are derived from the catalog at run time, not listed in the skill
- [ ] Next-step handoff section present at end

---

## Director Gate Checks

N/A. No director gate is spawned.

---

## Fixture Defaults

Every case's `project.yaml` sets `modes.rigor: minimal` and `modes.automation: collaborative`,
with no `project.local.yaml`, unless its own Fixture says otherwise.

---

## Test Cases

### Case 1: Happy Path — minimal tier

**Fixture**: `engine.name` set; `design/game-brief.md` exists; no stories.

**Input**: `/plan-workflow first playable`

**Expected behavior**: opens with STEPS, NO_CHECK and tier; notes the phase ladder is not used at
minimal; maps "first playable" to a minimal-path step and shows the mapping; plan ticks engine-setup
and game-brief, lists create-stories and implement as to do; no phase gates listed; asks to write; verdict COMPLETE.

**Assertions**:
- [ ] Denominators printed before any step
- [ ] Only steps from the minimal path appear
- [ ] The goal mapping is shown for confirmation
- [ ] "Your time" is blank

### Case 2: NO_CHECK is never shown as done

**Fixture**: a route containing a step with `status=NO_CHECK`.

**Expected behavior**: the step is unticked, listed under "Not detectable from files", and counted in the verdict.

**Assertions**:
- [ ] The NO_CHECK step is not ticked
- [ ] The verdict states the not-detectable count

### Case 3: Skipped steps are named

**Fixture**: `workflow: standard`; user declines optional steps.

**Expected behavior**: each optional step in range appears in "Skipped on this plan" with its reason;
steps after the goal are counted and named.

**Assertions**:
- [ ] No in-range step is missing from both the plan and the skipped table

### Case 4: Helper or catalog unreadable

**Fixture**: `artifact-check.sh` fails or the catalog is absent.

**Expected behavior**: no position is guessed; verdict NOT ASSESSED names which input failed.

**Assertions**:
- [ ] Verdict is NOT ASSESSED
- [ ] No plan file is written

### Case 5: Refresh

**Fixture**: a plan written at `minimal`; since then `create-stories` produced story files.

**Input**: `/plan-workflow --refresh`

**Expected behavior**: reports `create-stories` became PRESENT; asks "May I update"; edits only Status,
Done, Repeats and the refresh date; goal unchanged.

**Assertions**:
- [ ] The goal line is unchanged
- [ ] A step that moved back to ABSENT is reported plainly

### Case 6: Tier changed since the plan

**Fixture**: plan header says `minimal`; config now `standard`.

**Input**: `/plan-workflow --refresh`

**Expected behavior**: does not patch; says the plan was built for another tier; offers a rebuild.

**Assertions**:
- [ ] The old plan is not edited

### Case 7: Route already complete

**Fixture**: every required step in range is PRESENT.

**Expected behavior**: says so, invents no work, offers the next candidate goal.

**Assertions**:
- [ ] No step is invented

---

## Protocol Compliance

- [ ] Asks "May I write" before writing; asks before replacing an existing plan
- [ ] Runs nothing and fills in no durations
- [ ] Reads position from the helpers, not from files by hand
- [ ] Ends with a Verdict line

---

## Coverage Notes

- Repeat counts depend on what `project-state.sh` reports; counts it does not give are "not detectable".
- No automated runner; review manually or via `/skill-test`.
