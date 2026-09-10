---
titre: "<Type de vuln> sur <endpoint> permettant <impact>"
programme: "<nom du programme>"
plateforme: "<HackerOne | YesWeHack | Intigriti | Bugcrowd | direct>"
cible: "<host ou URL>"
date_decouverte: "AAAA-MM-JJ"
severite: "<Critique | Élevé | Moyen | Faible | Info>"
cvss: "<score>"
cvss_vecteur: "CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:N/A:N"
cwe: "CWE-___"
statut: "<brouillon | soumis | triage | accepté | dupliqué | rejeté | corrigé>"
auteur: "<pseudo>"
---

# <Titre du rapport>

## Résumé

<2 à 3 phrases. Quoi, où, qui peut l'exploiter, quelle conséquence. Sans jargon.>

## Sévérité

**<Niveau>** — CVSS 3.1 : `<score>` (`<vecteur>`)

Justification : <une ligne : pourquoi ce vecteur et pas un autre>

## Composant affecté

- URL / endpoint : `<https://...>`
- Paramètre : `<nom>`
- Méthode : `<GET | POST | ...>`
- Authentification requise : `<non | utilisateur | admin>`

## Prérequis

- Comptes de test utilisés :
  - Victime : `<identifiant>` (id `<...>`)
  - Attaquant : `<identifiant>` (id `<...>`)
- Outils : <navigateur, Burp, curl>

## Étapes de reproduction

1. <Action précise>
2. <Action précise>
3. <Observation : ce qui prouve la faille>

### Requête

```http
GET /api/v1/... HTTP/1.1
Host: <cible>
Authorization: Bearer <REDACTED>
```

### Réponse

```http
HTTP/1.1 200 OK
Content-Type: application/json

{ "...": "<extrait caviardé montrant la donnée d'un autre utilisateur>" }
```

## Preuve

| Fichier | Description |
|---|---|
| `evidences/01-requete.png` | <ce qu'on y voit> |
| `evidences/02-reponse.png` | <ce qu'on y voit> |

## Impact

<Qui peut faire quoi à qui, en langage métier. Quantifier si possible : nombre d'enregistrements,
type de données, conséquence réglementaire ou financière.>

## Remédiation proposée

<1 à 3 phrases, concrètes.>

## Références

- CWE-___ : <https://cwe.mitre.org/data/definitions/___.html>
- OWASP : <lien>

## Journal

| Date | Événement |
|---|---|
| AAAA-MM-JJ | Découverte |
| AAAA-MM-JJ | Soumission |
| AAAA-MM-JJ | Réponse du programme : <...> |
