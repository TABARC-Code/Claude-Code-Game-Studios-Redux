#!/usr/bin/env bash
# skill-links.sh — which skills name which other skills, in both directions.
#
# Every skill's text points at other skills (its next steps, the skill it
# hands a file to, the one it is not a substitute for). Nothing recorded the
# other direction, so a user standing in /prose-style could not see what led
# there, and 62% of the pointers were one-way. This reads the pointers that are
# already in the text and writes both directions into each skill, between
# markers at the end of its SKILL.md:
#
#   Links to:     the skills this skill's own text names
#   Linked from:  the skills whose text names this one
#
# The block is generated, so the two directions cannot drift. To add a link,
# name the skill in the skill's text where a reader would want it, then run
# `--write`. Never edit a block by hand: --check will say it is stale.
#
# OBSERVATIONS, NOT A VERDICT (CLAUDE.md, "Helpers in .claude/scripts/"), apart
# from --write, which rewrites only the region between the markers (or appends
# one block at the end of a file that has none). It reports what it found and
# what it could not read; what to do about a row is for the reader or for CI.
#
# Usage: bash .claude/scripts/skill-links.sh [--check | --write | --self-test] [--root DIR]
#   --check      (default) report; write nothing
#   --write      regenerate every block, then report
#   --self-test  build a throwaway project that breaks each check, and exit 1
#                unless every row appears. Proves the checks can see.
#   --root DIR   the project; defaults to the repo this script is in
#   -h, --help   this text
#
# What counts as a link: a `/skill-name` in any Markdown file of the skill
# (SKILL.md and references/, not README.md or description.md) that names an
# existing skill, outside the generated block. Words after a slash that are not
# skills (paths, URLs) never count: a name has to match a skill folder.
#
# Output: TSV.
#   skills <n>  links <n>  entry_points <n>
#   orphan <skill>                    nothing links in, and it is not listed as an entry point
#   unknown_handoff <skill> <name> <file:line>   a Next Steps item names a skill that does not exist
#   entry_point_unknown <name>        listed in skill-entry-points.txt but there is no such skill
#   entry_point_linked <name>         listed, but something now links to it (the list can shrink)
#   block_missing <skill>             no generated block yet
#   block_stale <skill>               the block differs from what --write would produce
#   wrote <skill>                     (--write only) the block was changed
#   not_read <skill> <reason>         a file it could not read, so its links are unknown
#   not_written <skill> <reason>      (--write only)
#   summary orphans=<n> unknown_handoff=<n> block_missing=<n> block_stale=<n> not_read=<n>
#
# Entry points are skills a person starts directly, so nothing needs to link in:
# `.claude/docs/skill-entry-points.txt`, one `name  # reason` per line.
#
# After merging upstream, a conflict at the end of a SKILL.md is usually this
# block: keep the upstream text, then run `--write`.
#
# Always exits 0 once it has run (1 for a failed --self-test, 2 for bad usage).
# awk, find, sort, cmp and bash only. Bash 3.2 and BWK awk safe.

set -u
LC_ALL=C
export LC_ALL

usage() { sed -n '2,/^set -u/p' "$0" | sed '$d' | sed 's/^# \{0,1\}//'; }

MODE="check"
ROOT=""
while [ $# -gt 0 ]; do
  case "$1" in
    --check)     MODE="check"; shift ;;
    --write)     MODE="write"; shift ;;
    --self-test) MODE="selftest"; shift ;;
    --root)      ROOT="${2:-}"; shift 2 || { echo "skill-links: --root needs a value" >&2; exit 2; } ;;
    -h|--help)   usage; exit 0 ;;
    *)           echo "skill-links: unknown argument: $1" >&2; exit 2 ;;
  esac
done

START='<!-- skill-links:start -->'
END='<!-- skill-links:end -->'
SELF="$0"

