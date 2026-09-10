# Scripts

| Script | Rôle | Réseau |
|---|---|---|
| `check-scope.sh` | Dit si un hôte est autorisé par `scope/` | aucun |
| `init-target.sh` | Crée `targets/<cible>/` à partir des modèles | aucun |
| `recon-passive.sh` | Recon via sources tierces uniquement | tiers seulement |

## check-scope.sh

```bash
./scripts/check-scope.sh app.exemple.com
./scripts/check-scope.sh https://api.exemple.com/v1/users autre.com

# En filtre dans un pipeline : ne laisse passer que ce qui est autorisé
subfinder -d exemple.com -silent | ./scripts/check-scope.sh --filter | httpx -silent
```

Codes de sortie : `0` tout est autorisé · `1` au moins un hôte refusé · `2` erreur d'usage.
**Passe toujours tes listes par ce filtre avant un outil actif.**

## init-target.sh

```bash
./scripts/init-target.sh app.exemple.com
```

Crée la fiche, les checklists, le journal et les dossiers `recon/ notes/ evidences/`,
puis vérifie le périmètre. N'écrase jamais une cible existante.

## recon-passive.sh

```bash
./scripts/recon-passive.sh exemple.com
```

Interroge crt.sh, les sources passives de `subfinder`, et `waybackurls`/`gau` s'ils sont
installés. Les outils absents sont simplement sautés. La sortie est **filtrée par le périmètre**.

L'étape suivante (`httpx`, `ffuf`, `nuclei`…) est **active** : elle envoie des requêtes à la
cible. Vérifie d'abord que la policy l'autorise et respecte `BB_RATE_LIMIT`.

## Écrire son propre script

- `set -euo pipefail` en tête.
- Toute liste d'hôtes passe par `check-scope.sh --filter` avant l'outil actif.
- Respecter `BB_RATE_LIMIT` et `BB_HEADER` depuis `.env`.
- Écrire dans `targets/<cible>/recon/`, jamais à la racine.
