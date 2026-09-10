# Fiche cible — app.exemple.com   (EXEMPLE — dossier de référence, ne pas tester)

- **Programme** : Exemple SA — https://exemple.com/.well-known/security.txt
- **Dans le périmètre** : oui (vérifié le 2026-09-10)
- **Débit autorisé** : 5 req/s
- **En-tête d'identification exigé** : `X-Bug-Bounty: mon-pseudo`

## Technologies

| Couche | Détail |
|---|---|
| Serveur | nginx |
| Framework | Django 4.2 |
| CDN / WAF | Cloudflare |
| Auth | JWT (Bearer), refresh en cookie HttpOnly |
| API | REST `/api/v1`, GraphQL `/graphql` |

## Comptes de test

| Rôle | Identifiant | Notes |
|---|---|---|
| Utilisateur A (attaquant) | a+test@monmail.dev | org id 1042 |
| Utilisateur B (victime) | b+test@monmail.dev | org id 1043 |
| Admin | — | non fourni |

## Surface d'attaque

| Fonctionnalité | Intérêt | Testée | Notes |
|---|---|---|---|
| Inscription / login | moyen | ☑ | rate limit OK sur /login |
| Reset mot de passe | élevé | ☑ | token à usage unique, expire à 15 min — RAS |
| Profil / upload avatar | élevé | ☐ | SVG accepté → tester XSS stockée |
| Paiement / facturation | élevé | ☐ | ids de factures incrémentaux → tester IDOR |
| Partage / permissions | élevé | ☐ | invitations multi-org |
| Export CSV | moyen | ☐ | déclenchable en boucle ? |

## Identifiants d'objets observés

- Factures : `/api/v1/invoices/8830` → **incrémental** (piste IDOR prioritaire)
- Utilisateurs : UUID v4 (non devinable)

## Pistes à creuser

- [ ] IDOR sur `/api/v1/invoices/{id}` entre org 1042 et 1043
- [ ] XSS stockée via upload d'avatar SVG
- [ ] Introspection GraphQL en production

## Écarté (et pourquoi)

- Reset de mot de passe : token robuste, testé le 2026-09-10, inutile d'y revenir.
