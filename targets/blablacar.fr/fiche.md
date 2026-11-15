# Fiche cible — blablacar.fr

- **Programme** : BlaBlaCar — https://yeswehack.com/programs/bug-bounty-program-blablacar
- **Dans le périmètre** : oui (vérifié le 2026-10-22 — policy mise à jour le 2026-10-19)
- **Débit autorisé** : 5 req/s (interdiction de gros volumes de trafic)
- **En-tête d'identification exigé** : `User-Agent: BBC-YWH-Bugbounty-Psyckopato`

## Technologies

| Couche | Détail |
|---|---|
| Proxy serveur | Envoy. En-tête `Server: istio-envoy` sur les quatre hôtes. Les serveurs derrière ce proxy ne sont pas connus. |
| Infrastructure | Intermédiaire Google. `Via: 1.1 google` et résultat httpx du 22 octobre. Cela ne donne pas l'hébergement de tous les services. |
| HTTP/3 | Annoncé par le serveur. `Alt-Svc: h3=":443"`. Non testé : QUIC était désactivé dans Chrome. |
| Frontend | React et React DOM 19.3.1. Versions trouvées dans `vendor.*.js`, avec `rendererPackageName:"react-dom"`. L'application utilise `X-Client: SPA\|1.0.0`. |
| Routes frontend | React Router 7.18.5. Valeur `__reactRouterVersion="7.18.5"` dans `vendor.*.js`. Les routes sont dans `index.*.js`. |
| Outil de compilation | Rspack. Repéré dans `index.*.js`. Version inconnue. |
| API | REST / JSON, SDK OpenAPI, passerelle `edge.blablacar.fr`. En-têtes `X-Blablacar-Openapi-Codegen-Endpoint` et `X-Blablacar-Openapi-Codegen-Version`. |
| Authentification | Jetons d’accès et de rafraîchissement, Bearer pour les appels privés. Réponse de `/secure-token` : `access_token`, `refresh_token`, `user_id`. Les jetons observés ont une forme UUID, pas JWT. |
| Cookies | `blablacar_token`, `user_id`, `app_token`, `vstr_id`. Noms observés dans les captures. Attributs des cookies non vérifiés en détail. |
| Nettoyage HTML | DOMPurify 3.4.17. Nom, version et fonction `sanitize` dans `vendor.*.js`. Son utilisation pour chaque champ n'a pas été vérifiée. |
| Cryptographie côté navigateur | libsodium. `libsodium.6871bf0b9257a4cd.chunk.js` chargé en 200. Version et utilisation exacte inconnues. |

Les versions `4.589.0`, `4.1443.0`, `4.2127.0` et `4.2166.0` correspondent au SDK
OpenAPI utilisé par les appels capturés. Ce ne sont pas des versions du serveur.
Les fichiers analysés ne suffisent pas à confirmer que le SDK est écrit en TypeScript.

Le langage du backend, son framework et sa base de données restent inconnus.
Les captures ne donnent pas non plus l'architecture cloud complète.

### Connexion et cookies

- La connexion envoie un `POST https://auth.blablacar.fr/secure-token` avec
  `grant_type: "password"`.
- La réponse contient `access_token`, `refresh_token` et `user_id`.
  Les jetons observés ressemblent à des UUID, pas à des JWT.
- Les appels API privés utilisent `Authorization: Bearer`.
- Les cookies `blablacar_token`, `user_id`, `app_token` et `vstr_id` sont présents
  dans les captures. Après connexion, `blablacar_token` contient les deux jetons.
- Les attributs de tous les cookies et l'expiration réelle des jetons n'ont pas
  été vérifiés. SAML et la connexion par un compte tiers n'ont pas été testés.

### Services externes repérés

Ces services servent au fonctionnement du site. Aucun test n'a été réalisé
sur leurs domaines.

| Couche | Détail |
|---|---|
| DataDome | Anti-bot. Cookie `datadome`, en-tête `X-Datadome: protected`, scripts sur `ct.captcha-delivery.com` et iframe/POST sur `geo.captcha-delivery.com`. Les scripts des 11 et 12 novembre répondent 200. |
| `cdn.blablacar.com` | Fichiers du site. JavaScript, styles, images et polices sous `/k/a/` chargés en 200. Les polices sous `/kairos/` restent bloquées. |
| Nethone, via CloudFront | Vérification antifraude à la connexion. Script `d1bc1vxcilyy41.cloudfront.net/s/559691/dNAKXV.js?from=www.blablacar.fr` chargé en 200. Fonctions `startProfilingSession` et `isNethoneLoading` dans le code. Cela ne prouve pas que BlaBlaCar héberge son backend sur AWS. |
| GetStream / Stream | Messagerie. Champs `getstream_user_id`, `getstream_api_key` et `token` dans `/messaging/configuration/v2/me`. Aucune connexion directe au fournisseur. |
| Braze | Communication avec les utilisateurs. Fichier `brazeSDK.*.chunk.js` chargé. Appels vers `customer.fra-01.braze.eu` bloqués. |
| Didomi | Consentement. Référence à `sdk.privacy-center.org` et cookie `didomi_token`. SDK bloqué lors de la navigation. Ce cookie sert au consentement, pas à la connexion BlaBlaCar. |
| Trustpilot | Avis. Fichier `fragment-trustpilot-reviews.*.chunk.js` chargé. Aucun appel direct au service confirmé. |
| AB Tasty | Intégration dans les pages. Script `try.abtasty.com` référencé dans le HTML, mais chargement bloqué. |
| Google Tag Manager | Gestion des balises. Référence à `www.googletagmanager.com` dans le code, mais chargement bloqué. |

