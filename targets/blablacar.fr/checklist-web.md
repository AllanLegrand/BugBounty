# 02 — Checklist web

À dupliquer par cible : `cp docs/02-checklist-web.md targets/<cible>/checklist-web.md`
Coche au fur et à mesure. Une case non cochée = zone non testée, pas zone saine.

## Reconnaissance applicative
- [ ] Technologies identifiées (serveur, framework, CDN, WAF)
- [ ] Fichiers JS téléchargés et lus (endpoints, clés, feature flags, commentaires)
- [ ] `robots.txt`, `sitemap.xml`, `.well-known/`, `/swagger`, `/graphql`, `/actuator`
- [ ] Sous-domaines et environnements annexes (dev, staging, preprod, uat)
- [ ] Répertoires exposés : `.git/`, `.env`, `backup/`, `.DS_Store`, dumps SQL
- [ ] Messages d'erreur verbeux, stack traces, pages de debug

## Authentification
- [ ] Énumération d'utilisateurs (messages ou temps de réponse différents)
- [ ] Politique de mot de passe, verrouillage, rate limiting sur le login
- [ ] Reset de mot de passe : token prévisible, non expiré, réutilisable, fuite via Referer/Host header
- [ ] MFA : contournable, code brute-forçable, non exigé sur certains flux
- [ ] OAuth / SSO : `redirect_uri` laxiste, `state` absent, fuite de code, account linking abusif
- [ ] JWT : `alg: none`, HS/RS confusion, signature non vérifiée, clé faible, absence d'expiration

## Session
- [ ] Attributs des cookies (`HttpOnly`, `Secure`, `SameSite`)
- [ ] Session non invalidée à la déconnexion / au changement de mot de passe
- [ ] Session fixation
- [ ] Plusieurs sessions concurrentes non révoquées

## Contrôle d'accès — le plus rentable
- [ ] IDOR : remplacer un identifiant par celui d'un autre compte (créer 2 comptes de test)
- [ ] Élévation verticale : appeler un endpoint admin avec un compte utilisateur
- [ ] Élévation horizontale entre tenants / organisations
- [ ] Contrôle uniquement côté client (bouton caché mais endpoint ouvert)
- [ ] Changement de méthode HTTP (`GET`→`POST`, `PUT`, `PATCH`, `DELETE`)
- [ ] Contournement de chemin : `//admin`, `/admin/.`, `%2e%2e`, casse, encodage

## Injections
- [ ] SQL / NoSQL (paramètres, en-têtes, JSON, ordre de tri, filtres)
- [ ] Injection de commandes OS
- [ ] Injection de template côté serveur (SSTI)
- [ ] LDAP, XPath, injection d'en-têtes / CRLF
- [ ] Désérialisation non sécurisée

## XSS et injections côté client
- [ ] Réfléchie, stockée, DOM-based (`innerHTML`, `location.hash`, `postMessage`)
- [ ] Contournement de la CSP / absence de CSP
- [ ] Upload de fichier rendu en HTML ou SVG
- [ ] `target=_blank` sans `noopener`, open redirect chaînable

## Logique métier
- [ ] Manipulation du prix, de la quantité, de la devise, d'une remise
- [ ] Étapes d'un tunnel sautées ou rejouées
- [ ] Valeurs négatives, très grandes, décimales, unicode
- [ ] Race conditions (double dépense, double usage d'un coupon)
- [ ] Absence de rate limit sur une action coûteuse (SMS, e-mail, export)

## Côté serveur
- [ ] SSRF (webhooks, import d'URL, génération de PDF, prévisualisation de lien)
- [ ] Inclusion / traversée de fichiers
- [ ] XXE (XML, DOCX, SVG, SOAP)
- [ ] Upload : type, extension double, magic bytes, chemin d'écriture, exécution
- [ ] Request smuggling, empoisonnement de cache, cache d'en-têtes

## Configuration
- [ ] CORS permissif (`Access-Control-Allow-Origin` reflété + `credentials: true`)
- [ ] En-têtes de sécurité (HSTS, `X-Content-Type-Options`, `Content-Security-Policy`)
- [ ] Prise de contrôle de sous-domaine (CNAME orphelin)
- [ ] Identifiants par défaut sur les interfaces d'admin
- [ ] Versions vulnérables connues (CVE) confirmées **manuellement**

## Avant de rapporter
- [ ] Reproduit deux fois, depuis une session propre
- [ ] Impact métier formulé en une phrase
- [ ] Preuves caviardées et horodatées
- [ ] Vérifié hors de la liste des vulnérabilités exclues du programme
