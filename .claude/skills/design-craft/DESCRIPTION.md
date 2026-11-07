# Description: Design Craft

Author: TABARC-Code
Version: 1.0.0
Skills: 14 (one router, thirteen specialists)

**What it is.** A set of Claude Code skills for the mechanics side of game design: finding the core,
auditing choices, structuring turns, tuning dice and cards, building scenarios, hunting exploits,
writing rules, running paper playtests, remixing, building settings, borrowing proven mechanisms,
pricing units and fixing what a simulation-flavoured game models and at what grain.

**What it does.** Each skill reads a design document, runs a short set of named checks, reports
evidence for every finding and ends with a verdict. Verdict words follow the studio convention and
always include `NOT ASSESSED` for when the input does not support a judgement. Reports save under
`design/craft/` after an explicit yes.

**What it does not do.** It doesn't play the game, invent numbers, or decide taste. It marks
rules of thumb as rules of thumb and contested advice as contested.

**Inputs.** A path to a GDD, concept, rules file or unit data; a one-line problem; or nothing, in
which case the skill asks in plain text.

**Outputs.** A markdown report with sources read, checks and evidence, a verdict, ranked fixes with
costs, playtest hypotheses and a loop log.

**Fits with.** `/brainstorm`, `/one-page-design`, `/design-system`, `/balance-check`,
`/design-review`, `/playtest-report`, `/prose-style` and `/rewrite-text`.

**Style.** UK English, plain prose, no em dashes, no arrow glyphs, unless the project style guide
says otherwise.

**Provenance.** Original synthesis of published design practice. No source text is reproduced and
no source is named.

**Improvement.** Every report carries a loop log of positive and negative feedback, and the router
carries findings backward and forward between skills.
