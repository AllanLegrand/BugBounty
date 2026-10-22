# Fiche cible — blablacar.fr

- **Programme** : BlaBlaCar — https://yeswehack.com/programs/bug-bounty-program-blablacar
- **Dans le périmètre** : oui (vérifié le 2026-10-22 — policy mise à jour le 2026-10-19)
- **Débit autorisé** : 5 req/s (interdiction de gros volumes de trafic)
- **En-tête d'identification exigé** : `User-Agent: BBC-YWH-Bugbounty-Psyckopato`

## Technologies

| Couche | Détail |
|---|---|
| Serveur | Envoy proxy (Google Cloud Platform) |
| Framework | |
| CDN / WAF | Google Cloud CDN + DataDome (protection anti-bot) |
| Auth | <session, JWT, OAuth, SAML> |
| API | <REST, GraphQL, gRPC> |

## Comptes de test

| Rôle | Identifiant | Notes |
|---|---|---|
| Utilisateur A (attaquant) | Psyckopato | Baoudinov.bugbounty@proton.me |
| Utilisateur B (victime) | Allan | allan123.bugbounty@proton.me |
| Admin (si fourni) | | |

## Surface d'attaque

| Fonctionnalité | Intérêt | Testée | Notes |
|---|---|---|---|
| Inscription / login | | ☐ | |
| Reset mot de passe | | ☐ | |
| Profil / upload | | ☐ | |
| Paiement / facturation | | ☐ | |
| Partage / permissions | | ☐ | |
| Import par URL / webhook | | ☐ | |
| Export / rapports | | ☐ | |
| Espace admin | | ☐ | |

## Identifiants d'objets observés

- `vstr_id` (visiteur non connecté) : format **UUIDv4** (ex: `00892c2b-a801-4332-abef-08bb883a003d`) — aléatoire, non incrémental.

## Pistes à creuser

- [ ]
- [ ]

## Écarté (et pourquoi)

- <endpoint> : <raison — évite de le retester dans un mois>
