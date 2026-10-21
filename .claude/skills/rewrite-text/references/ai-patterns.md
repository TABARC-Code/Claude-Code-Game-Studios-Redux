# Machine-Writing Patterns in Game Text

Symptoms to look for in `/rewrite-text` Phase 2. The families follow public
guidance on spotting machine-made prose, including Wikipedia's "Signs of AI
writing" page; the wording and the game examples here are this project's own.

A pattern is a symptom, not a crime. Tag a line only when, in context, it reads
as written by something that has never needed to say it aloud. Fix by saying the
specific thing the line is circling.

| Tag | What it looks like | Example | Usual fix |
|-----|--------------------|---------|-----------|
| `GRAND` | Importance announced, not shown | "This ancient blade is a testament to the smiths of old." | Say what it does or what someone did with it. |
| `VAGUE-SRC` | Authority with no name | "Many say the well is cursed." | Who says? A named person, or cut. |
| `TRIPLE` | Three items because three feels complete | "Brave, loyal, and true." | Keep the one that is true of this person. |
| `NOT-X-BUT-Y` | "It's not just a bridge, it's a promise." | | State the claim once. |
| `FILLER` | Transitions and softeners | "Indeed", "In truth", "Rest assured", "Let me be clear" | Cut. |
| `THESAURUS` | Synonyms rotated to avoid repeating a word | "blade", "weapon", "instrument of war" in three lines | Repeat the plain word; people do. |
| `HEDGE` | Qualifiers on a confident character | "perhaps", "somewhat", "it could be said" | Let the character commit, or give the hedge a reason. |
| `MORAL` | A closing line that sums the moral up | "And so he learned that courage is..." | End one beat earlier. |
| `FEELING-TOLD` | The emotion named, then explained | "I'm furious. You betrayed everything we built." | Show what the fury does. |
| `STAGE-TELL` | Narrated body language as a crutch | "A shiver ran down her spine." | One concrete detail, or none. |
| `ABSTRACT` | Big nouns where a thing would do | "the weight of destiny", "the tapestry of fate" | Name the object, the place, the person. |
| `ECHO` | Repeats the question before answering | "The key? It is in the chest." | Answer. |
| `LECTURE` | Speakers tell each other what both know | "As you know, the Order fell in the war..." | Move the fact into a disagreement or a need. |
| `SAME-VOICE` | Every speaker has the narrator's sentences | Merchant, guard and king all speak in balanced clauses | Give each a length, a habit and a word of their own. |
| `CHEER` | Unearned enthusiasm, exclamation marks | "What a wonderful adventure!" | Match the speaker's temperament. |
| `DASH-TIC` | Dashes as the default joint | Three in a paragraph | Governed by the style guide; measure with `dash-count.sh`. |
| `LIST-VOICE` | Bullet or heading rhythm in speech | "First, ... Second, ... Finally, ..." | Speech does not number itself unless the character does. |

## Not on this list on purpose

- Correct grammar, long sentences and formal diction are not patterns. A
  formal character should sound formal.
- Typos and broken grammar are never added to make text look human. Variety of
  rhythm and shape does that; planted errors only make localisers' work harder.
