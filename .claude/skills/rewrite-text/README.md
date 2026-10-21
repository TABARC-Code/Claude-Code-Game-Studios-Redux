# rewrite-text

Machine-written game text has a smell. Everyone's brave, loyal and true. A shiver runs down somebody's spine. The shopkeeper explains the plot to a customer who was there for it. You can't always say what's wrong, only that no one would talk like that.

`/rewrite-text` takes lines you already have and fixes the ones that smell.

## How it works

1. **Inventory first.** It lists what it found: the text, the speaker's Voice Profile, the style guide, the length limit, any lines you've marked fixed. What's missing gets named, and the cost of it. "Tobin has no sheet, so voice isn't assessed."
2. **Diagnose.** Each line is tagged against a list of machine-writing patterns (`references/ai-patterns.md`) and the craft failures in `.claude/docs/dialogue-craft.md`. A line with nothing wrong is reported as kept. It doesn't rewrite for the sake of looking busy.
3. **Rewrite.** Smallest change that works. Facts stay, keys stay, speaker tags stay, every `{placeholder}` stays exactly as it was.
4. **Verify with scripts.** `line-check.sh` checks lengths and placeholder sets. `dash-count.sh` checks dashes against your style guide. The model reads the numbers; it doesn't count.
5. **Ask before writing.** Proposal file, in-place edit, or show only.

## What it won't do

Invent lore, prices, mechanics or jokes. If a line's flat because the scene gives the speaker nothing to want, it says so and hands it to the `writer` agent. It won't touch lines you've marked fixed, won't translate, and it won't plant typos to look human. Variety of rhythm does that job. Planted errors just make a localiser's week worse.

If a voice profile or a style setting is missing, the verdict says `NOT ASSESSED` for it. It's never folded into a plain "complete".

## Files

Reads: your text, `design/narrative/characters/<name>.md` (Voice Profile section), `design/narrative/style-guide.md`.
Writes: only after asking, either `production/narrative/rewrites/<slug>-rewrite.md` or the source file.
Scripts: `.claude/scripts/line-check.sh`, `.claude/scripts/dash-count.sh`.

The pattern families come from public guidance on spotting machine-made prose, including Wikipedia's "Signs of AI writing". The wording and the game examples are mine.

Author: TABARC-Code
