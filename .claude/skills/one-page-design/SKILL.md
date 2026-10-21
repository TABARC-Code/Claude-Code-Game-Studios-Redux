---
name: one-page-design
description: "Authors a one-page design vision for a game: mantra and player fantasy, up to three pillars, mechanical or narrative summary, hook, interface, art style, music and sound. Stress-tests each section and writes design/one-page-design.md."
argument-hint: "[optional: working title or concept hint]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, Edit, AskUserQuestion, Bash(bash "*/.claude/skills/one-page-design/../../hooks/yaml-helper.sh" resolve_config *), Bash(wc -w *)
model: sonnet
---

!`bash "${CLAUDE_SKILL_DIR}/../../hooks/yaml-helper.sh" resolve_config --keys automation,workflow,docs.density`

Resolved above; use as-is. No block: `automation: collaborative`, `workflow: minimal`,
`docs.density: terse`, and say the settings were not read.

# One-Page Design

Puts the vision of a game on one page: what it is, how it should feel, what sets it apart, how it is
played, how it looks and how it sounds. It is for the person who has an idea and needs the whole of
it in one place before the team, or the first prototype, starts pulling it apart.

The seven-section layout is adapted from the one-page game design document template published by
DevPods. The one-page limit follows Stone Librande's GDC talk on one-page designs, the same source
`.claude/docs/templates/game-brief.md` cites: the limit is what forces the real thinking.

**Where it sits.** `/brainstorm` finds a concept and writes the brief (`design/game-brief.md`: MVP,
build order) or the full concept doc. This writes the vision page beside them. It adds what the brief
and the concept doc do not ask for: a mantra the team can settle arguments with, the **interface**
(input method and its limits), and art and sound references with the feeling wanted. Downstream
skills (`/create-stories`, `/map-systems`) read the brief or the concept, not this page; it is a
reference for people and for `/art-bible`, not a gate.

Ask with the question tool. Without one, list the options numbered and end your turn to wait. A
skipped or dismissed question is not an answer: ask again in plain text. Questions follow
`.claude/docs/automation-modes.md`: collaborative asks per section, guided asks only for the hook and
pillars, autonomous drafts from the sources and logs what it chose.

## Phase 1: Inputs

1. Read the text typed after the skill name as the working title or concept hint.
2. Read, by section, whichever of these exist: `design/one-page-design.md` (an existing page means
   **retrofit**: ask which sections to change, touch only those), `design/game-brief.md`,
   `design/gdd/game-concept.md`, `design/gdd/game-pillars.md`.
3. Print a **source table**: each of the seven sections, and where a first draft for it can come
   from (`brief`, `concept`, `pillars`, or `nothing`). Interface is `nothing` in every project that
   has not already written this page: no other skill asks for it. Say so.
4. **No concept at all** (no hint, no source, and the user cannot give one in a sentence): do not
   invent one. Say this page records a game that already has an idea, offer `/brainstorm`, and end
   with `Verdict: **BLOCKED** — no concept to put on a page; run /brainstorm first.`

## Phase 2: The seven sections

One section at a time, in this order. For each: show any draft built from the sources (quoting the
source), ask the question, and offer two or three **wordings of the user's own idea**, not new ideas.
If the user is stuck, use that section's prompts below. Keep each section short; the whole page has to
fit.

**1. Mantra and player fantasy.** One sentence the whole team can quote, and the line "The player
should feel like ...". *Test:* ask the user to name one design argument this sentence would settle.
No argument, no mantra: it is a slogan, and the answer is to rework it or mark the section OPEN.
*Stuck:* finish "A game where you ___ so that you feel ___"; say it to someone who has never seen the
game; what would you cut if the mantra were true?

**2. Design pillars.** At most three, as short phrases. If `design/gdd/game-pillars.md` exists, offer
its three strongest and name the others left off. Each gets its design test: "when we argue about X vs
Y, this picks ___". *Tests:* reject the empty words (fun, polished, immersive, engaging, great
gameplay); ask for one example where two pillars collide, because pillars that never pull against
each other are decoration. More than three: push back and ask which to drop. *Stuck:* what would you
refuse to ship even if it tested well?

