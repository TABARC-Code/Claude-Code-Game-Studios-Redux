#!/usr/bin/env bash
# line-check.sh — character counts and placeholders for lines of game text.
#
# Replaces the by-eye counting in /rewrite-text: "no line over 120 characters"
# and "every {placeholder} survived the rewrite" are the two checks a model gets
# wrong while reading, and the two a localiser notices first.
#
# EMITS OBSERVATIONS, NOT A VERDICT (CLAUDE.md, "Helpers in .claude/scripts/").
# It prints the length of each line and the placeholders in it, and in --pair
# mode whether the placeholder sets match. What a limit is, and whether a
# mismatch matters, is the calling skill's and the user's call.
#
# Usage: bash .claude/scripts/line-check.sh [--max N] [--pair] FILE | -
#   FILE | -     a text file, or standard input. Blank lines are skipped.
#   --max N      also print whether each line is over N characters
#   --pair       each line is `before<TAB>after`; compare the two
#   -h, --help   this text
#
# Output: TSV.
#   line  <n>  chars=<c>  placeholders=<list|->  [over_max=<yes|no>]
#   pair  <n>  before=<c>  after=<c>  placeholders_before=<list|->  placeholders_after=<list|->  same=<yes|no>  [over_max=<yes|no>]
#   total lines=<n>  max_chars=<c>  [over_max=<n>]  [placeholder_mismatches=<n>]
#
# chars counts UTF-8 characters, not bytes. A placeholder is {name}, {0} or a
# printf marker such as %s or %1$d; lists are sorted, so order does not matter,
# but a placeholder dropped, added or renamed does. `pair` stops at the first
# tab: a second tab is part of the after text.
#
# Always exits 0 once it has run (2 for bad usage). awk and bash only.

set -u
LC_ALL=C
export LC_ALL

usage() { sed -n '2,/^set -u/p' "$0" | sed '$d' | sed 's/^# \{0,1\}//'; }

MAX=""
PAIR=0
SRC=""
while [ $# -gt 0 ]; do
  case "$1" in
    --max)     MAX="${2:-}"; shift 2 || { echo "line-check: --max needs a number" >&2; exit 2; } ;;
    --pair)    PAIR=1; shift ;;
    -h|--help) usage; exit 0 ;;
    -)         SRC="-"; shift ;;
    -*)        echo "line-check: unknown argument: $1" >&2; exit 2 ;;
    *)         SRC="$1"; shift ;;
  esac
done
[ -n "$SRC" ] || { echo "line-check: give a FILE, or - for standard input" >&2; exit 2; }
case "$MAX" in ""|*[!0-9]*) [ -z "$MAX" ] || { echo "line-check: --max must be a whole number" >&2; exit 2; } ;; esac
if [ "$SRC" != "-" ] && [ ! -r "$SRC" ]; then
  echo "line-check: cannot read: $SRC" >&2
  exit 2
fi

AWK_PROG='
function nchars(s,   t) { t = s; gsub(/[\200-\277]/, "", t); return length(t) }
function sortjoin(s,    n, a, i, j, t, out) {
  if (s == "") return "-"
  n = split(s, a, "\034")
  for (i = 2; i <= n; i++) { t = a[i]; for (j = i - 1; j >= 1 && a[j] > t; j--) a[j + 1] = a[j]; a[j + 1] = t }
  out = a[1]; for (i = 2; i <= n; i++) out = out "," a[i]
  return out
}
function holders(s,    r, out) {
  out = ""
  while (match(s, /\{[A-Za-z0-9_]+\}|%[0-9]*\$?[sdif]/)) {
    out = out (out == "" ? "" : "\034") substr(s, RSTART, RLENGTH)
    s = substr(s, RSTART + RLENGTH)
  }
  return sortjoin(out)
}
{
  line = $0; sub(/\r$/, "", line)
  if (line ~ /^[[:space:]]*$/) next
  n++
  if (PAIR) {
    tab = index(line, "\t")
    if (tab == 0) { b = line; a = "" } else { b = substr(line, 1, tab - 1); a = substr(line, tab + 1) }
    cb = nchars(b); ca = nchars(a)
    pb = holders(b); pa = holders(a)
    same = (pb == pa) ? "yes" : "no"
    if (same == "no") mism++
    if (ca > maxc) maxc = ca
    printf "pair\t%d\tbefore=%d\tafter=%d\tplaceholders_before=%s\tplaceholders_after=%s\tsame=%s", n, cb, ca, pb, pa, same
    if (MAX != "") { o = (ca > MAX + 0) ? "yes" : "no"; if (o == "yes") over++; printf "\tover_max=%s", o }
    printf "\n"
  } else {
    c = nchars(line)
    if (c > maxc) maxc = c
    printf "line\t%d\tchars=%d\tplaceholders=%s", n, c, holders(line)
    if (MAX != "") { o = (c > MAX + 0) ? "yes" : "no"; if (o == "yes") over++; printf "\tover_max=%s", o }
    printf "\n"
  }
}
END {
  printf "total\tlines=%d\tmax_chars=%d", n + 0, maxc + 0
  if (MAX != "") printf "\tover_max=%d", over + 0
  if (PAIR) printf "\tplaceholder_mismatches=%d", mism + 0
  printf "\n"
}
'

if [ "$SRC" = "-" ]; then
  awk -v MAX="$MAX" -v PAIR="$PAIR" "$AWK_PROG"
else
  awk -v MAX="$MAX" -v PAIR="$PAIR" "$AWK_PROG" "$SRC"
fi
exit 0