# ---------------------------------------------------------------------------
# --self-test
# ---------------------------------------------------------------------------
if [ "$MODE" = "selftest" ]; then
  T="$(mktemp -d 2>/dev/null || mktemp -d -t skilllinks)"
  trap 'rm -rf "$T"' EXIT
  for n in alpha beta gamma delta; do mkdir -p "$T/.claude/skills/$n"; done
  mkdir -p "$T/.claude/docs"
  printf -- '---\nname: alpha\n---\n# Alpha\n\n## Recommended Next Steps\n\n- `/beta`: carry on\n- `/ghost`: not a skill\n' > "$T/.claude/skills/alpha/SKILL.md"
  printf -- '---\nname: beta\n---\n# Beta\n\nSee /gamma and design/delta for paths that are not links.\n' > "$T/.claude/skills/beta/SKILL.md"
  printf -- '---\nname: gamma\n---\n# Gamma\n\nRun /alpha first.\n' > "$T/.claude/skills/gamma/SKILL.md"
  printf -- '---\nname: delta\n---\n# Delta\n\nNo links at all.\n' > "$T/.claude/skills/delta/SKILL.md"
  printf 'delta  # entered directly\nnobody  # no such skill\n' > "$T/.claude/docs/skill-entry-points.txt"
  fail=0
  need() { printf '%s\n' "$OUT" | grep -E -q "$1" || { echo "self-test: missing row: $2" >&2; fail=1; }; }
  OUT="$(bash "$SELF" --check --root "$T")"
  need '^block_missing	alpha$' "block_missing"
  need '^unknown_handoff	alpha	ghost	' "unknown_handoff"
  need '^entry_point_unknown	nobody$' "entry_point_unknown"
  OUT="$(bash "$SELF" --write --root "$T")"
  need '^wrote	alpha$' "wrote"
  OUT="$(bash "$SELF" --check --root "$T")"
  printf '%s\n' "$OUT" | grep -E -q '^(block_missing|block_stale)' && { echo "self-test: blocks not clean after --write" >&2; fail=1; }
  grep -q 'Linked from: `/gamma`' "$T/.claude/skills/alpha/SKILL.md" || { echo "self-test: alpha is not linked from gamma" >&2; fail=1; }
  grep -q 'Links to: `/beta`' "$T/.claude/skills/alpha/SKILL.md" || { echo "self-test: alpha does not link to beta" >&2; fail=1; }
  grep -q 'Linked from: `/alpha`' "$T/.claude/skills/beta/SKILL.md" || { echo "self-test: beta is not linked from alpha" >&2; fail=1; }
  # A hand edit to a block, and an orphan: remove beta's mention of gamma.
  sed 's/Links to: .*/Links to: `\/zzz`/' "$T/.claude/skills/gamma/SKILL.md" > "$T/x" && cat "$T/x" > "$T/.claude/skills/gamma/SKILL.md"
  printf -- '---\nname: beta\n---\n# Beta\n\nNothing named here now.\n' > "$T/.claude/skills/beta/SKILL.md"
  OUT="$(bash "$SELF" --check --root "$T")"
  need '^block_stale	gamma$' "block_stale after a hand edit"
  need '^orphan	gamma$' "orphan once nothing names gamma"
  if [ "$fail" = 0 ]; then echo "self-test ok: every row appeared"; exit 0; fi
  echo "self-test FAILED"
  exit 1
fi

# ---------------------------------------------------------------------------
# Resolve the project.
# ---------------------------------------------------------------------------
if [ -z "$ROOT" ]; then
  ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." 2>/dev/null && pwd)"
fi
[ -d "$ROOT" ] || { echo "skill-links: no such directory: $ROOT" >&2; exit 2; }
cd "$ROOT" || exit 2

SK=".claude/skills"
ENTRY=".claude/docs/skill-entry-points.txt"
T="$(mktemp -d 2>/dev/null || mktemp -d -t skilllinks)"
trap 'rm -rf "$T"' EXIT
: > "$T/names"; : > "$T/edges.raw"; : > "$T/notread"; : > "$T/handoff"

if [ ! -d "$SK" ]; then
  printf 'summary\torphans=0\tunknown_handoff=0\tblock_missing=0\tblock_stale=0\tnot_read=1\n'
  printf 'not_read\t%s\t%s\n' "$SK" "no skills folder"
  exit 0
fi

