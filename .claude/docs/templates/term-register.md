# Term Register: [Game Name]

Read and written by `/term-register`; read by `/rules-draft`, `/keyword-audit`, `/rulebook-architecture` and `/localize`. Lives at `design/rules/term-register.md`.

*Created: [Date]*
*Owner: [name or role]*
*Register position: [plain prose | between | keyword shorthand], see entry P-01*
*Keyword formatting: [italic | bold | brackets], see entry P-02*

This file is the authority. Any glossary, keyword list or localisation glossary elsewhere is a view
generated from it. If a view disagrees with this file, this file wins and the view is regenerated.

## Categories

| Category | Meaning |
|---|---|
| lexicon | A word choice for an ordinary concept. Rejected alternatives are noted. |
| keyword | A formatted term other rules cite. Needs Shape and Formatting. |
| game term | A defined compression for a recurring phrase. |
| mechanic pattern | A locked structural convention (continuous marker, agency split, a named keyword family). |
| project setting | A standing decision (register position, formatting, victory attribution rules). |

## Statuses

| Status | Meaning |
|---|---|
| locked | In force. First use locks at once; locking is not provisional. |
| under review | Being revised through the procedure below. Do not use in new text until relocked. |
| deprecated | No longer used in new text. Kept for older supplements. |

Shapes for keywords: `1 bare tag`, `2 parameterised`, `3 compound phrase`, `4 compound-parameterised`
(see `.claude/docs/craft/keyword-shapes.md`). Leave Shape empty for other categories.

## Entries

The first six rows are the minimum before any rule is drafted.

| ID | Term | Category | Definition | First used | Formatting | Status | Shape |
|---|---|---|---|---|---|---|---|
| L-01 | [pick / select / choose] | lexicon | Selection verb. Rejected: [the other two]. | [file, heading] | plain | locked | |
| L-02 | [can / may] | lexicon | Permission modal. Rejected: [other]. | [file, heading] | plain | locked | |
| L-03 | [board / table / map / field] | lexicon | Play-surface noun. Rejected: [others]. | [file, heading] | plain | locked | |
| L-04 | [game / battle / round] | lexicon | Name of the activity. Rejected: [others]. | [file, heading] | plain | locked | |
| L-05 | [the player wins / the side wins] | lexicon | Victory attribution. Rejected: [other]. | [file, heading] | plain | locked | |
| P-01 | Register position | project setting | [plain prose / between / shorthand], with the reason and the sample it was chosen from. | [date] | n/a | locked | |
| P-02 | Keyword formatting | project setting | [italic / bold / brackets] for every keyword, without exception. | [date] | n/a | [status] | |
| M-01 | Agency split | mechanic pattern | [who acts: e.g. people pick and roll, pieces move and attack]. Applies to victory text. | [file, heading] | n/a | [status] | |
| M-02 | Continuous and resolved-once markers | mechanic pattern | Continuous effects use `while [condition]`; resolved-once effects use `becomes [status] until [end]`. | [file, heading] | n/a | [status] | |
| K-01 | [Keyword] | keyword | [Full definition. For shapes 2 and 4, each slot's legal range or closed list.] | [file, heading] | [format] | [status] | [1-4] |
| G-01 | [Game term] | game term | [Full definition, never abbreviated.] | [file, heading] | [bold at first use] | [status] | |

## Keyword families

| Family ID | Name | Members | Shared rule |
|---|---|---|---|
| F-01 | [family name] | [K-IDs] | [what rules may say about the family as a whole] |

## Revision procedure

1. Set the entry to under review.
2. State the drafting problem it causes (a real problem, not a preference).
3. List every use, in every document, with file and heading.
4. Confirm the change with the author.
5. Update every use in one pass, relock, and add a change-history line.

## Change history

| Date | Entry ID | Term | Change | Reason |
|---|---|---|---|---|
| [date] | [ID] | [term] | [locked / renamed / reshaped / deprecated] | [reason] |

## Crosscheck notes (advisory)

| Entry ID | Note type | Note | Decision |
|---|---|---|---|
| [ID] | [convergence / collision / shape corroboration] | [one line] | [kept / renamed, not reopened] |
