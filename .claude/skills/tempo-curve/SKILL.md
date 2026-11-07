---
name: tempo-curve
description: "Designs or audits how a session develops over time: the lethality and swing curve round by round, the tipping point, comeback layers and spike caps, and the whole-session arc from opening to resolution. Catches games decided in round one, grinds, sagging middles, overstays and anticlimactic reveals."
argument-hint: "[path-to-rules-or-scenario | 'new']"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, AskUserQuestion, Bash(bash "*/.claude/skills/tempo-curve/../../hooks/yaml-helper.sh" resolve_config *)
model: sonnet
---

!`bash "${CLAUDE_SKILL_DIR}/../../hooks/yaml-helper.sh" resolve_config --keys automation,docs.density`

# Tempo Curve

A game can be balanced on average and still feel wrong because of *when* things happen. The first
round decides it, or nothing decisive happens until the clock runs out, or the middle repeats itself
and the end is arithmetic. This skill maps what each stretch of a session does, then checks the
opening, the tipping point, the comeback layers, the spikes and the finish. It fits skirmish and
battle games, races, engine builders and any design with rounds or a visible end. Reference:
`.claude/docs/craft/negative-feedback.md` (layers, not-charity test, arc table, damping list).

Every `AskUserQuestion` call follows `.claude/docs/automation-modes.md`. A skipped or dismissed
question is not an answer: re-ask in plain text.

**Honest reporting.** Name every phase or check that did not run under a `Not run` heading, with the reason. A silent skip reads as a pass. `NOT ASSESSED` outranks the pass verdict, and never outranks a failure verdict: a run that skipped part of its scope cannot return the pass value, and a known fault is reported ahead of an unknown.

**Fed by:** `/activation-design`, `/resolution-tuning`, `/scenario-forge`, `/exploit-hunt`
(snowball findings), `/paper-playtest` and `/playtest-report` ("over by round two", "dragged").
**Feeds:** `/scenario-forge` (end triggers, objective timing), `/unit-costing`, `/remix-levers`
(pace group), `/table-feel` (trailing-player engagement), `/paper-playtest` (a per-round column).
**Loop:** a playtest records per-round state, the curve is redrawn here from what happened, not
from what the rules intended. Keep each pass's curve in the report so the next one shows movement.

## Phase 1: Load

1. Read the rules, the scenario and any playtest notes. `new` means ask in plain text for the round
   or turn structure, the end condition, force or engine size and target session length.
2. Record: round cap or end trigger, expected session length, player count, force or tableau size.
   Mark each `stated` or `not stated`. Do not invent a round cap.
3. Nothing playable to read: stop with **NOT ASSESSED** and name the missing input.

## Phase 2: Session arc

Split the session into four stretches and say what each does in the current rules:

| Stretch | Should feel | Typical share of time (rule of thumb) |
|---|---|---|
| Opening | quick, accessible decisions, positions taken | short |
| Middle | longest, options widening, plans maturing, escalation | most |
| Late | converging on a visible end trigger, stakes rising | short to medium |
| Resolution | fast, the result readable and explainable | very short |

Check each failure and cite the rule or note that causes it, or write `not found`:

- **Slow start:** setup or early turns with no real choice. Measure time to first meaningful choice.
- **Sagging middle:** turns that look alike, no escalation, the same best action every turn.
- **Overstay:** the winner is clear well before the end and play continues anyway.
- **Anticlimactic reveal:** final scoring is arithmetic nobody can predict or feel; the drama
  happened earlier or never.

Levers to name: escalation curves (costs, rewards or threat rising), timers (countdown, depletion,
event deck), phase compression (fewer, larger late turns), a visible end trigger players can race
or delay, a concession convention when the result is clear.

## Phase 3: Lethality and swing per round

For rounds or turns 1 to the cap, estimate: expected losses or points moved (low, medium, high),
decisions available, and how far one round's result can swing the outcome. Compare with the arc
table in `negative-feedback.md`: positioning, first contact, crisis, resolution, optional last
stand. The first round must never be the most decisive. These figures are estimates; say so, and
replace them with playtest counts as soon as they exist.

## Phase 4: Opening

1. Can the first player or first strike decide the game before the other side acts? Check first
   seat at every player count.
2. If the opening is too sharp, pick damping from the list in `negative-feedback.md` (range caps,
   staggered arrivals, late scoring, protected deployment, locked abilities and so on). Pick one or
   two, never all: over-damping produces a dead first round, which is a slow start.

## Phase 5: Tipping point

Slow even attrition grinds. Look for a threshold where accumulated damage, stress or progress drops
capability sharply, so a player who preserved reserves or options can commit them decisively.

- Is there a threshold state? Name it, or write `none`.
- Does preserving reserves pay off when it is crossed?
- Is the swing delayed but clear, or linear grind? Grind with no tipping point is **GRINDING**.

## Phase 6: Comeback and spikes

1. List every negative feedback mechanism by layer (visible, scenario, activation, unit, tempo,
   resource, hidden or environmental). Missing layers are not faults in themselves.
2. Apply the not-charity test to each: transparent, fits the fiction, mild, built in. A boost that
   fails two of the four reads as charity and players resent it.
3. Positive feedback: where does a lead buy more lead? Is it capped or offset?
4. Small formats: if each piece is a large share of the force, expect amplified swings and call
   for heavier correction (see the small-format section of the reference).
5. Spikes: criticals that multiply, unbounded chains, one roll ending the game. Name a cap from the
   reference for each. Swing should be proportional to the risk a player chose to take.

## Phase 7: Verdict and report

First match wins:

- **FRONT-LOADED:** round one, first seat or first strike is the most decisive moment, or a spike
  can end the game before the other side responds.
- **GRINDING:** no tipping point; outcome set by slow attrition or by the clock.
- **SAGGING:** the opening and finish work but the middle sags, the game overstays, or the end is an
  anticlimactic reveal.
- **CONCERNS:** a runaway lead goes uncorrected, a comeback fails the not-charity test, or one
  stretch is weak without failing outright.
- **NOT ASSESSED:** round structure or end condition not written down, or a phase did not run.
- **ARCED:** every phase run, the opening is not decisive, a tipping point exists, the middle
  escalates, the end is visible and quick, comebacks pass the test.

Report: inputs read, the four-stretch arc table, the per-round curve, opening findings, tipping
point, comeback table (layer, mechanism, not-charity result), spike list with caps, verdict, three
fixes in order with the trade-off of each. Mark rules of thumb as such. [contested] Some groups
want a front-loaded game (short, sharp, rematch at once); if the user says so, report the cost and
let them keep it.

## Phase 8: Save and hand off

Ask with `AskUserQuestion`:
- `[A] Save the report. May I write this to design/craft/tempo-curve-[name]-[date].md?`
- `[B] Take the top fix to /remix-levers now`
- `[C] Stop here`

Write only on [A]. Then suggest `/scenario-forge` for end triggers and objective timing,
`/table-feel` if trailing players disengage, and `/paper-playtest` with a per-round observer
column. After changes, re-run `/tempo-curve`.