## Comptes de test

| Rôle | Identifiant | Notes |
|---|---|---|
| Utilisateur A (attaquant) | Psyckopato | Baoudinov.bugbounty@proton.me |
| Utilisateur B (victime) | Allan | allan123.bugbounty@proton.me |
| Admin (si fourni) | | |

## Surface d'attaque

| Fonctionnalité | Intérêt | Testée | Notes |
|---|---|---|---|
| Inscription / login | Page d'auth (`/login`) | ☐ | Déclenche `GET /notification/count/v4` sur `edge.blablacar.fr` |
| Reset mot de passe | | ☐ | |
| Profil / upload | | ☐ | |
| Paiement / facturation | | ☐ | |
| Partage / permissions | | ☐ | |
| Import par URL / webhook | | ☐ | |
| Export / rapports | | ☐ | |
| Espace admin | | ☐ | |

## Identifiants d'objets observés

- `vstr_id` / `X-Visitor-Id` (visiteur non connecté) : format **UUIDv4** (ex: `00892c2b-a801-4332-abef-08bb883a003d`) — aléatoire, non incrémental.
- `X-Correlation-Id` : format **UUIDv4** (traçage distribué des requêtes par Envoy).
- En-tête révélateur : `X-Blablacar-Openapi-Codegen-Endpoint` (ex: `GET /notification/count/v4`) — fuite de la route exacte OpenAPI côté serveur.

## Pistes à creuser

- [ ] Rechercher un schéma OpenAPI / Swagger (`openapi.json`, `swagger.json`, documentation API) dans les chunks JS du frontend.
- [ ] Analyser le mécanisme d'authentification sur `/login` (cookies HttpOnly vs Bearer JWT).

## Écarté (et pourquoi)

- <endpoint> : <raison — évite de le retester dans un mois>

## Mise à jour du 12 novembre 2026

### État des vérifications

| Fonction | Ce qui a été fait | Ce qui reste à tester |
|---|---|---|
| Connexion / inscription | Connexion réussie ; pages `/login`, `/login/email`, `/register` et `/register/dispatch` repérées. | Inscription non testée. |
| Mot de passe oublié | Page `/login/forgot` repérée. | Aucun email demandé, aucun jeton de reset testé. |
| Profil | `/private-profile/v5` : 200 avec authentification, 401 sans. | Comparaison avec Allan et upload non testés. |
| Messagerie | `/messaging/configuration/v2/me` : 200 avec authentification, 401 sans. | Aucune conversation ouverte pendant cette séance. |
| Recherche / trajets | Pages de recherche, annuaires et `/rides` repérés. | Aucune réservation effectuée. |
| Publication | Début du parcours sur `/offer-seats` et `/offer-seats/departure`. | Aucune offre publiée. |
| Paiement | Pages de virements, historique et moyens de paiement repérées. | Aucune transaction ni vérification du paiement. |
| Droits entre comptes | Deux comptes de test disponibles : Psyckopato et Allan. | Comparaison non réalisée. |

Aucune fonction d'import par URL, de webhook, d'export ou d'administration
n'a été confirmée dans ce travail. Une page repérée n'est pas forcément une
fonction entièrement testée.

L'en-tête `X-Blablacar-Openapi-Codegen-Endpoint` indique la route utilisée par le
SDK. Sa présence ne suffit pas à montrer une fuite ou une faille, contrairement
à la première interprétation notée plus haut. `X-Correlation-Id` sert à relier
les requêtes ; son format UUIDv4 ne permet pas d'identifier à lui seul le composant
qui le crée.

### Sources et suite des tests

- React, React DOM, React Router et DOMPurify : `vendor.a06e5a1fa9200f17.js`,
  capture `ex_20261111T181013.097086000_d0760743`. Également repérés dans
  `vendor.23fd2cde68119511.js` et `vendor.b056113f3a164ebe.js`.
- Rspack et chargement des SDK : `index.28cb66222e63eb21.js`,
  capture `ex_20261111T181013.348109000_a22319ad`.
- [Sources des fichiers JavaScript](recon/cartographie/sources-bundles.csv).
- [Pages vérifiées](recon/cartographie/pages-verifiees.csv) et
  [routes frontend](recon/cartographie/routes-frontend.csv).
- [Cartographie dans le journal](journal.md#cartographie-des-pages-et-graphe-de-navigation).
  Une route présente dans le code n'est pas forcément disponible en France.
- Les requêtes et réponses complètes sont archivées hors du dépôt.

Le mécanisme de connexion est maintenant identifié : cookies applicatifs et
jetons Bearer. Il reste à vérifier les attributs des cookies, l'expiration des
jetons et les droits d'accès entre les deux comptes. La recherche d'un schéma
OpenAPI reste aussi à faire.