**3. Narrative and/or mechanical summary.** What the game is from a play and/or story point of view,
in three to five sentences. *Test:* it names the core verb the player does most, and for a story-led
game says in one line what the story is about. *Stuck:* what does the player do for the first ten
minutes? What do they do in the last ten, and is it the same thing?

**4. Hook.** The one thing that sets the game apart. *Tests:* it can be said as "like [closest game],
and also [this]"; two named references; one clause on what this does that they do not; and the user
says whether a player meets the hook in the first five minutes (`yes` / `no` / `not sure`). A hook the
player meets in hour three is a risk, and the page says so. *Stuck:* what would a player tell a friend
in one breath? What did the closest game get wrong for you?

**5. Interface.** The input method and how the player touches the game. *Tests:* names the main
device (controller, mouse and keyboard, touch, other) and the one input limit that shapes the design
(two buttons, one hand, no keyboard, no precise aiming). Note, as open, anything the user already
knows about accessibility needs: `/ux-design` will take it from there. *Stuck:* what is in the
player's hands at the moment of the hardest decision?

**6. Art style.** References (games, films, paintings, a board link) and three words for the look.
*Test:* at least two named references. None: mark OPEN and say gathering a reference board is the next
action; do not invent references. `/art-bible` turns this into rules.

**7. Music and sound.** References (tracks, playlists, games) and the feeling the sound should cause.
*Test:* at least one reference and one feeling. None: OPEN. Do not invent references.

At `docs.density: thorough`, add a rationale line under sections 2 and 4. At `terse`, leave them out.

## Phase 3: Stress test

Observations, not a verdict. Show a table, one row per check, each `OK`, `WEAK` or `OPEN`, with the
reason in a clause:

| Check | Looks at |
|-------|----------|
| Mantra settles an argument | the argument the user named |
| Pillars | count (3 or fewer), design tests present, no empty words, one collision named |
| Summary | core verb named |
| Hook | closest references named, difference stated, seen in first five minutes |
| Interface | main device and the limiting input both named |
| Art and sound | references present, feelings present |
| Consistency | does any section contradict another (a calm mantra, a frantic hook) |

`WEAK` and `OPEN` are shown to the user and the user decides; nothing here blocks the write.

## Phase 4: Write

Show the whole page, filled from `.claude/docs/templates/one-page-design.md`, with sources and open
sections listed at the foot. Ask as its own question: "Page is ready. May I write it to
`design/one-page-design.md`?" `Yes, write it` / `Revise a section first`. Agreeing to a wording is not
a yes to the write. On a revision, change the named section, show it before and after, and ask again.
Then write the file, creating `design/` if needed.

After the write, run `wc -w design/one-page-design.md` and report the number. The page is meant to
fit about one printed page: 400 words or fewer is the aim, and over 500 is over. Over 500: say so,
name the two longest sections, and offer to trim them. Do not trim without being asked. The count
includes the template's comments, so subtract nothing and say that.

## Phase 5: Hand-offs

Read `workflow` from the config block. Then, in this order:

- `minimal`: if there is no `design/game-brief.md`, `/brainstorm` writes it (the mantra and summary
  carry over as the pitch), then `/create-stories` and `/dev-story`. If the brief exists,
  `/create-stories`. `/art-bible` is not part of the minimal path.
- `standard` or `full`: `/art-bible` (sections 6 and 7 seed it), `/map-systems`, then
  `/prototype [core verb]` to test the hook before the GDDs. Offer the `creative-director` agent
  for the pillars.

End with: `Verdict: **COMPLETE** — one-page design written, [n] of 7 sections filled[, OPEN: list].`

## Recommended Next Steps

- `/brainstorm`: the brief or concept doc this page sits beside
- `/art-bible`: turn sections 6 and 7 into rules
- `/prototype [core verb]`: find out whether the hook is fun
- `/ux-design`: take the interface section into a screen or flow
- `/plan-workflow`: write the roadmap from here to the goal
