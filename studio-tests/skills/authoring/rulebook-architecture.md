# Skill Test Spec: /rulebook-architecture

## Skill Summary

`/rulebook-architecture [path-to-rulebook-or-rules-folder | 'plan' for a book not yet written]` Audits or plans the whole-book structure of a rulebook: functional layers and their dependencies, the learner and veteran readers, type census, navigation kit, a forensic sentence sample and a cold-read lookup test. Reports end with a verdict; the verdict words are TANGLED, CONCERNS, NOT ASSESSED, NAVIGABLE. The
report is saved to `design/craft/rulebook-architecture-[name]-[date].md` only after "May I write this to ...?" and an explicit yes. No director
gates are invoked.

---

## Static Assertions (Structural)

- [ ] Frontmatter has `name`, `description`, `argument-hint`, `user-invocable`, `allowed-tools`
- [ ] 2+ phase headings found
- [ ] Contains the verdict keywords: TANGLED, CONCERNS, NOT ASSESSED, NAVIGABLE
- [ ] Has ask-before-write language naming the target path
- [ ] `allowed-tools` has no bare `Bash`; the only shell grant is the config helper
- [ ] Next-step handoff section present at end, naming other skills
- [ ] No em dashes and no arrow glyphs in the SKILL.md
- [ ] Has an honest-reporting rule: skipped phases are named under "Not run", and NOT ASSESSED outranks the pass verdict but not a failure verdict

---

## Director Gate Checks

None. This is a design-craft skill; no gates run in any review mode.

---

## Fixture Defaults

Every case's `project.yaml` sets `modes.rigor: minimal` and `modes.automation: collaborative`,
with no `project.local.yaml`, unless its own Fixture says otherwise.

---

## Test Cases

### Case 1: Happy path

**Fixture**: input present (the argument shown in the summary) with enough content to judge.

**Input**: `/rulebook-architecture` with that input.

**Expected behavior**:
1. The skill lists what it read before judging
2. Each named check is run and carries evidence or "not found"
3. A verdict from the list above is given, with ranked fixes
4. The save is offered as a question that names `design/craft/rulebook-architecture-[name]-[date].md`

**Assertions**:
- [ ] No finding is stated without evidence from the input
- [ ] Any number is shown with its working or marked as an assumption or rule of thumb
- [ ] Contested advice is labelled as contested

### Case 2: Missing input

**Fixture**: no readable design material and no argument.

**Input**: `/rulebook-architecture`

**Expected behavior**:
1. The skill asks for the input in plain text, or stops
2. The verdict is NOT ASSESSED, naming what is missing

**Assertions**:
- [ ] No report is produced from a title or an invented premise
- [ ] Nothing is written

### Case 3: Save declined

**Fixture**: as Case 1.

**Input**: `/rulebook-architecture`, then the user declines the save.

**Expected behavior**:
1. The report is shown in the conversation
2. No file is created

**Assertions**:
- [ ] No Write call occurs without an explicit yes
- [ ] The reply ends with a next step naming a related craft skill

---

## Protocol Compliance

- [ ] Every AskUserQuestion follows `.claude/docs/automation-modes.md`
- [ ] A skipped or dismissed question is re-asked in plain text, not treated as an answer

---

## Coverage Notes

Behavioural only. The skill's judgement depends on the supplied design, so output quality is
reviewed by a person; this spec checks structure, evidence, honesty about uncertainty and the
write guard.
