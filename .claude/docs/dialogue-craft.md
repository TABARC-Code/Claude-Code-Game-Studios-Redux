# Dialogue Craft

How player-facing speech is made to sound like people talking, not a design
document reading itself aloud. The `writer` agent and `/rewrite-text` read this
on demand; it is a reference, not session context.

It does not decide what a character knows, wants or is allowed to say. That is
the voice profile (`design/narrative/characters/[name].md`) and the narrative
director's canon. It does not decide spelling or punctuation. That is the style
guide (`design/narrative/style-guide.md`, set with `/prose-style`).

## The rule underneath the rest

Dialogue is not a delivery van for information. People answer the question they
wish they'd been asked, stop halfway, hide a need behind a joke, and say the
thing next to the thing. The player should hear what the character wants and
what is in the way, even when neither is said.

Games add a second job: the line also has to carry something the player can
use (a clue, a price, a direction). The craft is doing both without the join
showing.

## Five tools

| Tool | What it does | A line that uses it |
|---|---|---|
| Evasion | Answers a different question than the one asked | "Is the bridge safe?" / "My brother crossed it last spring." |
| Interruption | Cuts the speech off before it finishes | "If you'd just let me expl" / "No." |
| Status | Speech shows rank, education, confidence, dependence or resentment | A guard says "sir" twice in one breath and never once to the cook. |
| Implication | The meaning sits under the words | "You'll want to keep the lamp lit." |
| Omission | The most important thing is the thing not said | A shopkeeper prices everything except the locked drawer. |

Pick one or two per exchange. All five at once reads as a writing exercise.

## From psychology to speech

Take the character sheet's wound, lie and flaw and ask what each does to the
mouth, not just the behaviour.

- The wound decides what the character will not talk about, and what they change
  the subject to.
- The lie decides what they say about themselves when nobody asked.
- The flaw decides the repeated habit: the interruption, the deflecting joke, the
  over-explaining, the silence.

A voice is consistent when the same pressure produces the same kind of
deflection every time, in different words.

## Register

Speech carries class, education, region, profession and generation. Use it by
choosing which words and which sentence shapes the person would reach for, not
by spelling accents phonetically (hard to read, hard to localise, hard to voice
act). One or two markers per speaker is enough: a stock phrase, a sentence
shape, a word they use for something everyone else calls something else.

Period or regional text keeps its own conventions. The style guide records the
exception; do not flatten it back to the project default.

## Games are not novels

- **Barks** (combat shouts, idle chatter) repeat, so each needs to survive being
  heard fifty times. Vary the wording across a set, keep each one short, and do
  not hide new information in a line the player will skip.
- **Branches** need options that differ in intent, not three wordings of "yes".
  The reply should show which option was taken.
- **Choice labels** are not the spoken line. A label says what the player is
  doing ("Ask about the bridge"); the spoken line says it the way the character
  would.
- **Voice acting.** Say it aloud. If a sentence needs a breath in the wrong place,
  rewrite it.
- **Limits.** Lines stay inside the dialogue box limit in
  `.claude/rules/narrative.md`. Named placeholders (`{player_name}`) are never
  reworded, reordered into a different grammar, or removed.
- **Localisation.** Avoid idiom, wordplay that only works in the source language,
  and sentence fragments assembled from variables. Flag a line that can only be
  a pun, so the translators are told.

## Four read-aloud tests

1. **Cover the speaker tags.** Can you still tell who is talking? If two
   characters are interchangeable, one voice has not been written.
2. **What does each speaker want, and what is in the way?** If neither answer
   shows in the exchange, the scene is information with names attached.
3. **Say less.** Cut the first and last sentence of every line. Keep whichever
   cut changed nothing.
4. **Does anyone answer the question they were asked?** If everyone does, add
   one evasion.

## Common failures

| Failure | What it sounds like | Fix |
|---|---|---|
| On the nose | "I am angry because you betrayed me." | State the effect, not the emotion: what the anger makes them do or refuse. |
| Echo | "Where is the key?" / "The key? It is in the chest." | Drop the repeated noun; answer. |
| Plot lecture | A speaker explains what both of them already know | Give the player the fact through a disagreement or a need. |
| Same voice | Every NPC uses the narrator's sentences | Give each a sentence length, a habit and a word only they use. |
| Silence as the only emotion | "[She says nothing.]" in every scene | Replace some with an action, an object or a change of subject. |
| Tidy ending | Every exchange closes on a neat line | End one beat early. |
| Speech about speech | "As you know..." / "Let me be clear..." | Cut the preamble. |

## What this document never licenses

- Inventing lore, facts, prices, mechanics or durations to make a line richer.
  Text that describes a mechanic says only what the design defines.
- Changing who a character is. Voice work serves the profile; if the profile
  blocks a good line, say so and let the narrative director decide.
- Rewording a line the user marked as fixed (a quoted source, a legal line, a
  line already recorded by a voice actor).
