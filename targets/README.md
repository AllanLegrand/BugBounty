# Cibles

Un dossier par hôte ou par application. Créé automatiquement :

```bash
./scripts/init-target.sh app.exemple.com
```

Structure d'une cible :

```
targets/app.exemple.com/
├── fiche.md          Technologies, comptes de test, surface d'attaque
├── checklist-web.md  Copie de docs/02-checklist-web.md, cochée au fil de l'eau
├── journal.md        Une entrée par session de test
├── recon/            Sorties d'outils (les gros fichiers sont gitignorés)
├── notes/            Analyses, hypothèses, bouts de payload
└── evidences/        Screenshots et captures — caviardés uniquement
```

`_exemple/` sert de modèle de référence : ne le supprime pas, duplique-le.
