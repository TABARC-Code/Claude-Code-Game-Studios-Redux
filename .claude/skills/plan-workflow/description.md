# plan-workflow: description

A Claude Code skill that writes a persisted roadmap (`production/workflow-plan.md`) from the project's current position to a goal the user picks, built from the repo's workflow catalogue and artifact checks. Steps carry status, outputs and a blank column for the user's own time; skipped and undetectable steps are named, never dropped or shown as done. `--refresh` ticks off progress. It guesses no durations and runs no steps.

**Tags:** claude-code, skill, workflow, planning, roadmap, game-development, project-management

**Author:** TABARC-Code
