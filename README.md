# Template Bug Bounty

Dépôt de travail standardisé pour les programmes de bug bounty.
Chaque étudiant **clone ce template**, l'utilise comme espace de travail pour ses cibles,
sa recon, ses notes et ses rapports.

> ⚠️ **Avant toute chose** : lis [docs/00-regles-engagement.md](docs/00-regles-engagement.md).
> Tester une cible hors périmètre est illégal. Aucune exception.

---

## 1. Démarrer

### Option A — via GitHub (recommandé)

1. Clique sur **« Use this template » → « Create a new repository »**.
2. Nomme ton dépôt `bugbounty-<ton-nom>` et mets-le en **privé**.
3. Clone-le :

```bash
git clone git@github.com:<toi>/bugbounty-<ton-nom>.git
cd bugbounty-<ton-nom>
```

### Option B — clone direct

```bash
git clone <url-du-template> mon-bugbounty
cd mon-bugbounty
rm -rf .git && git init      # repartir d'un historique vierge
```

### Initialisation

```bash
cp .env.example .env         # tes clés d'API (jamais commitées)
./scripts/init-target.sh exemple.com
```

---

## 2. Arborescence

```
.
├── docs/                 Méthodologie, checklists, règles d'engagement
├── templates/            Modèles à copier (rapport, journal, fiche cible)
├── scope/                Périmètre machine-lisible (in / out of scope)
├── scripts/              Outils maison (init cible, recon passive, contrôle de scope)
├── targets/              Un dossier par cible : recon, notes, evidences
│   └── _exemple/
└── findings/             Cycle de vie des vulnérabilités trouvées
    ├── 1-brouillon/      En cours de rédaction / de validation
    ├── 2-soumis/         Envoyé à la plateforme, en attente de triage
    └── 3-resolu/         Corrigé, payé, ou rejeté (avec le motif)
```

## 3. Cycle de travail

| Étape | Action | Où |
|---|---|---|
| 1. Cadrer | Remplir le périmètre du programme | `scope/in-scope.txt`, `scope/out-of-scope.txt` |
| 2. Reconnaître | Énumération passive puis active | `targets/<cible>/recon/` |
| 3. Analyser | Choisir les surfaces d'attaque intéressantes | `targets/<cible>/notes/` |
| 4. Tester | Suivre les checklists, tout tracer | [docs/02-checklist-web.md](docs/02-checklist-web.md) |
| 5. Prouver | Capturer requête/réponse, screenshots, PoC minimal | `targets/<cible>/evidences/` |
| 6. Rapporter | Copier le modèle, rédiger, faire relire | `templates/rapport-vulnerabilite.md` → `findings/1-brouillon/` |
| 7. Soumettre | Déposer sur la plateforme, déplacer le fichier | `findings/2-soumis/` |
| 8. Suivre | Noter la décision et le montant | `findings/3-resolu/` |

Nommage des rapports : `AAAA-MM-JJ_<cible>_<type-de-vuln>.md`
Exemple : `2026-09-10_api.exemple.com_idor-facturation.md`

## 4. Commandes utiles

```bash
./scripts/init-target.sh app.exemple.com   # crée l'arborescence d'une cible
./scripts/check-scope.sh app.exemple.com   # vérifie qu'un hôte est dans le périmètre
./scripts/recon-passive.sh exemple.com     # recon 100 % passive (aucun paquet vers la cible)
```

## 5. Règles du dépôt

- **Jamais** de secrets, tokens, cookies de session ou données personnelles réelles dans un commit — voir `.gitignore`.
- **Jamais** de dump de données client. Une preuve = le strict minimum nécessaire à la démonstration.
- Un commit par avancée significative, message explicite en français.
- Le dépôt reste **privé** jusqu'à ce que le programme autorise la divulgation.

## 6. Documentation

- [00 — Règles d'engagement et cadre légal](docs/00-regles-engagement.md)
- [01 — Méthodologie](docs/01-methodologie.md)
- [02 — Checklist web](docs/02-checklist-web.md)
- [03 — Checklist API](docs/03-checklist-api.md)
- [04 — Outils](docs/04-outils.md)
- [05 — Notation de la sévérité (CVSS)](docs/05-severite.md)
- [06 — Bien écrire un rapport](docs/06-ecrire-un-rapport.md)
