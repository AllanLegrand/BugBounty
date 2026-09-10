# 07 — Guide étudiant : fork, clone, rendu

Ce dépôt est le **modèle commun**. Tu ne travailles jamais directement dessus :
tu en fais un **fork** (ta copie personnelle), tu travailles dans ce fork, et
c'est lui que le formateur consulte.

```
Dépôt de référence (Karlblock/BugBounty)
        │  fork
        ▼
Ton fork (TON-COMPTE/BugBounty)  ←── le formateur regarde ici
        │  clone
        ▼
Ta machine (tu travailles ici, tu push vers ton fork)
```

## 1. Forker (une seule fois)

1. Va sur https://github.com/Karlblock/BugBounty
2. Clique sur **Fork** (en haut à droite) → **Create fork**.
3. Tu obtiens `https://github.com/TON-COMPTE/BugBounty`.

## 2. Cloner ton fork

```bash
git clone https://github.com/TON-COMPTE/BugBounty.git
cd BugBounty
cp .env.example .env          # tes clés ; .env n'est jamais commité
```

## 3. Lier le dépôt de référence (pour recevoir les mises à jour)

```bash
git remote add upstream https://github.com/Karlblock/BugBounty.git
git remote -v
# origin   = ton fork (là où tu push)
# upstream = le modèle du formateur (lecture seule)
```

## 4. Travailler et rendre

```bash
./scripts/init-target.sh app.exemple.com   # créer une cible
# ... tu testes, tu remplis fiche / notes / evidences / findings ...

git add -A
git commit -m "recon app.exemple.com + fiche complétée"
git push origin main
```

Chaque `git push origin main` met ton fork à jour : **c'est ta façon de rendre**.
Push régulièrement, pas seulement à la fin.

## 5. Récupérer les mises à jour du modèle

Quand le formateur améliore les checklists ou les scripts :

```bash
git fetch upstream
git merge upstream/main        # ou : git rebase upstream/main
```

## Ce que le formateur regarde

Selon la consigne donnée en cours, l'une des deux méthodes :

- **Il consulte ton fork directement** : garde-le à jour avec `git push origin main`.
  Rien d'autre à faire.
- **Tu ouvres une Pull Request** vers le dépôt de référence pour « rendre » un
  livrable : sur la page de ton fork → **Contribute → Open pull request**.
  La PR permet au formateur de commenter ton travail ligne par ligne.
  (Ne fais ça que si la consigne le demande.)

## Règles de rendu

- Ton fork est **public** (comme le modèle) : n'y mets **que des cibles de labo /
  autorisées pour le cours**, jamais de vraies données ni de vrais secrets.
- Respecte `.gitignore` : pas de `.env`, pas de dumps, pas de PII, pas de tokens.
- Commits fréquents, messages clairs en français.
- Ton nom / pseudo dans `templates/suivi-rapports.md`.
