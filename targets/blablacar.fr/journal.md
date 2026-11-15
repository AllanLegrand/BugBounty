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

## 2026-11-10 — Préparation des captures et du contrôle d'accès

- Configuration de Burp Suite pour capturer le trafic d'un navigateur distinct.
  Trafic de test limité aux quatre hôtes du scope, en HTTPS/443, avec le
  User-Agent demandé. Aucun scan ni crawler.
- Vérification locale du proxy et des restrictions avant navigation. L'accueil,
  `/manifest.json` et `/browser-support` répondent 200 dans Chrome.
- `/login` est ensuite bloqué par DataDome (403). Le profil Psyckopato reste
  visible dans le navigateur Burp ; un `GET /private-profile/v5` en 200 est
  repéré, mais sa reproduction reste à faire.
- Le seul script anti-bot `/i.js` est autorisé comme dépendance navigateur :
  HTTP 200, `ex_20261110T104534.537236000_ca629752`. L'iframe de vérification
  reste bloquée. La session est arrêtée à ce stade.
- Préparation du contrôle d'accès au profil en lecture seule. Référence du
  refus DataDome sur `/login` : `ex_20261110T103256.958083000_7171be1f`.
  Aucune comparaison entre comptes ni vulnérabilité confirmée.

## 2026-11-11 — Connexion et contrôle d'accès du profil

### Blocages DataDome et dépendances de connexion

- Ouverture de Burp Community dans un projet temporaire. L'ancien historique
  Burp n'est plus disponible, mais les captures enregistrées sont conservées.
- `/login` et une requête de profil sans Authorization ni Cookie répondent 403
  DataDome. Le blocage vient de l'anti-bot. Il ne permet pas de vérifier si l'API
  protège les données du compte.
- Pour afficher la page de connexion, chargement de l'iframe, du script et du
  POST automatique de vérification DataDome, puis des fichiers sous
  `cdn.blablacar.com/k/a/` et du script Nethone
  `d1bc1vxcilyy41.cloudfront.net/s/559691/dNAKXV.js?from=www.blablacar.fr`.
- Ces fichiers servent à faire fonctionner la page. Les fournisseurs restent
  hors du périmètre des tests. Les appels vers eux ne contiennent pas les cookies
  ni les jetons BlaBlaCar. Le Referer ne contient que l'origine du site.
- Le script et le POST DataDome répondent 200, puis `/login` répond 200.
  Le bouton de connexion reste bloqué tant que le script Nethone n'est pas chargé.
  Après son chargement, la connexion du compte de test devient possible.
- Captures de cette progression :

| Observation | Statut | Référence locale |
|---|---|---|
| Page `/login` bloquée | 403 | `ex_20261111T174817.168715000_851c9879` |
| Script DataDome `/i.js` | 200 | `ex_20261111T174817.609495000_67ecb42d` |
| Profil sans Authorization ni Cookie, refus anti-bot | 403 | `ex_20261111T174834.712856000_0bad9ec6` |
| Iframe DataDome `/interstitial/` | 200 | `ex_20261111T175222.118309000_7e758318` |
| Script `/interstitial.1.36.0.202611111.js` | 200 | `ex_20261111T180146.313921000_ec167984` |
| POST automatique de vérification | 200 | `ex_20261111T180151.641197000_61ffda10` |
| Page `/login` après vérification | 200 | `ex_20261111T180153.561028000_c6a7b8d1` |
| Profil sans authentification, seul cookie DataDome conservé, refus anti-bot | 403 | `ex_20261111T180315.874068000_6adc3266` |

- Espacement du proxy fixé à 250 ms. Sur les 22 échanges enregistrés avant
  connexion, dont 16 ressources CDN, l'intervalle minimal enregistré est 250 ms.
  Les rejeux manuels sont effectués séparément de la navigation.

### Profil Psyckopato : référence et contrôle sans authentification

- Connexion réussie au compte Psyckopato, puis ouverture du menu Profil.
  Aucune modification du profil.