for d in "$SK"/*/; do
  n="${d%/}"; n="${n##*/}"
  if [ -L "$SK/$n/SKILL.md" ]; then printf '%s\t%s\n' "$n" "SKILL.md is a symlink" >> "$T/notread"; continue; fi
  [ -f "$SK/$n/SKILL.md" ] || continue
  if [ ! -r "$SK/$n/SKILL.md" ]; then printf '%s\t%s\n' "$n" "SKILL.md is not readable" >> "$T/notread"; continue; fi
  echo "$n" >> "$T/names"
done
sort -o "$T/names" "$T/names"
NAMES="|$(tr '\n' '|' < "$T/names")"
nskills=$(wc -l < "$T/names" | tr -d ' ')

EDGE='
BEGIN { n = split(NAMES, a, "|"); for (i = 1; i <= n; i++) if (a[i] != "") isn[a[i]] = 1 }
/^<!-- skill-links:start/ { skip = 1 }
skip { if ($0 ~ /^<!-- skill-links:end/) skip = 0; next }
{
  line = $0; lastc = ""
  while (match(line, /\/[a-z][a-z0-9-]*/)) {
    pre = (RSTART > 1) ? substr(line, RSTART - 1, 1) : lastc
    nm = substr(line, RSTART + 1, RLENGTH - 1)
    lastc = substr(line, RSTART + RLENGTH - 1, 1)
    line = substr(line, RSTART + RLENGTH)
    if (pre ~ /[A-Za-z0-9_.\/~-]/) continue
    if ((nm in isn) && nm != A) print A "\t" nm
  }
}'

