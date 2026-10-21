#!/usr/bin/env bash
# dash-count.sh — how many dashes a text uses, in which form, and how dense.
#
# Replaces the by-eye counting in /prose-style (check mode) and /rewrite-text:
# a model asked to "keep em dashes under one per hundred words" will miscount,
# so the count is taken here and the skill reads it.
#
# EMITS OBSERVATIONS, NOT A VERDICT (CLAUDE.md, "Helpers in .claude/scripts/").
# It prints counts and the spacing of each dash. Whether a form matches the
# project's dash policy, and whether a density is over its cap, is the calling
# skill's call: the policy lives in design/narrative/style-guide.md.
#
# Usage: bash .claude/scripts/dash-count.sh [--lines] [--root DIR] FILE...
#   FILE        a text or Markdown file; `-` reads standard input
#   --lines     also print one row per dash with its file:line and form
#   --root DIR  resolve relative FILE paths from DIR; defaults to the cwd
#   -h, --help  this text
#
# Output: TSV.
#   file   <name>  words=<n>  em_unspaced=<n>  em_spaced=<n>  em_mixed=<n>
#          en_unspaced=<n>  en_spaced=<n>  en_mixed=<n>  en_range=<n>
#          hyphen_spaced=<n>  double_hyphen=<n>  dashes=<n>  per100=<x.xx>
#   dash   <file:line>  <form>                           (only with --lines)
#   not_read  <name>  <reason>
#   total  files=<n>  words=<n>  dashes=<n>  per100=<x.xx>
#
# What is counted, and what is not:
#   em_*           U+2014. unspaced = no space either side, which includes a
#                  dash at a line end (an interrupted line of speech). spaced =
#                  a space both sides. mixed = a space on one side only.
#   en_*           U+2013 used as a dash. A digit on both sides is a range
#                  (10–20): counted in en_range, NOT in dashes.
#   hyphen_spaced  a lone hyphen with a space either side, standing in for a dash
#   double_hyphen  two hyphens, standing in for a dash
#   dashes         em_* + en_* + hyphen_spaced + double_hyphen (no ranges)
#   words          whitespace-separated tokens that hold at least one letter or
#                  digit, outside fenced code blocks. A closed-up dash joins its
#                  two neighbours into one token, so a text full of unspaced em
#                  dashes is counted a few words short and its density comes
#                  out slightly high. Markdown list markers, horizontal rules
#                  and table rules are not words and not dashes.
#
# Always exits 0 once it has run (2 for bad usage). awk and bash only; bytes are
# matched directly so it does not depend on the locale. Bash 3.2 safe.

set -u
LC_ALL=C
export LC_ALL

usage() { sed -n '2,/^set -u/p' "$0" | sed '$d' | sed 's/^# \{0,1\}//'; }

LINES=0
ROOT=""
FILES=""
while [ $# -gt 0 ]; do
  case "$1" in
    --lines)   LINES=1; shift ;;
    --root)    ROOT="${2:-}"; shift 2 || { echo "dash-count: --root needs a value" >&2; exit 2; } ;;
    -h|--help) usage; exit 0 ;;
    -)         FILES="$FILES
-"; shift ;;
    -*)        echo "dash-count: unknown argument: $1" >&2; exit 2 ;;
    *)         FILES="$FILES
$1"; shift ;;
  esac
done

if [ -z "$FILES" ]; then
  echo "dash-count: give at least one FILE, or - for standard input" >&2
  exit 2
fi
if [ -n "$ROOT" ]; then
  [ -d "$ROOT" ] || { echo "dash-count: no such directory: $ROOT" >&2; exit 2; }
  cd "$ROOT" || exit 2
fi

tw=0; td=0; tf=0

