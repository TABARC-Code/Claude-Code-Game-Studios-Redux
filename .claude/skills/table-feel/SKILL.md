---
name: table-feel
description: "Diagnoses how a multiplayer game feels in the room: interaction density against a chosen target temperature, kingmaking, toxic optimum, dignity in defeat, the score arc, group sensitivity and the pleasure map. 'It works but it feels flat, cold or mean.'"
argument-hint: "[path-to-rules-or-GDD | 'notes' to start from playtest comments]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, AskUserQuestion, Bash(bash "*/.claude/skills/table-feel/../../hooks/yaml-helper.sh" resolve_config *)
model: sonnet
---

!`bash "${CLAUDE_SKILL_DIR}/../../hooks/yaml-helper.sh" resolve_config --keys automation,docs.density`

# Table Feel

A rule set can be sound, balanced and quick and still leave the room cold: everyone plays their own
puzzle, the losing player spends the last half hour confirming it, or the winning line makes people
behave in ways their group dislikes. This skill looks at the social layer of play. It measures the
design against a target temperature the designer chooses. A cutthroat target is a choice, not a
defect: the question is whether the rules reach the target and whether the costs are known. For
when things happen across the session, use `/tempo-curve`. Genre probes:
`.claude/docs/craft/genre-checklists.md`.

Every `AskUserQuestion` call follows `.claude/docs/automation-modes.md`. A skipped or dismissed
question is not an answer: re-ask in plain text.

**Honest reporting.** Name every phase or check that did not run under a `Not run` heading, with the reason. A silent skip reads as a pass. `NOT ASSESSED` outranks the pass verdict, and never outranks a failure verdict: a run that skipped part of its scope cannot return the pass value, and a known fault is reported ahead of an unknown.

**Fed by:** `/core-check`, `/activation-design` (turn order, downtime), `/tempo-curve`,
`/paper-playtest` and `/playtest-report` (comments such as "bored", "mean", "felt alone").
**Feeds:** `/remix-levers` (interaction and social groups), `/exploit-hunt` (kingmaking, toxic
optimum), `/scenario-forge`, `/rules-draft` (the expectation frame line in the teach).
**Loop:** fix one thing, playtest with the same group type, return here. Record the target and the
measured notch each pass; a notch that never moves means the fixes did not touch interaction.

## Phase 1: Load and target

1. Read the rules or GDD and any playtest notes. `notes` means ask for the comments in plain text,
   then ask for the rules. Solo-only designs: this skill does not apply; say so and suggest
   `/decision-audit`.
2. Record player range, audience (family, hobby, party, mixed or public tables) and interaction mode
   (competitive, co-op, team, semi-co-op).
3. Ask for the **target temperature** if not stated: cosy, quietly competitive, opportunistic,
   cutthroat, negotiation-heavy. Do not pick it for the designer. Note the tone the mechanisms
   imply: cosy (low stakes, easy recovery), grim (costly failure, scarcity, permanence), heroic (big
   swings, reversals), absurd (odd combinations, escalating chaos). Flag a mismatch with the target.
4. No rules to read: stop with **NOT ASSESSED** and name the missing input.

## Phase 2: Interaction density

Take the five most frequent actions. For each: how often does one player's action change another
player's best move? Answer often, sometimes or rarely, and name the channel: direct (attack, steal,
displace, forced trade), contested space or supply, auction or price, draft denial, turn order and
tempo, position (majorities, routes, adjacency). "Rarely" across most actions is multiplayer
solitaire.

Place the design on the dial: minimal (parallel engines), light (shared market, indirect blocking),
medium (contested spaces, auctions, draft denial), sharp (forced trades, displacement, elimination).
Compare with the target. Below target is flat; above target is overheated.

## Phase 3: Social outcome

Run each check and cite the rule, or write `not found`:

1. **Kingmaking:** a player who cannot win decides who does. Look for late choices whose only value
   is spite or favour.
2. **Toxic optimum:** the best route to win needs repeated behaviour the target group finds petty
   (theft, piling on, prolonged spite, stalling). Severity depends on the audience: serious at a
   family or mixed table, possibly intended at a cutthroat one.
3. **Dignity in defeat:** the trailing player stays involved, curious and able to discuss their
   choices. Fail: the weakest player spends the last third confirming defeat, is eliminated with
   nothing to do, or has mistakes exposed humiliatingly.
4. **Score arc:** progress visible in play, the winner not obvious early, close finishes possible,
   the win explainable afterwards. Hidden scoring needs a reason.
5. **Co-op and team extras:** quarterbacking (one player can run everyone), and for hidden roles,
   play after elimination and actions beyond talk.

## Phase 4: Pleasure map

Mark each source present, weak or absent, with evidence: **strategic** (plans maturing),
**tactical** (reading the board now), **interaction** (beat you to it, priced you out, forced your
pivot), **thematic** (actions forming small arcs), **social** (teaching, banter, close finishes).
Prompts: where is the surprise, the contest, the visible progress, the read of another's intent,
the sense of having built or taken something? Do not prescribe more mechanisms "for depth"; depth
must show as better decisions.

## Phase 5: Group sensitivity

1. List the unwritten norms the design relies on (negotiation etiquette, table talk, how hard to
   hit the leader). These vary most between groups.
2. Portability: designs that put expectations into rules and incentives (open drafting, public
   goals) travel; norm-reliant designs do not. For public or mixed tables check legible
   interaction, obvious scoring, graceful correction of mistakes and recovery after one bad choice.
3. Draft a one-line expectation frame for the teach ("this is a blocking game, expect to be
   blocked").

## Phase 6: Verdict and report

First match wins:

- **SOCIAL FAULT:** kingmaking or a toxic optimum unmitigated for the stated audience, or trailing
  or eliminated players stranded with nothing to do.
- **OVERHEATED:** interaction or nastiness above the chosen target.
- **FLAT:** interaction below the target, or two or more pleasure sources absent.
- **NOT ASSESSED:** no target temperature, no rules, or a phase did not run. Name which.
- **ON TARGET:** every phase run, density matches the target, social checks clear for the
  audience, the score arc holds. A cutthroat game can be ON TARGET.

Report: inputs, target and implied tone, interaction table (action, how often, channel), dial notch
against target, social checks with evidence, pleasure map, group sensitivity notes and frame line,
verdict, and up to three fixes in this order: the missing pleasure, the failing structure, one
change, why it improves the room. Fix menus: too nice (tighter scarcity, contested turn order,
public races, fewer and richer action slots); too nasty (blocking instead of theft, denial that
costs the denier, less elimination and snowballing, an alternate scoring path when one closes).
Mark rules of thumb as such; group reactions vary [contested].

## Phase 7: Save and hand off

Ask with `AskUserQuestion`:
- `[A] Save the report. May I write this to design/craft/table-feel-[name]-[date].md?`
- `[B] Take the top fix to /remix-levers now`
- `[C] Stop here`

Write only on [A]. Then suggest `/exploit-hunt` for kingmaking and toxic lines, `/tempo-curve` if
the session arc sags, and `/rules-draft` to add the frame line. After a playtest, re-run
`/table-feel`.
