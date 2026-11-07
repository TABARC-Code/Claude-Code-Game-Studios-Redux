# Rules Wording Defects

Read by `/rules-draft` (ambiguity pass), `/term-register` (check mode), `/keyword-audit`, `/rulebook-architecture` (troublemakers) and `/exploit-hunt` (R5).

Each defect has an ID, a short test and an invented before-and-after pair. The "after" shows one
legal fix, not the only one. Where the fix hides a design choice, the writer does not guess: write
`[DESIGNER TO DECIDE: ...]` and send it to the designer.

## Sentence-level defects

| ID | Defect | Test | Before | After |
|---|---|---|---|---|
| `RANGE-DUR` | Range or condition plus duration, no marker | Does the effect state both a condition and a duration without `while` or `becomes ... until`? | "Allies within 3 cells gain +1 defence until the end of the round." | Continuous: "While an ally is within 3 cells, it gains +1 defence." Resolved once: "Each ally within 3 cells becomes *Braced* until the end of the round." |
| `SCOPE` | Condition scope unclear | Does one condition govern two or more effects with no visible structure? | "On a 5+ the target is pushed 1 cell. In addition it loses 1 supply." | "On a 5+: (1) push the target 1 cell; (2) it loses 1 supply." If the loss is unconditional, put it before the roll. |
| `MUST` | Decorative must | Delete `must` and reread. Unchanged meaning means it was decorative. | "The player must roll two dice." | "Roll two dice." Keep `must` only where it removes a freedom granted elsewhere. |
| `AGENCY` | Mixed agency | Do player, side and piece swap as the actor between similar rules, victory text included? | "The scout moves 4 cells. The player then attacks with the scout." | Hold the registered split, for example: people pick and roll, pieces move and attack. "The scout moves 4 cells, then attacks." |
| `CAVEAT` | Trailing caveat | Does a clause only make sense with context given after it? | "Pieces cannot re-enter a cell they left this turn (this stops shuffling for free objective points)." | Header first: "**Shuffling between objectives.** A piece cannot re-enter a cell it left this turn." One fenced, non-normative purpose line may follow. |
| `MAY` | False permission | Does `may` mark something with no real choice? | "You may draw a card at the start of your turn." (always beneficial) | "Draw a card at the start of your turn." |
| `TRIGGER-EV` | Played or resolved unclear | Does a trigger cite a card event without saying which? | "When an opponent plays a tactic, gain 1 resource." | "When a tactic an opponent played resolves, gain 1 resource." or keep "plays" and say a countered tactic still counts. |
| `TIMING` | Timing class missing | Does an effect not say whether it queues, happens immediately, or replaces an event? | "When this piece would be removed, return it to hand." | "Replacement: if this piece would be removed, return it to hand instead." |

## Term and keyword defects

| ID | Defect | Test | Before | After |
|---|---|---|---|---|
| `SYN` | Synonym of a locked term | Is a registered term, or a recorded reject, replaced by another word? | Register locks "pick"; text says "select a target". | "Pick a target." |
| `COMPRESS` | Compression missed | Does a long phrase recur about three or more times with no defined term? | "a piece that has not moved or attacked this round" (five times) | Define *Fresh* once in core concepts, then use it. |
| `NOHOOK` | Keyword without a hook | Is a mechanic described in full each time other rules cite it? | Three rules each restate the shield effect. | Promote to a keyword and cite it. |
| `MERGED` | Mechanic type and status merged | Can a rule exclude the ability type without also naming the status? | One entry *Sheltered* covers both the aura and its effect. | Two entries: "aura ability" (type) and *Sheltered* (status). |
| `KW-SLOT` | Dropped keyword value | Does an instance reference omit a value or category slot? | "Add its *Volley* to the roll." | "Add its *Volley* value to the roll." with the template defining the value. |
| `KW-PARTIAL` | Partial or inflected compound | Is a compound keyword shortened, pluralised or turned into an implied category? | "Strike-type abilities" | Name the family in a pattern entry, or list the members. |
| `KW-HASIS` | Mixed has and is | Does a bare tag appear with both verbs? | "has *Veiled*" and "is *Veiled*" | The registered verb only. |
| `TWO-WORD` | One mechanic, two wordings | Is the same effect worded differently in two places or documents? | Core: "cannot be targeted beyond 6 cells". Supplement: "can only be targeted within 6 cells". | One wording, from the register's pattern entry. Players read two wordings as two tiers. |

## Book-level troublemakers

| ID | Troublemaker | Test |
|---|---|---|
| `DICE` | Die and dice | Singular and plural used consistently; "roll a die" against "roll the dice" says how many. |
| `SEMI` | Semicolon overload | A semicolon in a procedure step usually hides two steps. Split them. |
| `JARGON` | Designer jargon | A term the author uses but never defines, or a working name surviving by inertia. |
| `ROLL-UNDER` | Modifier direction | In a roll-under system, does "+1" help or hurt? Say "easier" or "harder" in the rule. |
| `ABBREV` | Look-alike abbreviations | Stat labels that differ by one letter or look alike in small print. |
| `RESTATE` | Restated rule | The same rule in two sections. Keep one, cross-reference the other by id. |
| `INWARD` | Inward dependency | A core rule that needs a scenario, force or extended rule to work. |
