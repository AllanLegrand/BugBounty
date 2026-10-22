# Journal de bord — blablacar.fr

Une ligne par session. Sert de preuve de bonne foi en cas de litige, et de mémoire pour toi.

## 2026-10-22 (Matin — 10:30 à 11:00)

**Périmètre** : Reconnaissance passive sur blablacar.fr

**Fait**
- Installation de subfinder et gau (`brew install subfinder gau`).
- `./scripts/recon-passive.sh blablacar.fr` : 94 sous-domaines trouvés -> 4 conservés dans le scope (`targets/blablacar.fr/recon/subdomains-2026-10-22.txt`).
- Revue de la policy YesWeHack (mise à jour du 19/10/2026) : retrait de BlaBlaCar Daily (`blablacardaily.com`, `daily.blablacar.fr`, `api.blablalines.com`).
- Nettoyage de `scope/in-scope.txt` pour ne garder que les 4 cibles actives (`edge`, `auth`, `www`, `m`).

**Observations**
- Structure sous-domaines sur .fr : `auth`, `edge`, `m` et `www`.
- Les cibles prioritaires pour la suite restent `auth` (login/sessions) et `edge` (API/routing).

**Impasses** (ne pas refaire)
- 90 sous-domaines hors scope écartés par le script.

**Prochaine étape**
- Lancer httpx sur les hôtes in-scope pour identifier les codes HTTP, redirections et technos (avec User-Agent et rate-limit).

## 2026-10-22 (Après-midi — 14:10 à 14:20)

**Périmètre** : Sondage HTTP et fingerprinting des sous-domaines in-scope (recon active)

**Fait**
- Résolution du conflit de binaire httpx via `brew link --overwrite httpx`.
- Exécution de `httpx` sur les sous-domaines in-scope avec `-sc -title -tech-detect -rl 5` et le User-Agent obligatoire.

**Observations**
- Infrastructure identifiée : Envoy proxy, Google Cloud CDN, HTTP/3.
- Détection d'un WAF anti-bot : DataDome bloque les requêtes directes en CLI (code 403 Forbidden sur `www`, `edge`, `auth`, `m`).
- Fiche cible (`targets/blablacar.fr/fiche.md`) mise à jour avec les technos détectées.

**Impasses** (ne pas refaire)
- Inutile de continuer les requêtes automatisées en ligne de commande brute (DataDome bloque les outils non-navigateurs).

**Prochaine étape**
- Configurer Burp Suite avec le User-Agent exigé et tester directement depuis un vrai navigateur pour contourner l'anti-bot DataDome.

## 2026-10-22 (Après-midi — 14:30 à 15:15)

**Périmètre** : Configuration Burp Suite et inspection des cookies pré-authentification

**Fait**
- Configuration de Burp Suite avec règle Match & Replace (User-Agent obligatoire `BBC-YWH-Bugbounty-Psyckopato`).
- Lancement du navigateur Burp et inspection des cookies avant connexion.
- Ajout des comptes de test dans `fiche.md` (`Psyckopato` et `Allan`).

**Observations**
- DataDome valide le trafic du navigateur et dépose le cookie `datadome`.
- Cookie `vstr_id` (visiteur non connecté) au format **UUIDv4** aléatoire.
- Token de consentement RGPD (`didomi_token`) encodé en JWT Base64.
- Aucun cookie de session utilisateur présent avant connexion.

**Impasses** (ne pas refaire)
- Crawlers CLI sur le domaine principal (bloqués par DataDome).

**Prochaine étape**
- Connexion avec le compte de test `Psyckopato` pour observer les cookies et tokens d'API post-authentification.

## 2026-10-22 (Après-midi — 15:25 à 15:35)

**Périmètre** : Cartographie du trafic sur la page de connexion (`/login`)

**Fait**
- Accès à `https://www.blablacar.fr/login` depuis le navigateur Burp.
- Capture de la première requête API déclenchée en arrière-plan (`GET /notification/count/v4` vers `edge.blablacar.fr`).

**Observations**
- Découverte majeure d'un SDK OpenAPI : le frontend SPA envoie des en-têtes explicites (`X-Blablacar-Openapi-Codegen-Endpoint: GET /notification/count/v4`, `X-Blablacar-Openapi-Codegen-Version: 4.1962.0`) vers `edge.blablacar.fr`.
- Traçage des requêtes avec `X-Correlation-Id` (UUIDv4) et renvoi de l'identifiant visiteur `X-Visitor-Id` (UUIDv4).
- Confirmation de l'API Gateway sur `edge.blablacar.fr` avec un client typé SPA (`X-Client: SPA|1.0.0`).

**Impasses** (ne pas refaire)
- (aucune)

**Prochaine étape**
- Soumettre le formulaire de connexion avec le compte `Psyckopato` pour capturer la requête POST d'authentification et identifier la gestion de session (JWT vs cookies).