- Le navigateur envoie `GET https://edge.blablacar.fr/private-profile/v5` : HTTP 200,
  `ex_20261111T181833.505209000_76ac1c82`. Réponse avec `user_uuid`, `about_you`,
  `personal_info`, `account`, `travel_preferences` ; marqueur Psyckopato vérifié.
- Navigation suspendue pendant les deux rejeux séquentiels, pour éviter
  le trafic parallèle. Rejeu authentifié HTTP 200,
  `ex_20261111T181949.887257000_f0089fc7`, même `user_uuid` et même marqueur de compte.
- Rejeu sans Authorization et sans cookies `app_token`, `blablacar_token`,
  `user_id`, etc. Seul Cookie `datadome` conservé. HTTP 401,
  `ex_20261111T181956.713114000_c814b291`, type `SECURITY_UNAUTHORIZED`, message
  `no authentication and resource is not public`. Aucun champ de profil privé.
- Sans authentification, cette requête ne renvoie pas les données du profil.
  Aucune faille n'a été trouvée avec ce test.
  Le code JavaScript construit ce GET avec `X-Locale` et `X-Client`.
  Il n'y a pas d'identifiant d'objet dans le chemin ou les paramètres.
  Ce test ne permet donc pas de vérifier une IDOR.
- Requêtes brutes et captures conservées dans une archive locale hors du dépôt.
- Suite : capturer la référence du compte de test Allan dans une session distincte
  et vérifier l'association de la réponse au compte authentifié.

## 2026-11-12 — Vérification des captures et cartographie

- Vérification des captures déjà enregistrées, sans renvoyer les requêtes.
- L'historique contient alors 187 échanges. Cinq captures du 11 novembre
  donnent les résultats suivants :
  - `/private-profile/v5` sans Authorization, cookies de connexion conservés :
    HTTP 401 `SECURITY_UNAUTHORIZED`, `ex_20261111T182945.521558000_8c04e081`.
  - `/private/session/v1` avec Authorization : HTTP 200,
    `ex_20261111T183011.291051000_def807f8` ; sans Authorization et avec le seul
    cookie `datadome` : HTTP 401 `SECURITY_UNAUTHORIZED`,
    `ex_20261111T183016.606391000_2ec020c5`.
  - `/messaging/configuration/v2/me` avec Authorization : HTTP 200,
    `ex_20261111T183023.467570000_b19bae25` ; sans Authorization et avec le seul
    cookie `datadome` : HTTP 401 `SECURITY_UNAUTHORIZED`,
    `ex_20261111T183029.986186000_882af693`.
- Ces résultats viennent des captures existantes. Aucune faille n'est montrée
  par ces comparaisons. Les jetons ne sont pas recopiés dans le journal.

### Comparaison entre comptes restante

- La comparaison avec Allan n'a pas été effectuée.
- Il reste à capturer le profil de chaque compte séparément. Chaque jeton
  doit renvoyer le profil du compte auquel il appartient.
- Une comparaison possible porte sur le cookie `user_id` réellement observé :
  token d'un compte et cookie `user_id` connu de l'autre. Ce test n'a pas été réalisé.
- Pour tester l'accès à une donnée de l'autre compte, il faut trouver une requête
  qui utilise son identifiant. Seules les données de nos deux comptes peuvent
  servir au test. Aucun identifiant n'a été inventé ou recherché au hasard.

### Cartographie des pages et graphe de navigation

- Cartographie des pages et construction d'un graphe de navigation à partir
  des liens observés et des bundles déjà capturés.
- Un nouveau script DataDome est chargé dans Chrome :
  `/interstitial.1.36.0.202611121.js`. Aucun identifiant BlaBlaCar n'est envoyé
  au fournisseur. DataDome reste hors du périmètre des tests.
- Le script et le POST de vérification répondent 200. Le navigateur est connecté
  au compte Psyckopato. Le compte affiché correspond aux captures de session.
  Les menus avant et après connexion et les onglets du profil sont relevés.
  Aucun profil n'est modifié. Aucun test avec Allan n'est réalisé ce jour-là.

#### Résultats de la cartographie

- 97 adresses vérifiées par des GET envoyés un par un : 83 réponses 200, 7 redirections
  (4 × 301 et 3 × 302), 7 réponses 404. Parmi les 83 réponses 200, 82 sont du
  HTML et une est `robots.txt` ; 67 pages 200 contiennent un titre H1 capturé.
