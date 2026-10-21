# prose-style

Every project I've worked on has had the same argument about halfway through. Is it *colour* or *color*? Single quotes or double? Why has the narrator suddenly started using spaced dashes? Nobody decided. It just happened, one file at a time.

This skill makes the decision once, writes it down, and then checks text against it.

## What it does

`/prose-style` asks you a handful of questions and writes `design/narrative/style-guide.md`:

- which English (British with -ise, British with -ize and -our as Oxford University Press spells it, American, Canadian, Australian, or something else you name)
- a dash policy: `oxford` (unspaced em dash), `british-spaced-en` (spaced en dash), or `none`
- how many dashes per 100 words you'll put up with
- serial comma, quotation marks, contractions, how numbers are written, which terms get capitals
- an optional narrator register, and any period or regional exceptions (a western in American English inside a British project, say)

`/prose-style check <path>` then measures a file. The dash maths comes from `.claude/scripts/dash-count.sh`, not from the model squinting at the page. The softer rules (spelling, commas, quotes) are read by eye, and the report labels them that way.

## Things I'd rather you knew

Nothing has a default. If a setting's blank, the check says "not assessed". It doesn't quietly assume you meant UK English. That was deliberate; a silent default is how the argument starts in the first place.

The `oxford` policy is described from secondary sources. I haven't checked it against the current *New Hart's Rules*, and the skill says so when it asks. The dash *cap* isn't an Oxford rule at all. Nobody publishes one. The default of one per 100 words is an editing rule of thumb, so change it if you disagree.

It doesn't rewrite anything. When the check finds problems, `/rewrite-text` does the fixing.

## Files

Writes: `design/narrative/style-guide.md` (after asking).
Reads: that file, plus the paths you give it in check mode.
Template: `.claude/docs/templates/writing-style-guide.md`.

Author: TABARC-Code
