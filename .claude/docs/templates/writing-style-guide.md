# Writing Style Guide: [Project Title]

<!--
Written by /prose-style, and safe to edit by hand. It governs the source-language
text players read: dialogue, lore, item text, UI copy, patch notes. Translations
follow their own locale's guide. If a value below is blank, tools report "style
NOT ASSESSED" for that rule; they never fall back to a default variant.

Every setting is a project choice. Where a setting cites a house style, the
citation says where it comes from, so you can disagree with it on purpose.
-->

## Settings

```yaml
english: ""                 # en-GB | en-GB-oxford | en-US | en-CA | en-AU | other:<code>
dash_policy: ""             # oxford | british-spaced-en | none
dash_cap_per_100_words:
  narrative: 1              # a project choice, not a published rule
  rules_and_technical: 1.5  # rules text needs its dashes more
  dialogue_lines: 1
interrupted_speech: dash    # dash | ellipsis
serial_comma: ""            # yes | no
quotation_marks: ""         # single | double (nested quotes use the other)
contractions: ""            # yes | by_register | no
numbers_spell_out_to: ""    # 9 | 99 | 100; numerals above that
numbers_game_values: numerals   # stats, damage, prices, timers in UI and rules
large_numbers: ""           # e.g. "1,000 / 1,000,000"
title_before_name: ""       # capitalised ("Captain Hale") | lower ("captain Hale")
narrator_register: ""       # optional: chronicler | pulp cadence | broadcast dread | grim guide | custom
```

## What the choices mean

**English variant.**
- `en-GB`: British spelling with -ise endings and -our words.
- `en-GB-oxford`: British spelling with -ize endings and -our words, the form
  Oxford University Press uses. Oxford University's own staff style guide is
  reported to advise -ise instead, so this is a choice, not the only British form.
- `en-US`, `en-CA`, `en-AU`: the national conventions.
- `other:<code>`: name it; the writer and tools will treat the code as
  authoritative and ask when unsure.

**Dash policy.**
- `oxford`: the unspaced em dash (—) for a parenthesis or a break in thought, and
  a closed-up em dash for interrupted speech. This is Oxford University Press
  house style as secondary sources describe it. It has not been checked against
  the current edition of *New Hart's Rules*, so check it if a publisher will hold
  you to it.
- `british-spaced-en`: the spaced en dash ( – ) for the same jobs, the norm at
  most other UK publishers.
- `none`: no dashes in prose. Use commas, colons, brackets or a new sentence.
  Ranges still take an unspaced en dash (pages 10–20) and are not counted.

**Dash caps** are the most dashes allowed per 100 words. The published house
styles do not set one; the defaults above are an editing rule of thumb (over
about one per 100 words in narrative reads as a tic). Change them freely.
`/prose-style check` and `/rewrite-text` measure with
`.claude/scripts/dash-count.sh`.

**Serial comma.** `yes` writes "red, green, and blue"; `no` writes "red, green
and blue". Either way, never mixed.

**Contractions.** `by_register` leaves it to each character's voice profile and
the narrator register. A formal character can refuse contractions; a street kid
rarely will.

## Terms and capitalisation

Names the game capitalises, spells a particular way, or never translates. One
row per term; the localisation lead reads this table too.

| Term | Form | Note |
|------|------|------|
| | | |

## Period and regional exceptions

Text set in a time or place that keeps its own spelling, punctuation or
vocabulary (for example a western written in American English inside a British
English project). In-world text only; UI and system text follow the settings.

| Where it applies | Convention it keeps | Why |
|------------------|---------------------|-----|
| | | |

## Notes

- 
