# Skill Test Spec: /skill-link-audit

## Skill Summary

`/skill-link-audit` reads a folder of skills (default `.claude/skills`, or a folder given after the
name), audits each `SKILL.md` for frontmatter, naming, description, permissions and hand-off, shows
the links between skills in both directions, and suggests relevant links with a stated reason for
each. It writes only the generated Links block, and only after "May I write the Links block to these
N skills?" is answered yes. It does not change any other line.

---

## Static Assertions (Structural)

- [ ] Frontmatter has `name`, `description`, `argument-hint`, `user-invocable`, `allowed-tools`
- [ ] 2+ phase headings found
- [ ] Contains `COMPLETE`, `NOT ASSESSED` and `BLOCKED`
- [ ] `allowed-tools` includes Write/Edit and "May I write" language is present
- [ ] `allowed-tools` has no Bash grant
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

### Case 1: Happy Path — audit, both directions, suggestions, write on approval

**Fixture**: a folder with three skills: `alpha` (Next Steps names `beta`), `beta` (no links), `gamma`
(description "Use when a sprint is closing", names nothing).

**Input**: `/skill-link-audit path/to/folder`

**Expected behavior**:
1. Inventory lists three skills and their frontmatter status
2. Audit table shows `Permissions OK`, `Hand-off OK` where the sections exist
3. Links shown both ways: `alpha` links to `beta`; `beta` is linked from `alpha`; `gamma` has no links in either direction
4. Suggestions are made only with a reason quoted from both texts
5. "May I write the Links block to these N skills?" is asked before any write
6. On yes, only the block changes; the rest of each file is byte-identical

**Assertions**:
- [ ] Every suggestion has a quoted reason
- [ ] The write question is asked before any file is written
- [ ] After writing, lines outside the block are unchanged
- [ ] Verdict is COMPLETE with counts

### Case 2: Bare Bash grant is a WARN, not a silent pass

**Fixture**: one skill with `allowed-tools: Read, Bash`.

**Expected behavior**: Permissions row reads WARN with the reason "bare Bash pre-approves every command";
the skill is not otherwise changed.

**Assertions**:
- [ ] The row is WARN, not OK
- [ ] Nothing is written

### Case 3: Unreadable file is NOT ASSESSED and named

**Fixture**: one `SKILL.md` is a symlink.

**Expected behavior**: that skill is listed as not read; the verdict is NOT ASSESSED and names it. It is
not counted as audited.

**Assertions**:
- [ ] The symlink is not followed
- [ ] Verdict is NOT ASSESSED and names the skill

### Case 4: Missing folder is BLOCKED

**Input**: `/skill-link-audit no/such/folder`

**Expected behavior**: no inventory; verdict BLOCKED and the path is named.

**Assertions**:
- [ ] Verdict is BLOCKED
- [ ] No file is written

### Case 5: Synced folder warning before writing

**Fixture**: the folder path is a synced upload folder.

**Expected behavior**: before the write question, the skill says the next sync may overwrite the change and
asks whether to go on.

**Assertions**:
- [ ] The sync warning appears before the write question

---

## Protocol Compliance

- [ ] Writes nothing before a yes to the write question
- [ ] Changes only the generated block, never other lines
- [ ] Suggests a link only with a reason from the text
- [ ] Never edits `manifest.json`
- [ ] Ends with a Verdict line

---

## Coverage Notes

- The judgement of whether a suggested link is useful is the user's; the spec checks that a reason is given.
- The skill is an entry point (`.claude/docs/skill-entry-points.txt`), so an orphan is expected.
- No automated runner; review manually or via `/skill-test`.
