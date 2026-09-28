#!/usr/bin/env bash
# recon-passive.sh — Reconnaissance strictement PASSIVE.
#
#   ./scripts/recon-passive.sh exemple.com
#
# Aucun paquet n'est envoyé vers la cible : seules des sources tierces publiques
# sont interrogées (crt.sh, sources passives de subfinder, Wayback Machine).
# Les résultats sont filtrés par scope/ avant d'être écrits.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [[ $# -ne 1 || "$1" == "-h" || "$1" == "--help" ]]; then
  echo "Usage : $(basename "$0") <domaine>" >&2
  exit 2
fi

DOMAIN="$(echo "$1" | tr '[:upper:]' '[:lower:]')"
OUT="$ROOT/targets/$DOMAIN/recon"
STAMP="$(date +%F)"
mkdir -p "$OUT"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

have() { command -v "$1" >/dev/null 2>&1; }
step() { printf '\n[*] %s\n' "$1"; }

step "crt.sh (transparence des certificats)"
if have curl && have jq; then
  curl -s --max-time 60 "https://crt.sh/?q=%25.${DOMAIN}&output=json" \
    | jq -r '.[].name_value' 2>/dev/null \
    | tr '[:upper:]' '[:lower:]' | tr -d '*' | sed 's/^\.//' \
    | sort -u > "$TMP/crtsh.txt" || : 
  echo "    $(wc -l < "$TMP/crtsh.txt" 2>/dev/null || echo 0) entrées"
else
  echo "    ignoré (curl et jq requis)"
fi

step "subfinder (sources passives)"
if have subfinder; then
  subfinder -d "$DOMAIN" -silent -all > "$TMP/subfinder.txt" 2>/dev/null || :
  echo "    $(wc -l < "$TMP/subfinder.txt" 2>/dev/null || echo 0) entrées"
else
  echo "    ignoré (subfinder non installé — voir docs/04-outils.md)"
fi

step "URLs historiques (Wayback / Common Crawl)"
if have waybackurls; then
  echo "$DOMAIN" | waybackurls > "$TMP/urls.txt" 2>/dev/null || :
elif have gau; then
  echo "$DOMAIN" | gau --subs > "$TMP/urls.txt" 2>/dev/null || :
else
  echo "    ignoré (waybackurls ou gau non installé)"
fi
[[ -f "$TMP/urls.txt" ]] && echo "    $(wc -l < "$TMP/urls.txt") URLs"

step "Agrégation et filtrage par le périmètre"
cat "$TMP"/crtsh.txt "$TMP"/subfinder.txt 2>/dev/null \
  | grep -E '^[a-z0-9._-]+$' | sort -u > "$TMP/all-subs.txt" || :

TOTAL=$(wc -l < "$TMP/all-subs.txt" 2>/dev/null || echo 0)
"$ROOT/scripts/check-scope.sh" --filter < "$TMP/all-subs.txt" > "$OUT/subdomains-$STAMP.txt" || :
KEPT=$(wc -l < "$OUT/subdomains-$STAMP.txt")

if [[ -f "$TMP/urls.txt" ]]; then
  "$ROOT/scripts/check-scope.sh" --filter < "$TMP/urls.txt" > "$OUT/urls-$STAMP.txt" || :
fi

cat <<EOR

─────────────────────────────────────────────
  Domaine        : $DOMAIN
  Trouvés        : $TOTAL sous-domaines
  Dans le scope  : $KEPT   → $OUT/subdomains-$STAMP.txt
$( [[ -f "$OUT/urls-$STAMP.txt" ]] && echo "  URLs (scope)   : $(wc -l < "$OUT/urls-$STAMP.txt")   → $OUT/urls-$STAMP.txt" )
─────────────────────────────────────────────

Les $((TOTAL - KEPT)) hôtes écartés sont HORS PÉRIMÈTRE : ne les teste pas.
Étape suivante (ACTIVE, donc uniquement si la policy l'autorise) :
  httpx -l $OUT/subdomains-$STAMP.txt -sc -title -tech-detect -rl \${BB_RATE_LIMIT:-5}
EOR
