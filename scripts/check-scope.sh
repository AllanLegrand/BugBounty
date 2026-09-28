#!/usr/bin/env bash
# check-scope.sh — Vérifie qu'un hôte appartient au périmètre autorisé.
#
#   ./scripts/check-scope.sh app.exemple.com
#   ./scripts/check-scope.sh https://api.exemple.com/v1/users
#   subfinder -d exemple.com -silent | ./scripts/check-scope.sh --filter
#
# Règle : l'exclusion l'emporte toujours ; ce qui n'est pas explicitement
# autorisé est refusé.
#
# Codes de sortie : 0 = tout est dans le périmètre, 1 = au moins un hôte refusé,
#                   2 = erreur d'utilisation.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
IN_FILE="$ROOT/scope/in-scope.txt"
OUT_FILE="$ROOT/scope/out-of-scope.txt"

if [[ -t 1 ]]; then
  GREEN=$'\033[0;32m'; RED=$'\033[0;31m'; YELLOW=$'\033[0;33m'; RESET=$'\033[0m'
else
  GREEN=""; RED=""; YELLOW=""; RESET=""
fi

usage() {
  sed -n '2,12p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'
  exit 2
}

# Extrait l'hôte : retire le schéma, les identifiants, le chemin, le port ; minuscules.
normalize() {
  local h="$1"
  h="${h#*://}"
  h="${h#*@}"
  h="${h%%/*}"
  h="${h%%:*}"
  h="${h%.}"
  printf '%s' "$(echo "$h" | tr '[:upper:]' '[:lower:]')"
}

# Charge un fichier de périmètre dans un tableau (commentaires et vides ignorés).
load_patterns() {
  local file="$1"
  [[ -f "$file" ]] || { echo "${RED}Fichier de périmètre absent : $file${RESET}" >&2; exit 2; }
  local line
  while IFS= read -r line || [[ -n "$line" ]]; do
    line="${line%%#*}"
    line="$(printf '%s' "$line" | tr -d '[:space:]')"
    [[ -z "$line" ]] && continue
    printf '%s\n' "$(normalize "$line")"
  done < "$file"
}

IN_PATTERNS=()
while IFS= read -r line; do
  IN_PATTERNS+=("$line")
done < <(load_patterns "$IN_FILE")

OUT_PATTERNS=()
while IFS= read -r line; do
  OUT_PATTERNS+=("$line")
done < <(load_patterns "$OUT_FILE")

if [[ ${#IN_PATTERNS[@]} -eq 0 ]]; then
  echo "${YELLOW}⚠  scope/in-scope.txt est vide : remplis-le depuis la policy du programme avant de tester.${RESET}" >&2
fi

matches() { # matches <host> <pattern...>
  local host="$1"; shift
  local p
  for p in "$@"; do
    # shellcheck disable=SC2254  # glob volontaire : *.exemple.com
    case "$host" in $p) return 0 ;; esac
  done
  return 1
}

# verdict <host> → 0 autorisé / 1 refusé, motif sur stdout
verdict() {
  local host; host="$(normalize "$1")"
  if [[ -z "$host" ]]; then
    printf 'INVALIDE|hôte illisible'; return 1
  fi
  if matches "$host" "${OUT_PATTERNS[@]-}"; then
    printf 'HORS PÉRIMÈTRE|exclu explicitement par out-of-scope.txt'; return 1
  fi
  if matches "$host" "${IN_PATTERNS[@]-}"; then
    printf 'AUTORISÉ|correspond à in-scope.txt'; return 0
  fi
  printf 'HORS PÉRIMÈTRE|absent de in-scope.txt — le doute vaut interdiction'; return 1
}

# --- Mode filtre : ne laisse passer que les hôtes autorisés ------------------
if [[ "${1:-}" == "--filter" || "${1:-}" == "-f" ]]; then
  status=0
  while IFS= read -r line; do
    [[ -z "$line" ]] && continue
    if verdict "$line" >/dev/null; then printf '%s\n' "$line"; else status=1; fi
  done
  exit $status
fi

[[ $# -ge 1 ]] || usage
[[ "${1:-}" == "-h" || "${1:-}" == "--help" ]] && usage

exit_code=0
for target in "$@"; do
  res="$(verdict "$target")" && ok=1 || ok=0
  label="${res%%|*}"; reason="${res#*|}"
  host="$(normalize "$target")"
  if [[ $ok -eq 1 ]]; then
    printf '%s✔ %-40s %s%s (%s)\n' "$GREEN" "$host" "$label" "$RESET" "$reason"
  else
    printf '%s✘ %-40s %s%s (%s)\n' "$RED" "$host" "$label" "$RESET" "$reason"
    exit_code=1
  fi
done
exit $exit_code
