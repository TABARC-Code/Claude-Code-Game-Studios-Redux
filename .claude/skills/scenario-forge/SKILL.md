---
name: scenario-forge
description: "Designs scenarios, deployment, terrain roles, victory conditions and end triggers as a rules subsystem, and checks them for disengagement traps, snowballing and forgotten special rules."
argument-hint: "[path-to-GDD | scenario-name | 'new']"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, AskUserQuestion, Bash(bash "*/.claude/skills/scenario-forge/../../hooks/yaml-helper.sh" resolve_config *)
model: sonnet
---

!`bash "${CLAUDE_SKILL_DIR}/../../hooks/yaml-helper.sh" resolve_config --keys automation,docs.density`

# Scenario Forge

The scenario is a rules subsystem, not flavour. Table geometry, deployment, scoring windows and the
end trigger steer behaviour more than any single combat rule. Victory conditions are signposts to
the fun: they should point at the activity you want players doing. Works for tabletop missions,
encounter design, level objectives and match modes.

Every `AskUserQuestion` call follows `.claude/docs/automation-modes.md`.

**Honest reporting.** Name every phase or check that did not run under a `Not run` heading, with the reason. A silent skip reads as a pass. `NOT ASSESSED` outranks the pass verdict, and never outranks a failure verdict: a run that skipped part of its scope cannot return the pass value, and a known fault is reported ahead of an unknown.

**Fed by:** `/core-check`, `/activation-design`, `/world-seed` (setting facts become objectives).
**Feeds:** `/exploit-hunt`, `/paper-playtest`, `/team-level`.
**Loop:** playtest "nobody engaged" and "ran to the corner" reports return here. The fix is
usually a victory condition, not a combat rule.

## Phase 1: Purpose

Pick one: break list-based predictability; add narrative or history; give a hobby project;
tournament-grade fairness. Pick-up scenarios front-load rules into a public setup, keep victory
crisp and specials light. Hobby scenarios may reward optional extra effort but never require it.

State the length target and table assumptions. If missing, say what you assumed.

## Phase 2: Space and deployment

- **Reach unit.** Choose a base movement distance R as a fraction of the play space (roughly a
  sixth to an eighth of the width). Fast movement is about 2R, ranged about 2R to 3R. Opposing
  forces start at least about 3R apart so fast units have a purpose. Deployment zones fall out of
  that gap. These are rules of thumb, so mark them.
- **Edges.** Answer: who scores if I leave, do partial exits count, can pieces return, is a
  voluntary exit different from a forced one?
- **Deployment shapes.** Strips (simple, drive head-on attrition); L-shaped (flanks); spur
  (vanguard and depth); split or alternating zones (many local fights); blind per-piece placement
  (memorable, extreme); asymmetric (surround against centre; offset the wide side's flanking edge
  with defences, points or different goals); shared zones (instant contact; avoid when victory is
  destruction); anchor markers placed by players (replayable, but players need a feel for the game
  first).
- **Terrain.** Ship annotated example layouts saying what each piece is for. Give each piece four
  properties: opacity, passability, advantage and footprint. If most pieces sit in cover most of
  the time, make cover the default and reward shooting at the exposed. Rough ground that merely
  slows gets avoided, which makes it impassable; try choice-based costs, vulnerability, or invert
  it so open ground is the fast option. Generosity beats punishment for climbing.

## Phase 3: Victory and end

Rules that work:
- Score periodically or continuously so a loser has led at some point.
- Decouple victory from kills so players trade off kills, objectives and resources.
- Make an unwanted behaviour ineffective rather than forbidden. Forbid only what is advantageous
  and no fun. If something is disruptive but fun, let everyone do it.
- Do not simplify victory in the teaching game. It leaves a bad first impression.
- Hidden or differing objectives bring bluff but risk no contact. Opposed objectives (attacker and
  defender, assigned at random) force interaction.

End triggers: preset (estimate rounds to engage and resolve, subtract one; players run to empty
corners at the end), semi-random (round number plus a die reaches a threshold), or event-driven
(last side standing, objectives met). Best practice: a player-controlled trigger with a hard cap,
whichever comes first. A session length driven by a deck scales with the table.

**Disengagement traps.** Test each:
1. A success threshold that does not end the game, so whoever passes it retreats.
2. A default win for the defender who sits still.
3. Symmetric hold-your-zone goals where doing nothing dominates.
4. Arriving or summoned units that may score end-of-game holds.
5. Voluntary exit plus assassination goals, so the target leaves on turn one.
6. Very long unpredictable moves defeating area defence.

Further checks: do the victory locations pull play into a dull region of the table? Does the side
that deploys last gain a quiet edge (use that as a balance lever, on purpose)? If the history or setup
is lopsided and the audience competes, balance with asymmetric victory points, reinforcements for
the weaker side or setup order, not by distorting the model.

## Phase 4: Special rules

Players forget special rules. Trigger them from a state change ("entering the wood does this") or
at a fixed point in the round, never from memory. Variation recipe: change the start, change the
end, or change something in the middle. Procedural tables give variety but cannot be fully tested;
pre-written scenarios can, but players default to one. Offering both removes the default.

## Phase 5: Verdict and report

**SOUND**, **CONCERNS**, **TRAPPED** (a disengagement trap is live with no fix) or **NOT
ASSESSED**. Report: purpose, space and deployment, victory and end, trap table with evidence,
special-rule triggers, and playtest asks ("ask a tester to play passively and see if they can
win").

## Phase 6: Save and hand off

`AskUserQuestion`: `[A] Save to design/craft/scenario-[name]-[date].md`, `[B] Run /exploit-hunt on
it`, `[C] Stop`. Ask "May I write this to that path?" before writing. Then `/paper-playtest`.
