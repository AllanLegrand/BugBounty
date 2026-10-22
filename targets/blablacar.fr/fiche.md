# Fiche cible — blablacar.fr

- **Programme** : BlaBlaCar — https://yeswehack.com/programs/bug-bounty-program-blablacar
- **Dans le périmètre** : oui (vérifié le 2026-10-22 — policy mise à jour le 2026-10-19)
- **Débit autorisé** : 5 req/s (interdiction de gros volumes de trafic)
- **En-tête d'identification exigé** : `User-Agent: BBC-YWH-Bugbounty-Psyckopato`

## Technologies

| Couche | Détail |
|---|---|
| Serveur | Envoy proxy (Google Cloud Platform) |
| Framework | SPA (Single Page Application — `X-Client: SPA\|1.0.0`) |
| CDN / WAF | Google Cloud CDN + DataDome (protection anti-bot) |
| Auth | <session, JWT, OAuth, SAML> |
| API | REST / OpenAPI (SDK TypeScript codegen, Gateway `edge.blablacar.fr`) |

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
