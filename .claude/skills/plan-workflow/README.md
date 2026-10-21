# plan-workflow

`/help` tells you the next step. Good. But sometimes you want the whole route written down: where am I, where do I want to be, and what's in between?

`/plan-workflow` builds that, from the workflow catalogue the repo already has. It writes `production/workflow-plan.md`: the steps in order, what each one produces, which are done, and what's been left off the plan and why.

## How it works

It runs `project-state.sh` and `artifact-check.sh` and reads what they say. It opens with the denominators: how many catalogue steps it read, how many have no detectable artifact, which tier you're on. Then you pick a goal. The candidates are derived from the catalogue at run time (steps on the minimal path, or the end of each phase), so they can't go stale when the catalogue changes. Say a goal in your own words and it maps it to the nearest candidate and *shows you the mapping* before building anything.

Re-run it with `--refresh` and it ticks off what's been done since. It reports a step that went backwards too, because an artifact someone deleted is worth knowing about.

## Honest bits

- **No durations.** The plan has a blank "Your time" column. I'm not going to guess how long your game takes. `/estimate` will do it with your numbers.
- **`NO_CHECK` isn't "done".** Some steps can't be detected from files. They're listed together and you tick them. A step the plan can't see is never shown as finished.
- **Skipped steps are named.** Optional steps you decline, and steps after the goal, go in a table with the reason. Nothing disappears quietly.
- At the minimal tier the phase ladder isn't used and `project.stage` may sit at Concept all project. The skill says so once, so it doesn't look like a bug.

It runs nothing and writes only after asking. If a helper can't run, or the catalogue can't be read, the verdict is `NOT ASSESSED` and it won't guess a position.

Author: TABARC-Code
