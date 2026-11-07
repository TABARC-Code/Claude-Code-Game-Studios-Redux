# Design Craft

Author: TABARC-Code

Right, so this is the mechanics toolbox. Twenty-five small skills and one router, all about the part of game design that people tend to wave their hands at. Is there a core? Are the choices real? Who acts when? Does anyone get stuck waiting? Will it survive a table of strangers who have never heard your pitch?

It started life as a pile of reading. Design theory, miniatures craft, a stack of old board games, a remix booklet, a worldbuilding workbook, a practical make-your-own guide, and a wargame design text. Then I folded in my own older skills for cards, wargames, board and euro games, rules writing, adventures and playtesting, kept what earned its place and binned the rest. The synthetic tester spreadsheet didn't make it; real testers or nothing. I read the lot, threw away the bits that were opinion dressed up as law, and boiled the rest down into procedures you can actually run. Nothing in here quotes anyone. If a claim is somebody's strong preference rather than a fact, the skill says so, and I'd sooner it nagged you about that than pretended.

## What's in the box

| Skill | Use it when |
|---|---|
| `/design-craft` | You don't know where to start. It routes you. |
| `/core-check` | The design feels muddy and you suspect two games glued together. |
| `/decision-audit` | Choices feel flat, or nobody can say why they lost. |
| `/activation-design` | Turn order, downtime, first-move worries. |
| `/resolution-tuning` | Dice or cards, and the odds feel off. |
| `/scenario-forge` | Missions, setup, victory, end triggers. |
| `/exploit-hunt` | You want the cheats found before players find them. |
| `/rules-draft` | The rules text is muddy, or doesn't exist yet. |
| `/paper-playtest` | Time to put it in front of people with a pencil. |
| `/remix-levers` | One problem in an existing game, one lever at a time. |
| `/world-seed` | Setting first, then hooks that make it playable. |
| `/classic-borrow` | You want a mechanism that has already survived a few centuries. |
| `/unit-costing` | Stats, points, list-building. |
| `/model-scope` | Simulation-flavoured games: scale, grain, supply, command, zones of control. |
| `/term-register` | Your keywords keep drifting between documents. |
| `/keyword-audit` | Two abilities together do something nobody intended. |
| `/rulebook-architecture` | Nobody can find the rule they need. |
| `/card-forge` | A card, or a handful, needs designing or a sanity check. |
| `/faction-forge` | The sides feel like one faction in two colours. |
| `/expansion-plan` | Next set, next format, rotation, without power creep. |
| `/meta-intervention` | Something live dominates and you need the smallest fix. |
| `/tempo-curve` | Decided in round one, or it grinds, or the middle sags. |
| `/table-feel` | It works, but it feels flat, cold or mean round the table. |
| `/mechanic-forge` | You need a mechanism that doesn't exist yet. |
| `/story-engine` | Play never throws up a story worth telling afterwards. |
| `/adventure-forge` | Quests, missions, investigations, campaigns. |

## How they hang together

Not a pipeline. More of a conversation. Each skill says what feeds it and what it feeds, and the router carries information in both directions. A playtest that finds fake decisions goes back to `/decision-audit`, not to the rules text. A rules argument that's really a design hole goes back to `/core-check`. Setting facts turn into scenario objectives, old mechanisms turn into remix levers, playtest sheets turn into exploit probes. Cross-pollination, if you want the fancy word.

Every report ends with a little loop log: what worked, what failed, what changed, what comes next. Positive results keep a check in the routine. Negative ones prune it. If a skill keeps missing real faults, log that and run `/skill-improve` on it. Skills should get better with use, otherwise what's the point.

## Shared references

`.claude/docs/craft/` holds the bits several skills lean on: a symptom index (complaint in, skill and phase out), genre checklists, keyword shapes, a catalogue of rules wording defects, a card balance lexicon with odds worked out properly, and a negative feedback toolkit. Templates for a term register, a rule change log, fronts and clocks, and a revelation web sit in `.claude/docs/templates/`.

## House rules, same as the rest of the studio

* Ask before writing. Every skill offers to save a report under `design/craft/` and waits for a yes.
* No invented numbers. If a figure is computed, it shows the working. If it's a rule of thumb, it says so.
* Verdicts include `NOT ASSESSED`. A blank is better than a guess.
* They respect `/prose-style`. Without a guide, plain prose, no em dashes, no arrow glyphs.

## Honest limits

These skills read a design and reason about it. They don't play it. A verdict of `ANCHORED` or `SOUND` means the text holds up under a hostile reading, not that anyone will enjoy the game. Only a table will tell you that, which is why `/paper-playtest` exists. Also, a lot of craft advice is contested. Where I knew it was, I flagged it. Where I didn't, tell me and I'll fix it.

Anyway. Start with `/design-craft` and tell it what's bothering you.
