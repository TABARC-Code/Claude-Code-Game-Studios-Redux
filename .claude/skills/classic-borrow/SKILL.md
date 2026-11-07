---
name: classic-borrow
description: "Matches a design problem to proven mechanisms from traditional games (race, war, position, sowing, calculation, dice) and adapts them with their balance patches. 'What did old games do about this?'"
argument-hint: "[problem or mechanism wanted, in plain words]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, AskUserQuestion, Bash(bash "*/.claude/skills/classic-borrow/../../hooks/yaml-helper.sh" resolve_config *)
model: sonnet
---

!`bash "${CLAUDE_SKILL_DIR}/../../hooks/yaml-helper.sh" resolve_config --keys automation,docs.density`

# Classic Borrow

Old games survived because their mechanisms work and their balance patches were found by
centuries of players. This is a lookup and adaptation skill. It names a mechanism family, says what
it does at the table, what it costs, and how the original fixed its own weak point.

Every `AskUserQuestion` call follows `.claude/docs/automation-modes.md`.

**Fed by:** `/remix-levers`, `/core-check` (a mechanism the core needs), `/exploit-hunt`.
**Feeds:** `/rules-draft`, `/resolution-tuning`, `/paper-playtest`.
**Loop:** a borrowed mechanism is a hypothesis about your design. Playtest it, note whether it
fixed the problem, and add what you learned to the next lookup.

**Evidence rule.** The historical record of old games is patchy. Many rules are reconstructions
and dates are disputed. Describe the mechanism, not the history, and mark any historical claim
`[uncertain]`. Never present a reconstruction as the original rule. If the user asks for the exact
rules of a historical game, say they are reconstructed and may be wrong.

## Phase 1: Problem

Take the argument. If it is vague, ask for one problem: a tension to create, a swing to calm, an
ending to sharpen, a piece role to add. Do not proceed on "make it feel classic".

## Phase 2: The library

**Race games** (reach the end first, movement by chance).
- Chance narrows choice instead of replacing it: a die that selects which piece may move.
- Split-roll allocation: one throw spent across one, two or three pieces. Unplayable remainders
  are lost, which makes full use the default.
- Stack safety plus hit and re-enter: two pieces on a point cannot be hit, a lone piece sent back
  must re-enter. Risk and defence in one rule.
- Extra-turn rewards for special throws, and exact finish for end-game tension.
- Partners, and printed tracks where squares carry text events that turn a race into a story.

**War games** (capture, immobilise, occupy).
- Capture types: replacement, short leap, long leap, custodian (trap between two), intervention,
  approach or withdrawal, circuit along loops. Each changes what a safe position means.
- Forced capture and majority capture give tactical clarity and puzzle depth.
- Piece conversion and drops: captured material changes side or returns to play, so losers stay
  active.
- Promotion on reaching a far edge, ranks with a capture matrix, immobilisation wins.
- Hunt games with unequal sides: few strong hunters against many weak prey, or a king with
  defenders against a larger attacking force. State the imbalance fix: extra pieces, first move,
  a handicap.

**Position games** (alignment, blocking, territory).
- Placement first, then movement. Rules change when a side is down to few pieces.
- Mills that remove a piece, win by blocking or reduction.
- Balance patches for first-move advantage: forbidden forks, weaker-player-first, handicap stones.
- Anti-loop rules for repeating positions.
- Jump ladders to cross a board, where enemy pieces can be stepping stones.

**Sowing games** (relay-moving seeds, no dice).
- Chain turns through relay sowing, capture by landing in an empty hole.
- Persistent boards from round to round, with losing sides reloading less. Unfillable holes
  retired as a handicap.
- Skill without chance, with chain reactions. Hard to read at first.

**Calculation games.**
- Arithmetic as a combat rule: capture by meeting, multiplication, sum or siege.
- Pre-agreed victory type, so the players negotiate difficulty before play.
- Pieces with numeric identity.

**Dice games.**
- Cover-the-numbers decisions: use the whole roll or its parts, penalised by what remains.
- Wager tables with different odds and a house edge. Know the rake.
- Ritual hardware (towers, rings, cups) as interface, for fairness and for feel.

## Phase 3: Match and adapt

Pick two or three mechanisms that address the problem. For each give: what it does at the table;
what it costs in rules, tokens or teaching; its known weak point and the patch the old game used;
how it changes your core (hand it to `/core-check` if it might add a second core); and a
playtest question. Show the rule delta, not a lecture.

Rank by fit, not by pedigree. Rejecting a classic is an acceptable result.

## Phase 4: Verdict

**GOOD FIT**, **WITH PATCH**, **POOR FIT** or **NOT ASSESSED**, per candidate. Report: the problem,
the candidates in a table, the recommendation, and what to test.

## Phase 5: Save and hand off

`AskUserQuestion`: `[A] Save to design/craft/classic-borrow-[name]-[date].md`, `[B] Draft the rule
with /rules-draft`, `[C] Stop`. Ask "May I write this to that path?" first. Then
`/paper-playtest`.
