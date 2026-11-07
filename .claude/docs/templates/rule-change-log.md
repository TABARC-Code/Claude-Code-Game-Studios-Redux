# Rule change log

Read by `/paper-playtest`, `/remix-levers`, `/meta-intervention` and `/design-craft`.

One row per change. Fill "Expected effect" when you make the change, before the next session. Fill
"Observed effect" and "Side effects" after it. A change whose observed effect never gets written was not
tested. A fix that creates two new problems is reverted.

Symbols: `+` added, `-` removed, `~` modified, `?` needs more testing, `!` high risk.

| Version | Symbol | Area | Previous rule | New rule | Reason | Expected effect | Observed effect | Side effects | Status |
|---|---|---|---|---|---|---|---|---|---|
| [0.3] | [~] | [combat] | [old text] | [new text] | [why] | [prediction, testable] | [what happened] | [anything else that moved] | [kept, reverted, testing] |

## Do not change

Things that tested well and must be protected from the next round of fixes.

- [mechanism or rule, and the evidence that it works]

## Scars

Changes that were reversed, with the check that would have caught the problem first. A scar becomes a
standing rule only if it recurs.

- [change] reversed because [what broke]; would have been caught by [check]
