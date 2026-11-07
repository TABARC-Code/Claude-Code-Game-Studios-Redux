---
name: mechanic-forge
description: "Invents a new mechanism by mutating a known one: exactly one axis changed plus one structural mutation, a named decision shape required, three to seven seeds with a paper spec each and a deep spec for one. Reskins are sent to /classic-borrow."
argument-hint: "[base mechanism | target experience in plain words | path-to-GDD]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, AskUserQuestion, Bash(bash "*/.claude/skills/mechanic-forge/../../hooks/yaml-helper.sh" resolve_config *)
model: sonnet
---

!`bash "${CLAUDE_SKILL_DIR}/../../hooks/yaml-helper.sh" resolve_config --keys automation,docs.density`

# Mechanic Forge

Most "new" mechanisms are a known one with the theme changed. Real invention is usually smaller and
more disciplined: take something that works, change one thing about it, add one structural twist,
and check that players now face a different kind of decision. This skill does that and nothing
more. It does not import proven mechanisms (that is `/classic-borrow`) or repair a named problem
(that is `/remix-levers`). One new mechanism per design iteration.

Every `AskUserQuestion` call follows `.claude/docs/automation-modes.md`. A skipped or dismissed
question is not an answer: re-ask in plain text.

**Honest reporting.** Name every phase or check that did not run under a `Not run` heading, with the reason. A silent skip reads as a pass. `NOT ASSESSED` outranks the pass verdict, and never outranks a failure verdict: a run that skipped part of its scope cannot return the pass value, and a known fault is reported ahead of an unknown.

**Fed by:** `/brainstorm`, `/core-check` (a core with no mechanism yet), `/remix-levers` (when no
lever fits).
**Feeds:** `/classic-borrow` (is it already a classic?), `/core-check`, `/decision-audit`,
`/exploit-hunt`, `/paper-playtest` (test the module alone before it joins the game).
**Loop:** a seed that survives a paper test comes back for its deep spec to be revised against what
broke. Record each seed's fate (kept, cut, merged) so later runs do not regenerate it.

## Phase 1: Input

1. Read the argument. A path means read the GDD and note its core and genre. Check
   `.claude/docs/craft/genre-checklists.md` for the matching block.
2. Need exactly one starting point: a base mechanism (worker placement, drafting, push your luck)
   or a target experience ("I want players to bluff about timing"). If neither is given, ask for
   one in plain text. Two or more: ask which.
3. Record constraints: player count, session length, component limits, digital or physical.
4. Nothing to start from after asking: stop with **NOT ASSESSED**.

## Phase 2: One axis

Change exactly one axis of the base. Name it and say what changes:

- **Information:** open becomes hidden, hidden becomes revealed late, certainty becomes something
  you pay to refine.
- **Time:** simultaneous becomes sequential, immediate becomes delayed, fixed order becomes bid.
- **Resource flow:** income becomes decay, private becomes shared, spending becomes the reward.
- **Agency:** who chooses, who executes, who holds timing authority.
- **Interaction:** parallel becomes contested, denial becomes trade, competition becomes shared risk.

Two axes changed at once is two mechanisms; split them and keep the stronger.

## Phase 3: One structural mutation

Add one: spaces that evolve with use; rules that decay or unlock over the session; a shared hidden
state all players influence; a topology change (the board or track reshapes). Supporting moves to
draw from, one at a time: uncommon verbs (rotate, reorder, lock and unlock, share risk); move the
tension source (action scarcity into information scarcity at the same action count); opposed loops
(power against flexibility); a slow irreversible track moved only by fast tactical choices;
asymmetry of rule access or timing rather than stats; purpose inversion (reward sacrifice).

## Phase 4: Decision shape

Name the decision the mutation creates and its shape: **branching** (choices open different
futures), **converging** (many routes, one contested point), **cyclical** (build, spend, rebuild),
**layered** (a short-term choice inside a long-term one). State the tension in one line: what does
the player give up to get what? A seed with no nameable shape, or the same shape as the base, is a
reskin. Reject it here, before speccing.

## Phase 5: Seeds

Produce three to seven seeds. Fewer than three means the space was not explored; more than seven is
noise. For each, a block:

| Field | Content |
|---|---|
| Base | [known mechanism] |
| Axis | [one axis and the change] |
| Mutation | [one structural mutation] |
| Decision shape | [shape and the one-line tension] |
| Minimal paper spec | [components and one turn, in under eighty words] |
| Likely degeneracy | [the line a min-maxer finds first] |
| Test focus | [the one question a paper test answers] |

## Phase 6: Deep spec for one

Ask the user to pick a seed with `AskUserQuestion`, or pick the one with the clearest shape and say
why. Write: components, turn flow, how it touches the core, likely dominant line and a first patch,
rules load (new terms, exceptions, things to track), and a teach in three sentences. If the teach
needs more than three sentences, say so: that is the OVERLOADED signal.

## Phase 7: Verdict and report

First match wins:

- **DERIVATIVE:** the chosen seed's decision shape matches the base or a known mechanism; it is a
  reskin. Route to `/classic-borrow` to find and adapt the proven original with its patches.
- **OVERLOADED:** a new shape, but the teach exceeds three sentences, it adds more than a couple of
  tracked states, or it competes with the existing core for attention.
- **NOT ASSESSED:** no starting point, no seed reached Phase 6, or a phase did not run. Name which.
- **NOVEL:** every phase run, one axis and one mutation, a distinct named shape, a teach in three
  sentences, a test focus ready for paper.

Novelty here means new to this design and not an obvious reskin; it is not a claim that no game has
done it [contested]. Check with `/classic-borrow` before claiming more.

## Phase 8: Save and hand off

Ask with `AskUserQuestion`:
- `[A] Save the seeds and deep spec. May I write this to design/craft/mechanic-forge-[name]-[date].md?`
- `[B] Send the chosen seed to /classic-borrow to check its lineage`
- `[C] Stop here`

Write only on [A]. Then suggest `/paper-playtest` on the module alone, `/core-check` to see whether
it serves the core, and `/exploit-hunt` once rules exist. A DERIVATIVE result goes to
`/classic-borrow` first.
