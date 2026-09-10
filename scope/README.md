# Périmètre

Deux fichiers **machine-lisibles**, recopiés depuis la page du programme.
`scripts/check-scope.sh` et `scripts/recon-passive.sh` s'en servent.

## Format

- Une entrée par ligne.
- `#` en début de ligne = commentaire.
- `*.exemple.com` = wildcard (couvre `a.exemple.com`, `a.b.exemple.com`).
- `exemple.com` = correspondance exacte de l'hôte.
- Les URL complètes sont acceptées : seul l'hôte est comparé.

## Règle de décision

1. Si l'hôte correspond à `out-of-scope.txt` → **INTERDIT** (l'exclusion gagne toujours).
2. Sinon s'il correspond à `in-scope.txt` → autorisé.
3. Sinon → **INTERDIT** (le doute vaut hors périmètre).

Mets à jour ces fichiers à chaque changement de la policy, et note la date.
