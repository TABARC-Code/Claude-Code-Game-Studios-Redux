# Skill Test Spec: /one-page-design

## Skill Summary

`/one-page-design` writes `design/one-page-design.md`, a one-page vision for a game in seven sections
(mantra and player fantasy, up to three pillars, narrative and/or mechanical summary, hook, interface,
art style, music and sound), adapted from the DevPods one-page template. It pre-fills from
`design/game-brief.md`, `design/gdd/game-concept.md` and `design/gdd/game-pillars.md` when present,
asks one section at a time, stress-tests each (mantra settles an argument; pillars three or fewer with
design tests; hook seen in five minutes; interface names input and limit), shows an OK/WEAK/OPEN table,
and writes after "May I write it to `design/one-page-design.md`?". It then runs `wc -w` and reports the
length. It invents no concept: with none, it is BLOCKED and points to `/brainstorm`.

---

## Static Assertions (Structural)

- [ ] Frontmatter has `name`, `description`, `argument-hint`, `user-invocable`, `allowed-tools`
- [ ] 2+ phase headings found
- [ ] Contains `COMPLETE` and `BLOCKED`
- [ ] `allowed-tools` includes Write/Edit and "May I write" language is present
- [ ] `allowed-tools` has no bare `Bash`; the shell grants are the config helper and `wc -w`
- [ ] Names all seven sections and the three-pillar limit
- [ ] Next-step handoff section present at end

---

## Director Gate Checks

N/A. The creative-director is offered for pillars at `standard` and `full`; no gate is spawned.

---

## Fixture Defaults

Every case's `project.yaml` sets `modes.rigor: minimal` and `modes.automation: collaborative`,
with no `project.local.yaml`, unless its own Fixture says otherwise.

---

## Test Cases

### Case 1: Happy Path — filled from the brief, interface asked

**Fixture**: `design/game-brief.md` with a pitch, core loop and art and audio line; no existing page.

**Input**: `/one-page-design`

**Expected behavior**:
1. A source table shows which sections have a first draft and from which file; Interface is `nothing`
2. Sections are asked in order; drafts quote their source and offer wordings of the user's own idea
3. The stress-test table appears before the write ask
4. "Page is ready. May I write it to `design/one-page-design.md`?" is asked; written on yes
5. `wc -w` is run on the file and the count reported

**Assertions**:
- [ ] Interface is asked even though the brief exists
- [ ] No draft contains a reference or fact the user and the sources did not supply
- [ ] The word count comes from `wc -w`, with the comments-included note
- [ ] Verdict COMPLETE with sections filled out of 7

### Case 2: No concept — BLOCKED

**Fixture**: no brief, concept or pillars; the user has no idea to give.

**Input**: `/one-page-design`

**Expected behavior**: no concept is invented; `/brainstorm` is offered; Verdict BLOCKED.

**Assertions**:
- [ ] No file written
- [ ] Verdict is BLOCKED and names `/brainstorm`

### Case 3: Pillars push-back

**Fixture**: `design/gdd/game-pillars.md` has five pillars.

**Input**: `/one-page-design`

**Expected behavior**: offers the three strongest, names the two left off, rejects empty words
("fun", "polished"), and asks for one collision between pillars.

**Assertions**:
- [ ] At most three pillars are written
- [ ] The omitted pillars are named
- [ ] Each written pillar has a design test

### Case 4: Open sections stay open

**Fixture**: user supplies no art or sound references.

**Input**: `/one-page-design`

**Expected behavior**: Art style and Music and sound are marked OPEN with the question that would fill
them; no references are invented; Verdict COMPLETE names the OPEN sections.

**Assertions**:
- [ ] The two sections read "OPEN:" in the file
- [ ] The Verdict line lists them
- [ ] The stress-test table shows OPEN for them

### Case 5: Retrofit

**Fixture**: an existing `design/one-page-design.md`; user changes only the hook.

**Input**: `/one-page-design`

**Expected behavior**: asks which sections to change, shows the hook before and after, asks the write
question, edits only that section.

**Assertions**:
- [ ] The other six sections are byte-identical after the write
- [ ] The write question is asked before the edit

### Case 6: Over one page

**Fixture**: the finished page is 540 words by `wc -w`.

**Input**: `/one-page-design`

**Expected behavior**: reports the count, says it is over 500, names the two longest sections, offers to
trim, and does not trim unasked.

**Assertions**:
- [ ] The page is not edited without a yes
- [ ] The two longest sections are named

---

## Protocol Compliance

- [ ] Asks "May I write" before writing
- [ ] Invents no concept, reference or fact
- [ ] Hand-offs follow `workflow`: `minimal` does not list `/art-bible`
- [ ] States that downstream skills read the brief or concept, not this page
- [ ] Ends with a Verdict line

---

## Coverage Notes

- Quality of the wording is the user's; the spec checks the checks, not the prose.
- The page is not in `workflow-catalog.yaml`; `/help` lists it under "Also installed".
- No automated runner; review manually or via `/skill-test`.
