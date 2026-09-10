# 01 — Méthodologie

Une méthodologie sert à **ne pas oublier** et à **savoir où tu en es**, pas à réciter des outils.
Le schéma est toujours le même : élargir la surface, puis choisir, puis creuser.

```
Cadrage → Recon passive → Recon active → Cartographie → Sélection → Exploitation → Preuve → Rapport
```

## 1. Cadrage

Lire la policy, remplir `scope/`, comprendre **le métier** : que vend cette entreprise ?
Qu'est-ce qui vaut de l'argent pour elle ? C'est là que sont les vulnérabilités à fort impact.

## 2. Recon passive (aucun paquet vers la cible)

Sources : certificats (crt.sh), archives (wayback), moteurs (Google dorks, Shodan, FOFA),
dépôts publics (GitHub, GitLab), fuites de credentials, DNS historique.

Objectif : sous-domaines, technologies, anciens endpoints, secrets fuités, employés.

```bash
./scripts/recon-passive.sh exemple.com
```

## 3. Recon active (on parle à la cible — le scope doit être validé)

Résolution DNS, ports ouverts, sondage HTTP, fingerprinting, screenshots,
découverte de contenu (fuzzing de répertoires) **au débit autorisé**.

## 4. Cartographie

Pour chaque hôte vivant, remplir une fiche `templates/fiche-cible.md` :
technologies, authentification, rôles, points d'entrée, flux d'argent, uploads, API.

## 5. Sélection — l'étape que tout le monde saute

Tu ne peux pas tout tester. Classe par **probabilité de faille × impact** :

- Applications récentes, en beta, rachetées, ou visiblement « oubliées ».
- Fonctionnalités avec plusieurs rôles / plusieurs tenants → contrôle d'accès.
- Tout ce qui manipule de l'argent, des fichiers, des identités.
- Endpoints non listés dans la doc publique.

## 6. Exploitation

Suivre [02-checklist-web.md](02-checklist-web.md) et [03-checklist-api.md](03-checklist-api.md).
Une hypothèse à la fois. Note ce qui **ne marche pas** aussi : ça évite de refaire le test dans deux semaines.

## 7. Preuve

- Requête et réponse HTTP complètes (caviardées).
- Screenshot horodaté.
- Étapes de reproduction rejouables **par quelqu'un d'autre**.
- PoC minimal, jamais destructif.

## 8. Rapport

`templates/rapport-vulnerabilite.md` → `findings/1-brouillon/`.
Relecture croisée par un camarade avant soumission : si la personne ne reproduit pas, le triage non plus.

---

## Boucle quotidienne conseillée

| Temps | Activité |
|---|---|
| 20 % | Recon (nouveaux actifs, veille sur le programme) |
| 60 % | Test manuel ciblé sur 1 ou 2 fonctionnalités |
| 20 % | Notes, preuves, rédaction |

Un bug rapporté proprement vaut mieux que dix pistes non écrites.
