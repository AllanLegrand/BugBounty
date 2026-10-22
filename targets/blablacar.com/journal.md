# Journal de bord — blablacar.com

Une ligne par session. Sert de preuve de bonne foi en cas de litige, et de mémoire pour toi.

## 2026-10-22 — 10:30 à 11:00

**Périmètre du jour** : Reconnaissance passive sur blablacar.com et blablacar.fr

**Fait**
- Installation de subfinder et gau (`brew install subfinder gau`).
- `./scripts/recon-passive.sh blablacar.com` : 181 sous-domaines trouvés -> 14 conservés dans le scope (`targets/blablacar.com/recon/subdomains-2026-10-22.txt`), 4 URLs gardées.
- `./scripts/recon-passive.sh blablacar.fr` : 94 sous-domaines trouvés -> 4 conservés dans le scope (`targets/blablacar.fr/recon/subdomains-2026-10-22.txt`).
- Revue de la policy YesWeHack (mise à jour du 19/10/2026) : retrait de BlaBlaCar Daily (`blablacardaily.com`, `daily.blablacar.fr`, `api.blablalines.com`).
- Nettoyage de `scope/in-scope.txt` pour ne garder que les 4 cibles actives (`edge`, `auth`, `www`, `m`).

**Observations**
- Structure identique sur .com et .fr : `auth`, `edge`, `m` et `www`.
- Les cibles prioritaires pour la suite restent `auth` (login/sessions) et `edge` (API/routing).

**Impasses** (ne pas refaire)
- 167 sous-domaines hors scope sur .com et 90 sur .fr

**Prochaine étape**
- Lancer httpx sur les hôtes in-scope pour identifier les codes HTTP, redirections et technos (avec User-Agent et rate-limit).