# One awk program, run once per file. It prints the `dash` rows (if asked) and
# a final `RESULT` row that the shell turns into the `file` row.
AWK_PROG='
function bump(form) { c[form]++ }
function isdigit(ch) { return ch ~ /^[0-9]$/ }
function scan(s, ln,    n, i, three, pre, post, sp_pre, sp_post, form, j) {
  n = length(s)
  i = 1
  while (i <= n) {
    three = substr(s, i, 3)
    if (three == EM || three == EN) {
      pre  = (i > 1)     ? substr(s, i - 1, 1) : ""
      post = (i + 3 <= n) ? substr(s, i + 3, 1) : ""
      if (three == EN && isdigit(pre) && isdigit(post)) {
        bump("en_range"); i += 3; continue
      }
      sp_pre  = (pre  == " ")
      sp_post = (post == " ")
      if (sp_pre && sp_post)      form = "spaced"
      else if (!sp_pre && !sp_post) form = "unspaced"
      else                         form = "mixed"
      form = (three == EM ? "em_" : "en_") form
      bump(form)
      if (LINES) printf "dash\t%s:%d\t%s\n", NAME, ln, form
      i += 3; continue
    }
    if (substr(s, i, 2) == "--") {
      j = i; while (substr(s, j, 1) == "-") j++
      if (j - i == 2) { bump("double_hyphen"); if (LINES) printf "dash\t%s:%d\tdouble_hyphen\n", NAME, ln }
      i = j; continue
    }
    if (substr(s, i, 3) == " - ") {
      bump("hyphen_spaced"); if (LINES) printf "dash\t%s:%d\thyphen_spaced\n", NAME, ln
      i += 3; continue
    }
    i++
  }
}
BEGIN {
  EM = sprintf("%c%c%c", 226, 128, 148)
  EN = sprintf("%c%c%c", 226, 128, 147)
  split("em_unspaced em_spaced em_mixed en_unspaced en_spaced en_mixed en_range hyphen_spaced double_hyphen", keys, " ")
  for (k in keys) c[keys[k]] = 0
  words = 0; infence = 0
}
{
  line = $0; sub(/\r$/, "", line)
  if (line ~ /^[[:space:]]*(```|~~~)/) { infence = !infence; next }
  if (infence) next
  # Horizontal rules and table rules are layout, not prose.
  if (line ~ /^[[:space:]]*(---+|\*\*\*+|___+)[[:space:]]*$/) next
  if (line ~ /^[[:space:]]*\|[|:[:space:]-]+$/) next
  # A list marker is not a spaced hyphen.
  sub(/^[[:space:]]*[-*+][[:space:]]+/, "", line)
  scan(line, NR)
  n = split(line, tok, /[[:space:]]+/)
  for (t = 1; t <= n; t++) {
    w = tok[t]
    gsub(EM, "", w); gsub(EN, "", w)
    gsub(/[-[:punct:]]/, "", w)
    if (w != "") words++
  }
}
END {
  d = c["em_unspaced"] + c["em_spaced"] + c["em_mixed"] + c["en_unspaced"] + c["en_spaced"] + c["en_mixed"] + c["hyphen_spaced"] + c["double_hyphen"]
  printf "RESULT\t%d", words
  for (k = 1; k <= 9; k++) printf "\t%d", c[keys[k]]
  printf "\t%d\n", d
}
'

run_one() {
  # $1 = display name, $2 = path or "-"
  name="$1"; src="$2"
  if [ "$src" = "-" ]; then
    out="$(awk -v NAME="$name" -v LINES="$LINES" "$AWK_PROG" <&3)"
  else
    if [ ! -f "$src" ]; then
      printf 'not_read\t%s\t%s\n' "$name" "no such file"
      return
    fi
    if [ ! -r "$src" ]; then
      printf 'not_read\t%s\t%s\n' "$name" "not readable"
      return
    fi
    out="$(awk -v NAME="$name" -v LINES="$LINES" "$AWK_PROG" "$src")"
  fi
  printf '%s\n' "$out" | grep -v '^RESULT' | grep -v '^$'
  res="$(printf '%s\n' "$out" | grep '^RESULT')"
  w=$(printf '%s' "$res" | cut -f2)
  per="0.00"
  d=$(printf '%s' "$res" | cut -f12)
  if [ "${w:-0}" -gt 0 ]; then per=$(awk -v d="$d" -v w="$w" 'BEGIN { printf "%.2f", d * 100 / w }'); fi
  printf 'file\t%s\twords=%s\tem_unspaced=%s\tem_spaced=%s\tem_mixed=%s\ten_unspaced=%s\ten_spaced=%s\ten_mixed=%s\ten_range=%s\thyphen_spaced=%s\tdouble_hyphen=%s\tdashes=%s\tper100=%s\n' \
    "$name" "$w" "$(printf '%s' "$res" | cut -f3)" "$(printf '%s' "$res" | cut -f4)" "$(printf '%s' "$res" | cut -f5)" \
    "$(printf '%s' "$res" | cut -f6)" "$(printf '%s' "$res" | cut -f7)" "$(printf '%s' "$res" | cut -f8)" \
    "$(printf '%s' "$res" | cut -f9)" "$(printf '%s' "$res" | cut -f10)" "$(printf '%s' "$res" | cut -f11)" "$d" "$per"
  tw=$((tw + ${w:-0})); td=$((td + ${d:-0})); tf=$((tf + 1))
}

# The totals are carried through a temp file: a pipe would lose them in a subshell.
TMP="$(mktemp 2>/dev/null || mktemp -t dashcount)"
trap 'rm -f "$TMP"' EXIT
printf '%s\n' "$FILES" | grep -v '^$' > "$TMP"

# Keep the real standard input on fd 3: the loop below reads its list from a file.
exec 3<&0

while IFS= read -r f; do
  if [ "$f" = "-" ]; then run_one "stdin" "-"; else run_one "$f" "$f"; fi
done < "$TMP"

per="0.00"
[ "$tw" -gt 0 ] && per=$(awk -v d="$td" -v w="$tw" 'BEGIN { printf "%.2f", d * 100 / w }')
printf 'total\tfiles=%s\twords=%s\tdashes=%s\tper100=%s\n' "$tf" "$tw" "$td" "$per"
exit 0
