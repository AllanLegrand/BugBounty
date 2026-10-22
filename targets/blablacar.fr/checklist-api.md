# 03 — Checklist API (REST / GraphQL)

Alignée sur l'OWASP API Security Top 10.

## Découverte
- [ ] Documentation : `/swagger.json`, `/openapi.json`, `/api-docs`, `/graphql` (introspection)
- [ ] Versions parallèles : `/v1/`, `/v2/`, `/internal/`, `/beta/` — souvent moins protégées
- [ ] Endpoints extraits des bundles JS et des applications mobiles
- [ ] Différences entre l'API web et l'API mobile

## API1 — Autorisation au niveau objet (BOLA / IDOR)
- [ ] Remplacer chaque identifiant par celui d'un autre compte
- [ ] Identifiants devinables (incrémentaux, UUID v1, hash faible)
- [ ] Objets imbriqués : `/orgs/{a}/projets/{b}` — les deux niveaux sont-ils vérifiés ?

## API2 — Authentification
- [ ] Endpoints accessibles sans token
- [ ] Token expiré / révoqué toujours accepté
- [ ] Absence de rate limit sur `/login`, `/otp`, `/refresh`
- [ ] Clés d'API dans l'URL (fuite dans les logs et le Referer)

## API3 — Autorisation au niveau propriété
- [ ] Mass assignment : ajouter `"role":"admin"`, `"isVerified":true`, `"balance":9999`
- [ ] Sur-exposition : la réponse contient plus de champs que l'UI n'en affiche
       (hash de mot de passe, e-mail, tokens internes, PII)

## API4 — Consommation de ressources
- [ ] Pagination sans limite (`?limit=1000000`)
- [ ] GraphQL : requêtes imbriquées profondes, aliasing en masse, batching
- [ ] Exports / rapports coûteux déclenchables en boucle

## API5 — Autorisation au niveau fonction
- [ ] Fonctions admin appelées avec un token utilisateur
- [ ] Méthodes non documentées acceptées (`PUT`, `DELETE`, `PATCH`)

## API6 — Flux métier sensibles
- [ ] Automatisation d'un flux censé rester manuel (achat, réservation, vote)

## API7 — SSRF
- [ ] Tout champ acceptant une URL : webhook, avatar, import, callback

## API8 — Mauvaise configuration
- [ ] CORS, verbes HTTP autorisés, en-têtes de debug (`X-Powered-By`, traces)
- [ ] Messages d'erreur exposant la stack ou les requêtes SQL

## API9 — Inventaire
- [ ] Anciennes versions toujours en ligne
- [ ] Hôtes d'API en staging accessibles publiquement

## API10 — Consommation d'API tierces
- [ ] Données d'un service tiers reprises sans validation

## GraphQL spécifique
- [ ] Introspection activée en production
- [ ] Mutations sensibles sans contrôle d'accès
- [ ] Contournement de rate limit par batching (tableau de requêtes)
- [ ] Suggestions de champs activées (fuite du schéma même sans introspection)
