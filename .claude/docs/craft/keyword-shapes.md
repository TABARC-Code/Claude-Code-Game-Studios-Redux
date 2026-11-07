# Keyword Shapes

Read by `/term-register`, `/keyword-audit` and `/rules-draft`. Also useful to `/unit-costing` and `/card-forge`.

A keyword's shape decides what later text may legally do with it. Classify every keyword into
one of the four shapes below when it enters the register, record the shape in the register's
`Shape` field, and obey that shape's grammar everywhere. All four failure patterns share one root:
a value or relationship the rule depends on is left for the reader to infer.

The examples are invented and belong to no published game.

## When a term becomes a keyword

- **Game term first.** Coin a defined term for a phrase you expect to recur, roughly three or more
  times (a threshold to test, not a law). Never for a single use.
- **Promote to keyword** when other rules, now or in planned expansions, need to cite the mechanic
  without describing it again. A keyword is a hook; a game term is a compression.
- **Demote** a keyword used on fewer than about three cards or units back to plain text, unless
  planned content will use it.
- **One formatting convention** (italic, bold or brackets) per project, recorded once in the
  register and applied without exception.
- **Two-level naming.** A mechanic type (the hook, such as an "aura ability") and the status it
  produces (such as *Sheltered*) get separate entries. Merged, a later rule cannot say "cannot
  carry any aura ability" cleanly.

## Shape 1: Bare tag

No slot. Example: *Veiled*.

| | |
|---|---|
| Legal | "Pieces with *Veiled* cannot be targeted from more than 6 cells away." |
| Illegal | Mixing "has *Veiled*" and "is *Veiled*" in one project. |
| Register records | Which verb the project uses (has or is). Fixed once, never mixed. |
| Change rule | If the keyword later needs a value, reclassify it as shape 2 through `/term-register revise`. Never extend it silently ("*Veiled* 2"). |

## Shape 2: Parameterised

One slot. Example: *Volley X*.

| | |
|---|---|
| Legal family reference | "Weapons with *Volley* cannot fire after moving." (no value needed) |
| Legal instance reference | "This weapon gains *Volley 2*." |
| Illegal | "Add its *Volley* to the roll." (which value?) |
| Register records | One template entry, not one per value. The definition states the slot's legal range (for example, X is 1 to 4). |
| Costing | `/unit-costing` costs per value from the single template entry. |

## Shape 3: Compound phrase

A fixed multi-word name. Example: *Rending Strike*.

| | |
|---|---|
| Legal | "*Rending Strike* cannot be used twice in one activation." |
| Illegal | "Strike-type abilities", which invents a category. "*Rending Strikes*" or "*Rend*", which inflect or shorten the cited form. |
| Register records | The exact string, capitals included. Treated as unbreakable. |
| Family rule | A family of similar keywords (*Rending Strike*, *Piercing Strike*) exists only if a mechanic-pattern entry names it and lists its members. Never imply a family by resemblance. |

## Shape 4: Compound-parameterised

Two or more slots, at least one of them a category. Example: *Warded-X Y+* (immune to effects of
category X when the warding roll is Y or higher).

| | |
|---|---|
| Legal | "This piece has *Warded-Flame 4+*." |
| Illegal | "This piece has *Warded 4+*." (which category?) "*Warded-Flame*" with no threshold. |
| Register records | A closed category list for X; the threshold with its comparison written out ("Y or higher"). |
| Instance rule | Every instance fills every slot. Filling only the number leaves the category to inference. |
| Costing | Cost per category-and-threshold pair; never cost an instance with an empty slot. |

## Quick test for any keyword use

1. Find the keyword's shape in the register.
2. Shape 1: is the has or is verb the registered one?
3. Shape 2: is this a family reference (no value) or an instance (value present)?
4. Shape 3: is the string exact and whole?
5. Shape 4: is every slot filled from its legal range or list?

A use that fails is defect `KW-SLOT`, `KW-PARTIAL` or `KW-HASIS` in
`.claude/docs/craft/rules-wording-defects.md`.
