# Skill Test Spec: /prose-style

## Skill Summary

`/prose-style` sets the project's writing style guide and checks text against it. `set` (the
default) asks four grouped questions (English variant, dash policy and cap, commas/quotes/
contractions, numbers/capitalisation/register), drafts `design/narrative/style-guide.md` from
`.claude/docs/templates/writing-style-guide.md`, and writes it after "May I write this to
`design/narrative/style-guide.md`?". An existing guide means retrofit: only the named settings
change. `check <path>` reads the guide, runs `.claude/scripts/dash-count.sh --lines` on the paths,
compares forms and density with the policy, and reads the other settings by eye, labelled as such.
Check mode edits nothing. No setting has a default: a blank one is NOT ASSESSED.

---

## Static Assertions (Structural)

- [ ] Frontmatter has `name`, `description`, `argument-hint`, `user-invocable`, `allowed-tools`
- [ ] 2+ phase headings found
- [ ] Contains `COMPLETE` (set) and `NOT ASSESSED`, `DEVIATIONS FOUND`, `CONFORMS` (check)
- [ ] `allowed-tools` includes Write/Edit and "May I write" language is present
- [ ] `allowed-tools` has no bare `Bash`; the shell grants are the config helper and `dash-count.sh`
- [ ] Next-step handoff section present at end

---

## Director Gate Checks

N/A. No director gate is spawned; style is a project preference the user decides.

---

## Fixture Defaults

Every case's `project.yaml` sets `modes.rigor: minimal` and `modes.automation: collaborative`,
with no `project.local.yaml`, unless its own Fixture says otherwise.

---

## Test Cases

### Case 1: Happy Path — set from scratch

**Fixture**: no `design/narrative/style-guide.md`; `design/narrative/` may not exist.

**Input**: `/prose-style`

**Expected behavior**:
1. Four grouped questions are asked; no option is marked "(Recommended)"
2. The dash question names the three policies and says the `oxford` description comes from
   secondary sources and is unchecked against the current New Hart's Rules
3. The cap question says the published styles set no cap and offers 1 / 1.5 / 1 as defaults
4. The full guide is shown, then "May I write this to `design/narrative/style-guide.md`?"
5. Written only after an explicit yes; Verdict COMPLETE with counts of set and blank settings

**Assertions**:
- [ ] Every setting in the written file comes from an answer; none from a skill default
- [ ] Unanswered settings are blank and listed under "Not set" in the draft
- [ ] The file is written only after the write question is answered yes
- [ ] The cap is described as a project choice, not as an Oxford rule

### Case 2: Variant and dash policy asked in autonomous mode

**Fixture**: `modes.automation: autonomous`; no style guide.

**Input**: `/prose-style`

**Expected behavior**: the English variant and the dash policy are asked anyway; the skill does not
log-and-proceed on a default.

**Assertions**:
- [ ] Both questions are asked despite autonomous mode
- [ ] No variant or policy is chosen without an answer

### Case 3: Retrofit — change one setting

**Fixture**: a complete guide with `dash_policy: oxford`; user says to change quotation marks only.

**Input**: `/prose-style`

**Expected behavior**: shows existing settings, asks which to change, shows `quotation_marks`
before and after, asks the write question, edits only that setting.

**Assertions**:
- [ ] The file is not overwritten whole
- [ ] Only `quotation_marks` differs after the write
- [ ] A "go on" is not treated as a yes to the write

### Case 4: Check mode — deviations found

**Fixture**: guide with `dash_policy: oxford`, narrative cap 1; `design/narrative/lore/a.md` contains
2 spaced em dashes, 1 unspaced em dash and a range "10–20" in 150 words.

**Input**: `/prose-style check design/narrative/lore/a.md`

**Expected behavior**: runs `dash-count.sh --lines`; reports the 2 spaced em dashes as form
deviations, the unspaced one as in form, the range as not counted, density 2.00 per 100 words
against cap 1; the by-reading settings are labelled "by reading"; verdict DEVIATIONS FOUND.

**Assertions**:
- [ ] Numbers come from the script rows, not recounted
- [ ] The range is not counted as a dash
- [ ] No file is edited
- [ ] The text type used for the cap is named
- [ ] Verdict is DEVIATIONS FOUND

### Case 5: Check mode — no guide

**Fixture**: no style guide; a text file with dashes.

**Input**: `/prose-style check design/narrative/lore/a.md`

**Expected behavior**: dash checks NOT ASSESSED naming the missing guide; offers `/prose-style set`;
verdict NOT ASSESSED; does not apply any default policy.

**Assertions**:
- [ ] Verdict is NOT ASSESSED, not CONFORMS
- [ ] The missing input is named
- [ ] No default policy is applied

### Case 6: Check mode — unreadable file

**Fixture**: guide complete; one path does not exist.

**Input**: `/prose-style check design/narrative/missing.md`

**Expected behavior**: the `not_read` row is listed by name; the file is not reported as conforming.

**Assertions**:
- [ ] The unread file is named
- [ ] Verdict is not CONFORMS for that file

---

## Protocol Compliance

- [ ] Asks "May I write" before writing the guide
- [ ] Never edits text in check mode
- [ ] A blank setting is NOT ASSESSED, never a pass
- [ ] Known deviations outrank NOT ASSESSED, which outranks CONFORMS in the check verdict
- [ ] Ends with a Verdict line

---

## Coverage Notes

- The by-reading checks (spelling, serial comma, quotes, numbers, contractions) are judgement, not counts;
  no case pins their output beyond the label.
- The `oxford` policy text rests on secondary sources; re-verify against New Hart's Rules when it matters.
- No automated runner; review manually or via `/skill-test`.
