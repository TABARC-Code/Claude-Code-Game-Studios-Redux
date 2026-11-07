---
name: faction-forge
description: "Builds or audits the sides of a game so each is distinct at every layer of a six-layer identity stack, has a war rationale with stakes for both sides, a stated weakness and a win path against every rival, and can be recognised from its rules alone."
argument-hint: "[path-to-faction-doc-or-GDD | 'new']"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, AskUserQuestion, Bash(bash "*/.claude/skills/faction-forge/../../hooks/yaml-helper.sh" resolve_config *)
model: sonnet
---

!`bash "${CLAUDE_SKILL_DIR}/../../hooks/yaml-helper.sh" resolve_config --keys automation,docs.density`

# Faction Forge

Two sides that share a belief and a mechanic are one side in two colours. Real asymmetry lives in
what a faction does that no other faction does, what it is bad at, and why it is fighting at all.
This skill builds each faction up through six layers, then compares every pair. It fits card
games, wargames, skirmish games and strategy games with distinct sides. For the setting itself,
start at `/world-seed`; for pricing the pieces, go on to `/unit-costing` or `/card-forge`.

Every `AskUserQuestion` call follows `.claude/docs/automation-modes.md`. A skipped or dismissed
question is not an answer: re-ask in plain text.

**Honest reporting.** Name every phase or check that did not run under a `Not run` heading, with the reason. A silent skip reads as a pass. `NOT ASSESSED` outranks the pass verdict, and never outranks a failure verdict: a run that skipped part of its scope cannot return the pass value, and a known fault is reported ahead of an unknown.

**Fed by:** `/world-seed` (setting and conflicts), `/core-check` (the core each faction bends).
**Feeds:** `/unit-costing`, `/card-forge`, `/keyword-audit`, `/scenario-forge`, `/expansion-plan`.
**Loop:** playtests show which factions blur in play. Bring the matchup notes back here and
re-run the distinctness matrix; a pair that blurs twice needs a layer redesigned, not a stat.

## Phase 1: Load factions and the conflict

1. Read the argument. A path means read it plus any setting document and keyword glossary it
   links. `new` means ask in plain text for the faction names and one sentence each.
2. List what you read. No factions named anywhere: stop with **NOT ASSESSED**.
3. Count the factions. Three to five is a comfortable range for a launch pool (rule of thumb):
   two leaves no room to choose, more than five stretches every pairwise test. Report the count.
4. **War rationale.** Name why the factions fight and classify it: survival, territory, ideology,
   artefact, revenge or honour, proxy war. The rationale must be understandable from each side and
   give real stakes to both. A conflict where one side is merely in the way is a finding.

## Phase 2: Six-layer identity stack

Fill these per faction from the document's own words. Where it is silent, write `not stated`.

| Layer | Question | Weak answer |
|---|---|---|
| 1. Belief | What does it hold true or want? | "They are evil" |
| 2. Doctrine | How does that belief fight? | Same doctrine as another faction |
| 3. Look and sound | Shapes, colours, voice, naming | Identity carried by art alone |
| 4. Mechanical identity | What only it does: two to five own keywords or rules, and its relationship with resources | Renamed copies of shared keywords |
| 5. Weakness profile | What it is reliably bad at | "None" or "slightly lower stats" |
| 6. Narrative role | Its part in the story and how it changes | Exists only to be fought |

Faction sentence test: "plays [style] because in the fiction they are [identity]". If the sentence
cannot be written, or reads as true of another faction, layers 1, 2 and 4 are disconnected.

## Phase 3: Mechanics state the world

For each faction, list three rules and the setting fact each implies (a unit that never retreats
says "fanatical"; unreliable power says "power costs"; a short command range says "command is
fragile"). Then the blind read: from the rules alone, with names and art stripped, could a reader
say which faction this is and roughly what it believes? Record the read as yes, partial or no.
Where possible, ask someone who has not seen the fiction. If you can only read it yourself, say so:
a designer cannot read their own faction blind.

## Phase 4: Pairwise distinctness matrix

Derive every pair from the faction list (n factions give n times (n minus 1) over 2 pairs). For
each pair, compare layers 1, 2, 4 and 5 and mark each `same`, `close` or `distinct`.

- Matching on belief **and** mechanical identity: **redundant pair**.
- Two or more `close` layers: blurred pair, worth a note.
- Each pair also needs a stated **win path for each side** against the other: how A beats B and
  how B beats A. A side with no stated path in a matchup is a finding.

Report the number of pairs derived and the number checked. Unchecked pairs are named.

## Phase 5: Weakness and counter

1. Every faction states a weakness that an opponent can actually exploit with cards or units that
   exist in the pool. A weakness nothing exploits is decoration.
2. Every faction can answer its worst matchup somehow, even at poor odds. A matchup with no answer
   at all is a lock.
3. Count threats and answers per faction if pieces exist. A ratio beyond about 3:1 either way is a
   signal (rule of thumb, see `.claude/docs/craft/card-balance-lexicon.md`).
4. Neutral or shared pieces: keep them a minority (under roughly 15 to 20 per cent of the pool is a
   common target, rule of thumb) and pay a flexibility tax, or factions blur through them.

## Phase 6: Headroom and drift

1. Is each faction's keyword scope strict (own, shared, universal)? Adding a faction later is a
   structural change and only works if scope was strict from the start. Never add a faction to fix
   a meta.
2. Does any faction have room for two more sets without repeating itself? Name its next unused
   expression.
3. Live games: is one faction growing stronger set after set? Say which evidence shows it.

## Phase 7: Verdict and report

First match wins:

- **REDUNDANT:** at least one pair matches on belief and mechanical identity.
- **LOCKED:** a side has no win path in some matchup, or a faction has no stated weakness.
- **CONCERNS:** blurred pairs, a one-sided war rationale, a failed sentence test, a blind read of
  `no`, or a weakness nothing exploits.
- **NOT ASSESSED:** fewer pairs checked than derived, layers left `not stated`, no pieces to test
  weaknesses against, or the blind read not done by someone else. Name each gap.
- **DISTINCT:** every layer filled, every pair checked, every matchup has paths both ways, no
  findings.

Report sections: Sources read, Rationale and type, Stack per faction, Faction sentences, Mechanics
to world table, Pair matrix (derived and checked counts), Weakness map, Headroom, Verdict, Top
three fixes, `Not run`.

Contested ground [contested]: some designs use mirror factions on purpose, for teaching or
tournament fairness. If the user chooses symmetry, report what it costs in identity and keep it.

## Phase 8: Save and hand off

`AskUserQuestion`: `[A] Save to design/craft/faction-forge-[name]-[date].md`, `[B] Rebuild the
weakest faction's stack with me now`, `[C] Stop`. Ask "May I write this to that path?" first and
write only on [A]. Next: `/unit-costing` or `/card-forge` to price each faction's pieces,
`/keyword-audit` for faction keywords, `/scenario-forge` to give each matchup a battlefield.
