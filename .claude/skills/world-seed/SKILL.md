---
name: world-seed
description: "Builds a setting in dependency order (land and water, living systems, trade, society, capability, history), runs consistency checks, then converts setting facts into playable hooks and mechanics."
argument-hint: "[path-to-setting-doc | genre and scope in plain words]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, AskUserQuestion, Bash(bash "*/.claude/skills/world-seed/../../hooks/yaml-helper.sh" resolve_config *)
model: sonnet
---

!`bash "${CLAUDE_SKILL_DIR}/../../hooks/yaml-helper.sh" resolve_config --keys automation,docs.density`

# World Seed

A setting exists to put pressure on the people in it. Build facts that create friction, tie each fact
to someone who lives with it, and keep the causes. This skill covers an invented world, a real
place with an altered past or future, or a real place with a hidden layer. It complements the
`world-builder` agent and the `/design-system` flow. It does not replace the narrative director.

Every `AskUserQuestion` call follows `.claude/docs/automation-modes.md`.

**Honest reporting.** Name every phase or check that did not run under a `Not run` heading, with the reason. A silent skip reads as a pass. `NOT ASSESSED` outranks the pass verdict, and never outranks a failure verdict: a run that skipped part of its scope cannot return the pass value, and a known fault is reported ahead of an unknown.

**Fed by:** `/brainstorm`, `/one-page-design`. **Feeds:** `/scenario-forge` (objectives from
setting facts), `/map-systems`, `/team-narrative`, `/rewrite-text`.
**Loop:** every new fact triggers a ripple pass. A hook that cannot be played sends you back to
change the fact, so the setting and the game shape each other in both directions.

## Phase 1: Scope

Ask in plain text (or read): genre; the size of territory the game really needs (a ship, a street,
a city, a continent); the framing; who the player is and what they want. Genre and scope shape each
other. State what you assumed.

## Phase 2: Build order

Work through the groups below, one `AskUserQuestion` per group at most. Each answer is the user's.
Offer two or three options, never a single answer, and write `[OPEN]` where they decline.

A. **Foundations.** Map (rough, but consistent). Water and its equivalent for non-human life.
Capital sited near water, defence or convenience, with a reason. Landscape with believable
transitions. Natural resources: what is near, imported, exhausted, absent.

B. **Living systems.** Who is present and how they relate. Food: grown, reared, hunted, imported,
reserved for elites, and who does the labour. Farmed animals and predators, with the balance
between them. Climate and seasons and what they do to work, housing, mood and festivals.

C. **Movement and exchange.** Transport follows technology. Trade routes, waystations, boom towns
and abandoned places.

D. **Society.** Education. Law and order. Government (nominal against real power). Economics
(currency, anchor prices, what causes a crash). Family. Gender roles. Work and prestige. Class and
mobility. Belief. Magic (see below). Festivals.

E. **Capability.** Technology (old does not mean weak). Medicine. Weapons.

F. **History.** Wars, reforms and revolutions, disasters. History is the reverse pointer: write it
last for convenience and let it overwrite earlier answers.

**Magic checklist.** Genre fit; where it is strong or weak; who can use it and what it costs;
its place in school, law, trade, belief and defence; items and rarity; limits and timing;
consequences; how multiple systems clash. Unlimited power removes conflict, so limit it and make it
cost something.

## Phase 3: Consistency checks

1. Map audit: directions, distances, travel times, terrain adjacency.
2. Survival test per settlement: water, food, materials, defence or access, a trade link.
3. The why test: every named place, custom and law has a cause, or is consciously forgotten.
4. Resource ledger: produced, imported, lacking, and whether prices agree with routes.
5. Calendar: climate, harvest, festivals, rest days and school terms line up.
6. Power test: who benefits from each law? Who really decides?
7. Technology parity across weapons, medicine, transport and magic, or the gap is explained.
8. Magic limits: no ability dissolves an earlier constraint.
9. Ecology: adding or removing a species has recorded effects.
10. Generations: older and younger cohorts differ in a traceable way.
11. Ripple pass after any new fact: scan the other groups for what must change.
12. Newcomer perception: fix any contradiction a newcomer could spot first.

Keep a log of changes at four scales (world, region, locality, individual). Small causes can
cascade up. Large ones always trickle down.

13. **Mechanics state the world.** A reader should be able to infer the setting from the rules alone:
    pieces that never flee say fanatical, unreliable magic says power costs, short command range says
    command is fragile. Each key fact should have a rule that reveals it.
14. **World layers:** cosmic, civilisational, political, operational, personal. Build only as high as the
    personal layer needs. A cosmology should be consistent, should touch the table, and should keep one
    mystery open.
15. **Does the world move without the players?** Remove them in your head. If nothing changes, the setting
    is a backdrop, not a pressure.

## Phase 4: From facts to hooks

- Conflict engine: a goal blocked by law, custom, scarcity, terrain, weather, class or a magic
  limit. List the obstacle each fact makes.
- Disparity names a faction pair with opposed interests.
- Tolerated danger for profit becomes a risk and reward choice.
- Scarcity becomes tokens, costs and action limits; movement cost by wealth becomes differential
  speed.
- Magic cost becomes push-your-luck: fatigue, ageing, legal exposure, moral rebound.
- Forbidden things become stealth, black markets and bluff.
- History residue (monuments, street names, lost sources) becomes investigation.
- Waystations become hubs for trade, rumour and ambush.
- Seasons and festivals become timed phases and scoring rounds.
- A past event's second-order effect becomes a countdown.
- Reveal through behaviour, not lectures. Each novelty adds learning load, so introduce
  gradually.

Warning: a detailed world with weak goals fails. If the hook list is thin, the setting is
decoration.

- **Every hook gets a clock:** a deadline, a worsening condition or a rival. In open-world games, write
  hooks as front seeds (whose agenda, the next step if ignored, three to five visible escalations) using
  `.claude/docs/templates/front-and-clock.md`, then hand the authored structure to `/adventure-forge`.
- **Stakes ladder:** each hook names a personal stake before any community or world stake.
- **Theme to verb.** Map each mechanical verb to an in-world action, and each noun and icon to a setting
  term. For mechanics-first games, settle the verbs, then shortlist three to seven themes that reinforce
  them.
- **Faction sentence:** "plays [style] because in the fiction they are [identity]". Run `/faction-forge`
  for the full identity stack. Write a short tone document before any art brief, and name one owner for
  lore continuity.

## Phase 5: Verdict and report

**SEEDED** (all groups answered, checks run, at least five playable hooks), **THIN** (gaps or fewer
hooks), **INCONSISTENT** (a check fails) or **NOT ASSESSED**. Report: scope, answers by group with
`[OPEN]` marks, check results with evidence, hooks table (fact, obstacle, mechanic, scene), and
the change log.

## Phase 6: Save and hand off

`AskUserQuestion`: `[A] Save to design/craft/world-seed-[name]-[date].md`, `[B] Convert hooks into
scenarios with /scenario-forge`, `[C] Stop`. Ask "May I write this to that path?" first. Unused
detail is not wasted, but cut prep that never reaches a player.
