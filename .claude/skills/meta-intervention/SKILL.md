---
name: meta-intervention
description: "Decides whether and how to act on a live dominant strategy, mandatory card or dead card: evidence floors, meta or systemic cause, buff before nerf, the smallest step on a graded ladder, a reintroduction test for bans, the announcement and a review date."
argument-hint: "[path-to-match-data-or-report | card or strategy name]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, AskUserQuestion, Bash(bash "*/.claude/skills/meta-intervention/../../hooks/yaml-helper.sh" resolve_config *)
model: sonnet
---

!`bash "${CLAUDE_SKILL_DIR}/../../hooks/yaml-helper.sh" resolve_config --keys automation,docs.density`

# Meta Intervention

When one strategy dominates a live game, the loudest fix is rarely the right one. Players feel a
dominance before the data shows it, and a ban that answers a feeling costs trust and collections.
This skill asks whether the evidence is enough to act, whether the cause is the current meta or the
system itself, and which is the smallest step that restores choice. It then drafts the
announcement and sets a date to check the result. Every numeric threshold here is a rule of thumb
to test against your own game, not a law.

Every `AskUserQuestion` call follows `.claude/docs/automation-modes.md`. A skipped or dismissed
question is not an answer: re-ask in plain text.

**Honest reporting.** Name every phase or check that did not run under a `Not run` heading, with the reason. A silent skip reads as a pass. `NOT ASSESSED` outranks the pass verdict, and never outranks a failure verdict: a run that skipped part of its scope cannot return the pass value, and a known fault is reported ahead of an unknown.

**Fed by:** `/paper-playtest`, `/playtest-report`, `/balance-check`, `/expansion-plan`.
**Feeds:** `/patch-notes`, `/rules-draft` (errata text), `/team-live-ops`, `/expansion-plan`.
**Loop:** the review date in Phase 7 brings the same question back with new data. Record each
intervention and its result, so the next one starts from what the last one did.

## Phase 1: Evidence

1. Read the argument: match data, a playtest report, or a named card or strategy. Ask for data in
   plain text if none is given. List what you read.
2. **Sample floors (rules of thumb):**
   - Under 20 games in a matchup: no claim about that matchup. **NOT ASSESSED** for it.
   - Under 50 games across the field for the strategy: no balance claim. **NOT ASSESSED**.
   - Around 100 games or more before describing the whole meta.
   Report the count for every figure you quote.
3. **Signals of dominance (rules of thumb):** win rate above about 60 per cent against the field;
   inclusion in over 80 per cent of decks (mandatory) or 0 per cent (dead); the meta collapsing to
   two decks; archetypes vanishing; first-seat win rate above about 55 per cent.
4. **Perception against data:** write what players say, then what the numbers say. Where they
   disagree, say so; perception alone does not justify a balance change, though it may justify
   communication.

## Phase 2: Meta or systemic

- **Meta:** the strategy is strong because its counters are unpopular or not yet found. It has
  answers in the current pool that do well against it. Test: name the counter decks and their
  record against it. Meta problems often fix themselves within a few weeks of exploration.
- **Systemic:** the strategy exploits a rule (a resource cap, a first-player edge, a keyword pair)
  and no card in the pool answers it at fair cost. Name the rule.
- Release timing: within the first one to four weeks after a release, the meta is still exploring
  (rule of thumb). A finding in that window leans towards waiting unless it is systemic.

## Phase 3: Buff before nerf

Before touching the dominant strategy, list what would make two or three weaker strategies
competitive against it. Buffing the field preserves collections and the fun of the top deck.
Record why each buff was rejected if you go on to a nerf. Watch for over-correction: a buff that
creates a new dominant deck is not a fix.

## Phase 4: The graded ladder

Pick the lowest rung that solves the problem. Each rung costs more trust than the one before.

| Rung | Step | Note |
|---|---|---|
| 1 | Counter content in the next set | Slow; fine for meta problems |
| 2 | Buff alternatives | See Phase 3 |
| 3 | Cost change, usually one step | Low risk on digital |
| 4 | Restrict (one copy, or format-specific limit) | Keeps a loved card playable |
| 5 | Clarity errata | Only where the text was misread, not to change power |
| 6 | Rotation or format quarantine | Uses the published schedule |
| 7 | Ban | With data, a public reason and notice |
| 8 | Power errata | Last resort: printed cards stop meaning what they say |

For the chosen rung, state the cost to each player motivation: builders (lost decks), competitors
(meta shift), collectors (value of owned cards), casual players (often unaffected; say so). Digital
patches: keep a patch to a handful of cards, roughly five to ten (rule of thumb), so effects can be
traced. Text changes are higher risk than number changes.

## Phase 5: Reintroduction test (bans only)

For each banned or restricted card under review, rebuild the old broken deck with the current pool.
If it is no longer dominant, and no newer card does the same job more safely, consider
unbanning. If a newer card already fills the role safely, leave the old card out. Keep a permanent
ban only for a card dominant in every legal context.

## Phase 6: Announcement draft

Order: acknowledge what players have experienced; show the data with sample sizes; list the
alternatives considered and why they were not chosen; state the decision and its effective date;
say why this rung; give the review date. Competitive changes get at least a week's notice (rule of
thumb). No defensiveness, no filler, no promises the next set cannot keep.

## Phase 7: Review date

Set a date to re-run this skill with new data, normally after enough games to clear the Phase 1
floors again. Name the metric that would show success and the one that would show over-correction.

## Phase 8: Verdict and report

First match wins:

- **ACT NOW:** floors met, cause systemic or dominance severe, and a ladder rung chosen with its
  cost stated.
- **WAIT FOR CONTENT:** floors met, cause is meta or a counter is scheduled, the fix is rung 1.
- **NOT ASSESSED:** a floor not met for the claim made, no data, or a phase not run. Name each.
- **MONITOR:** floors met, no dominance signal fired, every phase run. Set the review date anyway.

Report sections: Sources read, Evidence table with sample sizes, Perception against data, Cause,
Buffs considered, Rung chosen and costs, Reintroduction results, Announcement draft, Review date,
Verdict, `Not run`.

## Phase 9: Save and hand off

`AskUserQuestion`: `[A] Save to design/craft/meta-intervention-[name]-[date].md`, `[B] Turn the
announcement into patch notes with /patch-notes now`, `[C] Stop`. Ask "May I write this to that
path?" first and write only on [A]. Next: `/patch-notes` for the announcement, `/rules-draft` for
any errata wording, `/team-live-ops` for scheduling, `/expansion-plan` for counter content.
