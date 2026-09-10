# Fiche cible — <host>

- **Programme** : <nom> — <url de la policy>
- **Dans le périmètre** : oui / non (vérifié le AAAA-MM-JJ)
- **Débit autorisé** : <n req/s>
- **En-tête d'identification exigé** : `<X-Bug-Bounty: ...>` ou aucun

## Technologies

| Couche | Détail |
|---|---|
| Serveur | |
| Framework | |
| CDN / WAF | |
| Auth | <session, JWT, OAuth, SAML> |
| API | <REST, GraphQL, gRPC> |

## Comptes de test

| Rôle | Identifiant | Notes |
|---|---|---|
| Utilisateur A (attaquant) | | |
| Utilisateur B (victime) | | |
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

<Format des ids : incrémental, UUID, hash — déterminant pour les tests d'IDOR>

## Pistes à creuser

- [ ]
- [ ]

## Écarté (et pourquoi)

- <endpoint> : <raison — évite de le retester dans un mois>