- 673 modèles de routes trouvés dans les fichiers JavaScript, dont 211 avec
  des paramètres ou un joker (`*`). 243 morceaux de chemins sont conservés à part.
  Leur adresse complète n'est pas connue. Ils n'ont pas été testés comme URL.
- 2 440 destinations dans le scope repérées dans les liens HTML, sans visiter
  chacune. L'analyse rassemble 504 captures locales, dont 265 dans le scope,
  et 154 corps JavaScript distincts déjà chargés par le navigateur.
- Graphe : 3 090 entrées et 5 953 liens, dont 10 relevés dans les menus ou
  les onglets. Les autres viennent du HTML. Les routes sans lien connu sont
  affichées seules.

#### Conditions des tests

Les GET manuels restent sur `www.blablacar.fr`, `m.blablacar.fr`,
`auth.blablacar.fr` et `edge.blablacar.fr`, en HTTPS/443. Le périmètre de
chaque destination a été vérifié avant l'envoi. Aucun crawler, scan ou envoi
parallèle n'a été lancé.

La navigation a utilisé le Chrome dédié avec Burp Suite, avec un espacement
minimal de 250 ms entre les requêtes. Les GET manuels ont ensuite été effectués
séparément, espacés de plus d'une seconde, avec le navigateur sur `about:blank`.
Aucun formulaire de modification, paiement, réservation,
publication, inscription ou vérification d'identité n'a été soumis.

Les fichiers du CDN et de l'anti-bot sont chargés pour faire fonctionner le site.
Aucun test n'est effectué sur ces fournisseurs. Le script DataDome du 12 novembre
est chargé avec les mêmes limites que celui du 11.

Le graphe signale 40 destinations externes « Hors scope », trouvées dans les
liens HTML. Elles n'ont pas été visitées pour la cartographie. Cliquer un nœud
du graphe change la sélection locale et ne contacte pas le site.

#### Pages consultées

| Ensemble | Entrées représentatives | Résultat et limite |
|---|---|---|
| Accueil et recherche | `/`, `/search-car-sharing`, `/carpool`, `/bus`, `/train` | HTML reçu ; rubriques Covoiturage et Bus inspectées visuellement |
| Annuaires publics | `/carpool/routes`, `/carpool/destinations`, `/ride-sharing/all-cities`, `/ride-sharing/all-products`, `/bus/routes`, `/train/routes` | Liens de destinations et itinéraires inventoriés, sans parcourir chaque résultat |
| Connexion | `/login`, `/login/email`, `/login/forgot`, `/register`, `/register/dispatch` | HTML des pages d'entrée reçu ; aucune inscription ni demande de reset soumise |
| Profil | `/dashboard/profile/menu`, `/dashboard/profile/account`, `/dashboard/profile/general`, `/dashboard/profile/preferences` | Profil Psyckopato affiché ; certaines réponses ne contiennent que la base HTML de l'application, sans titre H1 |
| Compte | Notifications, protection des données, avis, paiements, virements, moyens de paiement | Entrées et liens répertoriés ; aucune transaction ni modification |
| Trajets et messages | `/rides`, `/messages/list` | HTML reçu ; aucune conversation ni réservation de tiers ouverte |
| Publication | `/offer-seats`, `/offer-seats/departure`, `/calculateur` | Début de parcours seulement ; aucune offre publiée |
| Information | Pages bus/train/covoiturage, sécurité, applications mobiles, assurance | 38 racines CMS du catalogue vérifiées, plus les liens d'entrée pertinents |
| Services | Racines `auth` et `edge` | 404 à la racine ; cela ne signifie pas que les API observées sur ces hôtes sont indisponibles |

#### Redirections et routes indisponibles

`m.blablacar.fr/` redirige vers `www.blablacar.fr/` (301). `/contact` redirige
vers `support.blablacar.com/fr-fr/contact` (301), destination hors scope non
suivie. `/insurance-carpooling` redirige vers `/l/insurance-carpooling` (302),
vérifié séparément en 200. `/dashboard/profile/verifications` et
`/dashboard/profile/vehicles` redirigent vers `/dashboard/profile/menu` (301).
`/ride-sharing-abroad` redirige vers l'accueil (302).

