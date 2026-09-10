# 05 — Noter la sévérité

## CVSS v3.1 — les 8 métriques de base

| Métrique | Valeurs | Question à se poser |
|---|---|---|
| **AV** Attack Vector | N / A / L / P | Exploitable depuis Internet ? |
| **AC** Attack Complexity | L / H | Faut-il une condition particulière (race, config rare) ? |
| **PR** Privileges Required | N / L / H | Faut-il un compte ? Un compte admin ? |
| **UI** User Interaction | N / R | Faut-il qu'une victime clique ? |
| **S** Scope | U / C | La faille sort-elle du composant vulnérable ? |
| **C/I/A** | N / L / H | Confidentialité, intégrité, disponibilité |

Calculateur officiel : https://www.first.org/cvss/calculator/3.1

## Repères par sévérité

| Niveau | CVSS | Exemples typiques |
|---|---|---|
| **Critique** | 9.0–10 | RCE, SQLi authentifiante, contournement d'auth total, fuite massive de PII |
| **Élevé** | 7.0–8.9 | IDOR sur données sensibles, SSRF vers métadonnées cloud, XSS stockée authentifiée, prise de contrôle de compte avec interaction |
| **Moyen** | 4.0–6.9 | XSS réfléchie, CSRF sur action sensible, subdomain takeover sans usage, fuite d'infos exploitable |
| **Faible** | 0.1–3.9 | Absence d'en-tête de sécurité avec impact démontré, open redirect isolé, énumération d'utilisateurs |
| **Info** | 0 | Bonnes pratiques, version divulguée sans exploit |

## Erreurs fréquentes des débutants

- **Surcoter systématiquement.** Un triageur qui doit revoir ta note à la baisse trois fois de suite
  lit tes rapports suivants avec moins d'attention.
- **Confondre sévérité technique et impact métier.** Une XSS sur une page marketing statique
  n'a pas la sévérité d'une XSS dans l'espace client.
- **Oublier les prérequis.** « Nécessite un compte admin » fait chuter la note — et souvent
  la recevabilité.
- **Rapporter un élément de la liste d'exclusions.** Relis toujours la section
  *out of scope / known issues* du programme avant de soumettre.

## Formuler l'impact

Une phrase, en langage métier, qui répond à : **qui** peut faire **quoi** à **qui** ?

> « Un utilisateur authentifié quelconque peut lire et modifier les factures de n'importe quel
> autre client en changeant un identifiant numérique dans l'URL. »

C'est cette phrase qui détermine la prime, pas la liste des payloads.
