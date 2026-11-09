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

## 2026-11-09 — Connexion et analyse de la session dans Burp

**Périmètre** : Observation de la connexion avec mon compte de test `Psyckopato`. Scope Burp limité à `www`, `m`, `auth` et `edge.blablacar.fr`, en HTTPS sur le port 443.

**Fait**
- J'ai relu les règles sur YesWeHack et vérifié les quatre hôtes du scope.
- J'ai configuré Burp avec l'interception désactivée et l'historique limité au scope.
- J'ai activé une règle pour ajouter `BBC-YWH-Bugbounty-Psyckopato` au User-Agent.
- Je me suis connecté depuis `/login/email` dans le navigateur Burp, puis j'ai regardé les requêtes dans **Proxy → HTTP history**.

**Observations**
- À 14:57, la page `/login` et l'appel `/notification/count/v4` répondent **200** avant la connexion.
- À 14:59, la connexion envoie un `POST /secure-token` vers `auth.blablacar.fr`. La réponse est **200**.
- La requête contient notamment `grant_type: "password"`, `rememberMe` et `encryption_key_id`.
- La réponse fournit un `access_token`, un `refresh_token` et un `user_id`. Les tokens ressemblent à des UUID, pas à des JWT.
- Le champ `expires_in` indique **86 399 secondes**, soit environ 24 h. Je n'ai pas encore vérifié l'expiration réelle.
- Les cookies `blablacar_token` et `user_id` sont créés à la connexion. Le premier contient les deux tokens.
- Ensuite, `GET /private/session/v1` sur `edge.blablacar.fr` répond **200**. Cet appel utilise `Authorization: Bearer <masqué>`.
- Les en-têtes `X-Client: SPA|1.0.0` et `X-Blablacar-Openapi-Codegen-Endpoint` sont présents. La version du SDK observée est `4.2140.0`.
- Après connexion, j'arrive sur `/search-car-sharing`. Je vois aussi des appels à `/location/suggestions` et `/search/form/v2`.
- Pour l'instant, je n'ai pas trouvé de faille.

**Prochaine étape**
- Vérifier le User-Agent envoyé, puis regarder les fonctions du profil et leurs appels API.
- Préparer des tests de contrôle d'accès entre mes deux comptes.