HAND='
BEGIN {
  n = split(NAMES, a, "|"); for (i = 1; i <= n; i++) if (a[i] != "") isn[a[i]] = 1
  split("clear compact init model config cost doctor resume", bi, " "); for (i in bi) isb[bi[i]] = 1
}
/^<!-- skill-links:start/ { skip = 1 }
skip { if ($0 ~ /^<!-- skill-links:end/) skip = 0; next }
/^#+[[:space:]]/ { insec = (tolower($0) ~ /next step/); next }
insec && /^[[:space:]]*([-*]|[0-9]+\.)[[:space:]]/ {
  if (match($0, /`\/[a-z][a-z0-9-]*/)) {
    nm = substr($0, RSTART + 2, RLENGTH - 2)
    if (!(nm in isn) && !(nm in isb)) printf "unknown_handoff\t%s\t%s\t%s:%d\n", A, nm, FILENAME, FNR
  }
}'

while read -r n; do
  files="$SK/$n/SKILL.md"
  for f in $(find "$SK/$n" -type f -name '*.md' ! -name README.md ! -name description.md ! -path "$SK/$n/SKILL.md" 2>/dev/null | sort); do
    if [ -L "$f" ] || [ ! -r "$f" ]; then printf '%s\t%s\n' "$n" "cannot read $f" >> "$T/notread"; continue; fi
    files="$files $f"
  done
  # shellcheck disable=SC2086
  awk -v A="$n" -v NAMES="$NAMES" "$EDGE" $files >> "$T/edges.raw"
  awk -v A="$n" -v NAMES="$NAMES" "$HAND" "$SK/$n/SKILL.md" >> "$T/handoff"
done < "$T/names"

sort -u "$T/edges.raw" > "$T/edges"
nedges=$(wc -l < "$T/edges" | tr -d ' ')

# Entry points: first word of each non-comment line.
: > "$T/entry"
if [ -f "$ENTRY" ]; then
  awk '!/^[[:space:]]*#/ && NF { print $1 }' "$ENTRY" | sort -u > "$T/entry"
fi
nentry=$(wc -l < "$T/entry" | tr -d ' ')

# The block for one skill, written to $T/block.<name>.
make_block() {
  n="$1"
  to=$(awk -F'\t' -v N="$n" '$1 == N { printf "%s`/%s`", s, $2; s = ", " }' "$T/edges")
  from=$(awk -F'\t' -v N="$n" '$2 == N { printf "%s`/%s`", s, $1; s = ", " }' "$T/edges")
  [ -n "$to" ] || to="none"
  if [ -z "$from" ]; then
    if grep -q -x "$n" "$T/entry"; then from="none (entry point)"; else from="none"; fi
  fi
  {
    printf '%s\n' "$START"
    printf '## Links\n\n'
    printf 'Generated by `.claude/scripts/skill-links.sh --write`. Change the skill'"'"'s text, not this block.\n\n'
    printf 'Links to: %s\n' "$to"
    printf 'Linked from: %s\n' "$from"
    printf '%s\n' "$END"
  } > "$T/block.$n"
}

rows="$T/rows"; : > "$rows"
nwrote=0; nmissing=0; nstale=0
while read -r n; do
  make_block "$n"
  f="$SK/$n/SKILL.md"
  hasstart=$(grep -c -F "$START" "$f")
  hasend=$(grep -c -F "$END" "$f")
  if [ "$hasstart" -eq 0 ]; then
    if [ "$MODE" = "write" ]; then
      { cat "$f"; [ -n "$(tail -c1 "$f")" ] && echo; echo; cat "$T/block.$n"; } > "$T/new.$n"
      cat "$T/new.$n" > "$f"
      printf 'wrote\t%s\n' "$n" >> "$rows"; nwrote=$((nwrote + 1))
    else
      printf 'block_missing\t%s\n' "$n" >> "$rows"; nmissing=$((nmissing + 1))
    fi
    continue
  fi
  if [ "$hasstart" -ne 1 ] || [ "$hasend" -ne 1 ]; then
    printf 'not_written\t%s\t%s\n' "$n" "markers are not a single start and a single end" >> "$rows"
    continue
  fi
  awk -v S="$START" -v E="$END" '$0 == S { on = 1 } on { print } $0 == E { on = 0 }' "$f" > "$T/cur.$n"
  if ! cmp -s "$T/cur.$n" "$T/block.$n"; then
    if [ "$MODE" = "write" ]; then
      awk -v S="$START" -v E="$END" -v BF="$T/block.$n" '
        $0 == S { while ((getline l < BF) > 0) print l; skip = 1; next }
        skip { if ($0 == E) skip = 0; next }
        { print }' "$f" > "$T/new.$n"
      cat "$T/new.$n" > "$f"
      printf 'wrote\t%s\n' "$n" >> "$rows"; nwrote=$((nwrote + 1))
    else
      printf 'block_stale\t%s\n' "$n" >> "$rows"; nstale=$((nstale + 1))
    fi
  fi
done < "$T/names"

# Orphans: nothing links in and not a listed entry point.
norph=0
: > "$T/orph"
while read -r n; do
  if ! awk -F'\t' -v N="$n" '$2 == N { f = 1 } END { exit !f }' "$T/edges"; then
    if ! grep -q -x "$n" "$T/entry"; then printf 'orphan\t%s\n' "$n" >> "$T/orph"; norph=$((norph + 1)); fi
  fi
done < "$T/names"

# Entry-point list hygiene.
: > "$T/entryrows"
while read -r e; do
  [ -n "$e" ] || continue
  if ! grep -q -x "$e" "$T/names"; then printf 'entry_point_unknown\t%s\n' "$e" >> "$T/entryrows"
  elif awk -F'\t' -v N="$e" '$2 == N { f = 1 } END { exit !f }' "$T/edges"; then printf 'entry_point_linked\t%s\n' "$e" >> "$T/entryrows"; fi
done < "$T/entry"

nunk=$(wc -l < "$T/handoff" | tr -d ' ')
nnr=$(wc -l < "$T/notread" | tr -d ' ')

printf 'skills\t%s\tlinks\t%s\tentry_points\t%s\n' "$nskills" "$nedges" "$nentry"
sort "$T/orph"
sort "$T/handoff"
sort "$T/entryrows"
sort "$rows"
sort "$T/notread" | while IFS="$(printf '\t')" read -r a b; do printf 'not_read\t%s\t%s\n' "$a" "$b"; done
printf 'summary\torphans=%s\tunknown_handoff=%s\tblock_missing=%s\tblock_stale=%s\tnot_read=%s\n' "$norph" "$nunk" "$nmissing" "$nstale" "$nnr"
exit 0