Réponses 404 observées : `/blablahome`, `/blablahome/download-the-app`,
`/rides/history`, `/carpool/safety`, `/sitemap.xml` et les racines `auth`/`edge`.
`/blablahome/learn-more` redirige vers `/blablahome/download-the-app` (302).
Une route présente dans le JavaScript n'est donc pas forcément disponible en
France. `robots.txt` répond 200. La réponse ne donne pas d'adresse de sitemap.

#### Limites

Trouver un lien ne veut pas dire que sa page est accessible. Une réponse 200 peut
contenir seulement la base HTML de l'application. Elle ne prouve pas que l'écran
s'affiche correctement ou que les droits d'accès sont bien vérifiés.
Les parcours en plusieurs étapes et les données privées n'ont pas tous été testés.

81 des 97 captures signalent `remote error: tls: user canceled` après
réception d'une réponse. Les corps HTML concernés contiennent la balise de fin
`</html>`. Le problème reste indiqué dans les captures et le graphe.
Ce message ne montre pas une faille de BlaBlaCar. Les pages concernées
ne peuvent pas être considérées comme entièrement vérifiées.

#### Fichiers conservés

- [Pages vérifiées](recon/cartographie/pages-verifiees.csv) : statuts, titres, H1,
  redirections et références des captures, sans corps ni secrets.
- [Pages liées](recon/cartographie/pages-liees.csv) : inventaire des destinations repérées.
- [Routes frontend](recon/cartographie/routes-frontend.csv) : modèles, symboles et sources.
- [Liens observés dans l'interface](recon/cartographie/liens-interface.csv).
- [Sources JavaScript](recon/cartographie/sources-bundles.csv) : empreintes et références des captures.

Le [graphe de navigation](notes/visualisations/navigation-blablacar.html) est disponible hors ligne.
Le fichier HTML peut être ouvert directement, sans les scripts qui l'ont créé.
Les CSV ci-dessus contiennent les résultats de la cartographie.
Les notes saisies dans la vue ne sont pas enregistrées dans un fichier du dépôt.
Les captures brutes sont conservées dans une archive locale séparée du dépôt.

Les listes détaillées des relations HTML, des échanges dans le scope et des
fragments relatifs sont conservées dans une archive locale hors du dépôt.

La recherche, le choix d'une page et le champ de notes fonctionnent dans le graphe.
Il reste à tester certains parcours avec nos données de test et à faire
la comparaison avec Allan.

### Technologies repérées

- Les captures et les fichiers JavaScript déjà enregistrés donnent les versions
  suivantes : React/React DOM 19.3.1, React Router 7.18.5 et DOMPurify 3.4.17.
  Rspack et libsodium sont aussi repérés.
- Les fichiers et les réponses API montrent des références à
  DataDome, Nethone/CloudFront, GetStream, Braze, Didomi, Trustpilot, AB Tasty et GTM.
  Certains fichiers sont chargés, d'autres sont seulement référencés ou bloqués.
- Les en-têtes contiennent `istio-envoy`, `Via: 1.1 google` et une annonce HTTP/3.
  Plusieurs versions du SDK OpenAPI sont présentes. Cela ne donne pas les versions
  du serveur. Le langage du backend, sa base de données et l'utilisation de
  TypeScript ne sont pas confirmés par les fichiers analysés.
- Le détail est dans `fiche.md`. Le nom ou la version d'une bibliothèque
  ne suffit pas à dire qu'il existe une faille.

### Bilan des captures

- Bilan : 504 captures, 97 adresses vérifiées, 673 modèles de routes,
  2 440 destinations liées, 5 943 liens HTML et 10 liens d'interface.
- Sept captures confirment les résultats sur le profil, la session et la
  configuration de messagerie : 200 avec Bearer et 401 sans authentification.
  Le profil répond aussi 401 sans Bearer lorsque les cookies de connexion sont
  conservés. Cette vérification utilise les captures existantes, sans nouvel envoi.
