---
name: skill-link-audit
description: "Reads a folder of skills, audits each one's structure, naming and permissions, shows which skills link to which in both directions, and suggests relevant links with a stated reason. Writes the generated Links block only after you approve. Works on this project's skills or any folder you point it at."
argument-hint: "[folder, default .claude/skills]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, Edit, AskUserQuestion
model: sonnet
---

# Skill Link Audit

Audits a folder of skills and suggests how they should link. It is for a library you have
collected, as well as this project's own skills. It reads first, suggests second, and writes
only when you say yes.

Ask with the question tool. Without one, list the options numbered and end your turn to wait.
A skipped or dismissed question is not an answer: ask again in plain text.

## Phase 1: Locate and inventory

1. The folder is the text typed after the skill name, or `.claude/skills` if none. If it does not
   exist, the verdict is `BLOCKED` and you name the path you tried.
2. Find every `SKILL.md` under the folder (Glob `**/SKILL.md`). Do not follow symlinks; list any
   symlink as not read. If a `manifest.json` sits in the folder, read it as a cross-check of
   names only. It is never edited.
3. For each skill, read the frontmatter and the Next Steps section (or the last section, if there
   is none). Print an inventory: skill, folder, name, description length, lines, and whether the
   frontmatter parsed.

## Phase 2: Audit each skill

Each check gives `OK`, `WARN` or `NOT ASSESSED`, with the reason in one clause. Nothing here blocks
anything; the user decides what to fix.

| Check | OK when | WARN when |
|-------|---------|-----------|
| Frontmatter | Opens and closes with `---`, and has `name` and `description` | Missing or unclosed field. `NOT ASSESSED` if the file could not be read |
| Name | `name` matches its folder | Mismatch, or a name used by another skill in the folder |
| Description | Says when to use the skill (for example "Use when", "Use this") | Says what it is but not when. A vague one reads as a vague skill |
| Permissions | `allowed-tools` lists named tools or scoped shell commands | A bare `Bash`, `PowerShell` or `*`, which pre-approves every command |
| Hand-off | Has a Next Steps or equivalent closing section | None found. Informational, not a fault for a skill that stands alone |

For a full scan of any skill for injected instructions and data-leak patterns, suggest running
`bash .claude/scripts/skill-scan.sh --path <folder>/<skill>` where that helper exists. This audit
does not replace it.

## Phase 3: Links in both directions

For each skill, find the other skills in this folder that its text names. A name counts when it
appears as `/name` or as a backticked skill name, and matches a skill folder here. Names that match
nothing in this folder are listed as `not in this folder`: that is not an error, because they may
belong to another library.

Print the two directions for each skill, in this form:

```
Links to: `/a`, `/b`
Linked from: `/c`
```

Then list:
- **Orphans:** skills nothing links to. Ask which of them are entry points, started directly by a
  person. Entry points stay as they are; the rest need a link from somewhere.
- **Dead ends:** skills that link to nothing in this folder.

## Phase 4: Suggest relevant links

For skill pairs that do not link either way, compare their descriptions and Next Steps. Suggest up
to three links per skill. Each suggestion needs a reason quoting the words in both texts that
connect them. A suggestion with no reason in the text is not made. If a skill's description is too
thin to judge, its row reads `NOT ASSESSED` and says so.

Show the suggestions as a table: from, to, reason. Then ask which to add: `Add all` / `Only the ones
I pick` / `None`.

## Phase 5: Write (only on approval)

Ask as its own question: "May I write the Links block to these N skills?" List the paths. Options:
`Yes, write them` / `Only the ones I pick` / `Show only`. Agreeing to a suggestion is not a yes to the
write.

When you write:
- Change only the generated Links block, the one bounded by the skill-links start and end markers.
  If the skill has none, append one at the end of its `SKILL.md`. Never touch any other line.
- Use the same block format as this project's `skill-links.sh`: a `## Links` heading, then
  `Links to:` and `Linked from:`.
- A suggested link goes into the block only. Add it to the skill's own text only if the user asks,
  because the text is the author's.
- Before writing into a folder that a sync manages (a synced upload folder, for example), say that
  the next sync may overwrite the change. Ask whether to go on.

After writing in this project, run `bash .claude/scripts/skill-links.sh --check` and report its
summary line. Outside this project, say the check was not run.

End with one verdict line:
- `Verdict: **COMPLETE** — [n] skills audited, [m] links suggested, [k] blocks written.`
- `Verdict: **NOT ASSESSED** — [n] skills could not be read: [names].`
- `Verdict: **BLOCKED** — folder not found: [path].`

## Recommended Next Steps

- `/skill-test static [name]`: structural checks on one skill
- `/skill-improve [name]`: test, fix and retest a skill's text


<!-- skill-links:start -->
## Links

Generated by `.claude/scripts/skill-links.sh --write`. Change the skill's text, not this block.

Links to: `/skill-improve`, `/skill-test`
Linked from: none (entry point)
<!-- skill-links:end -->
