# Findings

Cycle de vie d'une vulnérabilité. On **déplace** le fichier de dossier en dossier
(`git mv`), on n'en crée pas de copie.

```
1-brouillon/   Rédaction en cours, reproduction à confirmer, relecture croisée
2-soumis/      Déposé sur la plateforme, en attente de triage ou de correction
3-resolu/      Terminé : accepté et corrigé, dupliqué, informatif ou rejeté
```

## Nommage

`AAAA-MM-JJ_<cible>_<type-de-vuln>.md`

```
2026-09-10_api.exemple.com_idor-facturation.md
2026-09-12_www.exemple.com_xss-stockee-profil.md
```

## Avant de passer en `2-soumis/`

- [ ] Reproduit deux fois depuis une session vierge
- [ ] Relu par un camarade qui a réussi à reproduire
- [ ] Preuves caviardées (tokens, PII, noms de clients)
- [ ] Vérifié hors de la liste *known issues* du programme
- [ ] Sévérité justifiée par un vecteur CVSS

## En passant en `3-resolu/`

Renseigner dans le front-matter : `statut`, la date, la prime éventuelle,
et **une ligne de leçon apprise**. Reporter la ligne dans `templates/suivi-rapports.md`.
