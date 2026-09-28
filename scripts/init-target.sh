#!/usr/bin/env bash
# init-target.sh — Crée l'espace de travail d'une nouvelle cible.
#
#   ./scripts/init-target.sh app.exemple.com
#
# Crée targets/<cible>/ avec la fiche, la checklist, le journal et les dossiers
# recon/ notes/ evidences/. Ne écrase jamais un dossier existant.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [[ $# -ne 1 || "$1" == "-h" || "$1" == "--help" ]]; then
  echo "Usage : $(basename "$0") <hôte>" >&2
  echo "Exemple : $(basename "$0") app.exemple.com" >&2
  exit 2
fi

RAW="$1"
HOST="${RAW#*://}"; HOST="${HOST%%/*}"; HOST="${HOST%%:*}"; HOST="$(echo "$HOST" | tr '[:upper:]' '[:lower:]')"
DIR="$ROOT/targets/$HOST"
TODAY="$(date +%F)"

if [[ -d "$DIR" ]]; then
  echo "La cible existe déjà : targets/$HOST — rien n'a été modifié." >&2
  exit 1
fi

mkdir -p "$DIR"/{recon,notes,evidences}

subst() { sed -e "s|<host>|$HOST|g" -e "s|<cible>|$HOST|g" -e "s|AAAA-MM-JJ|$TODAY|g" "$1"; }

subst "$ROOT/templates/fiche-cible.md" > "$DIR/fiche.md"
subst "$ROOT/templates/journal.md"     > "$DIR/journal.md"
cp    "$ROOT/docs/02-checklist-web.md" "$DIR/checklist-web.md"
cp    "$ROOT/docs/03-checklist-api.md" "$DIR/checklist-api.md"

cat > "$DIR/recon/.gitkeep" <<'EOG'
EOG
cp "$DIR/recon/.gitkeep" "$DIR/notes/.gitkeep"
cp "$DIR/recon/.gitkeep" "$DIR/evidences/.gitkeep"

echo "✔ Cible créée : targets/$HOST"
echo
echo "  targets/$HOST/fiche.md          ← à remplir en premier"
echo "  targets/$HOST/checklist-web.md"
echo "  targets/$HOST/journal.md"
echo

echo "Vérification du périmètre :"
"$ROOT/scripts/check-scope.sh" "$HOST" || {
  echo
  echo "⚠  Cet hôte n'est PAS autorisé par scope/. Complète le périmètre depuis la policy"
  echo "   du programme avant d'envoyer la moindre requête."
}
