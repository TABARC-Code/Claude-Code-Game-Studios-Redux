# one-page-design

Ideas are cheap and the first week of a project is mostly people discovering they each imagined a different game. A one-page vision fixes that, if it really is one page.

`/one-page-design` walks you through seven sections and writes `design/one-page-design.md`:

1. Mantra and player fantasy
2. Design pillars (three at most)
3. Narrative and/or mechanical summary
4. Hook
5. Interface
6. Art style
7. Music and sound

The layout is adapted from the one-page game design document template published by DevPods. The one-page limit comes from Stone Librande's GDC talk, the same source the repo's `game-brief.md` template cites.

## What's different about it

`/brainstorm` already finds a concept and writes the brief. This page sits beside it and adds three things the brief doesn't ask for. A mantra that has to settle a real argument or it's just a slogan. An **interface** section, because nothing else in the pipeline asks how the game is actually held. And art and sound references with the *feeling* wanted, not just a mood word.

Each section has a test. Pillars over three get pushed back, and empty words (fun, polished, immersive) get rejected. The hook has to be nameable as "like X, and also Y", and you're asked whether a player meets it in the first five minutes. It's a bit nagging. That's the point.

If you've nothing for a section, it stays `OPEN:` with the question that would fill it. The skill won't invent references to make the page look finished.

## Limits

Downstream skills (`/create-stories`, `/map-systems`) read the brief or the concept doc, not this page. It's a vision reference for people and for `/art-bible`. It isn't a gate and it isn't in the workflow catalogue. If there's no concept at all, it stops and sends you to `/brainstorm`.

After writing, it runs `wc -w` on the file. Aim for 400 words or fewer. Over 500 and it tells you which two sections are longest, then waits to be asked before trimming.

Author: TABARC-Code
