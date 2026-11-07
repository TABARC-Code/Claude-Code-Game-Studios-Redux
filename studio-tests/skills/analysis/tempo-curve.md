# Skill Test Spec: /tempo-curve

## Skill Summary

`/tempo-curve [path-to-rules-or-scenario | 'new']` Designs or audits how a session develops over time: the lethality and swing curve round by round, the tipping point, comeback layers and spike caps, and the whole-session arc from opening to resolution. Catches games decided in round one, grinds, sagging middles, overstays and anticlimactic reveals. Reports end with a verdict; the verdict words are FRONT-LOADED, GRINDING, SAGGING, CONCERNS, NOT ASSESSED, ARCED. The
report is saved to `design/craft/tempo-curve-[name]-[date].md` only after "May I write this to ...?" and an explicit yes. No director
gates are invoked.

---

## Static Assertions (Structural)

- [ ] Frontmatter has `name`, `description`, `argument-hint`, `user-invocable`, `allowed-tools`
- [ ] 2+ phase headings found
- [ ] Contains the verdict keywords: FRONT-LOADED, GRINDING, SAGGING, CONCERNS, NOT ASSESSED, ARCED
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

**Input**: `/tempo-curve` with that input.

**Expected behavior**:
1. The skill lists what it read before judging
2. Each named check is run and carries evidence or "not found"
3. A verdict from the list above is given, with ranked fixes
4. The save is offered as a question that names `design/craft/tempo-curve-[name]-[date].md`

**Assertions**:
- [ ] No finding is stated without evidence from the input
- [ ] Any number is shown with its working or marked as an assumption or rule of thumb
- [ ] Contested advice is labelled as contested

### Case 2: Missing input

**Fixture**: no readable design material and no argument.

**Input**: `/tempo-curve`

**Expected behavior**:
1. The skill asks for the input in plain text, or stops
2. The verdict is NOT ASSESSED, naming what is missing

**Assertions**:
- [ ] No report is produced from a title or an invented premise
- [ ] Nothing is written

### Case 3: Save declined

**Fixture**: as Case 1.

**Input**: `/tempo-curve`, then the user declines the save.

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
