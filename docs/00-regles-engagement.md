# 00 — Règles d'engagement et cadre légal

## La règle unique

**Tu ne testes que ce qui est explicitement autorisé, dans les limites explicitement fixées.**
En dehors de ça, tu commets une infraction pénale, même sans intention de nuire, même sans dégât.

En France : articles **323-1 à 323-7 du Code pénal** (accès et maintien frauduleux dans un
système de traitement automatisé de données, entrave, modification de données).
Un programme de bug bounty est l'autorisation qui te protège — **son périmètre est ta seule protection**.

## Avant de lancer la moindre commande

- [X] J'ai lu **la page du programme en entier** (policy, scope, rules).
- [X] J'ai recopié le périmètre dans `scope/in-scope.txt` et `scope/out-of-scope.txt`.
- [ ] J'ai noté les **techniques interdites** (souvent : DoS, brute force, social engineering, spam, scanners automatisés bruyants).
- [ ] J'ai noté le **débit autorisé** (requêtes/seconde) et je m'y tiens.
- [ ] J'ai créé mes **propres comptes de test** — je ne touche jamais au compte d'un tiers.
- [ ] J'ai configuré l'**en-tête d'identification** exigé par le programme, s'il y en a un
      (ex. `X-Bug-Bounty: <mon-pseudo>` ou un User-Agent dédié).

## Interdits permanents, même « dans le scope »

| Interdit | Pourquoi |
|---|---|
| Déni de service, stress test, flood | Impacte des utilisateurs réels |
| Exfiltrer des données réelles | Violation RGPD, préjudice direct |
| Pivoter vers d'autres systèmes | Sort du périmètre autorisé |
| Modifier / supprimer des données | Destruction de preuve et de service |
| Maintenir un accès (backdoor, persistance) | Aggravation pénale |
| Social engineering, phishing d'employés | Vise des personnes, pas des systèmes |
| Tester un sous-domaine « probablement » inclus | Le doute vaut hors périmètre |

## Pendant le test

- **Preuve minimale suffisante** : si une IDOR expose 10 000 dossiers, tu en montres **un seul**, le tien
  ou un enregistrement de test — puis tu t'arrêtes.
- Si tu tombes sur des **données personnelles réelles** : arrête-toi, ne télécharge rien,
  ne fais pas de capture d'écran non caviardée, signale-le immédiatement dans le rapport.
- Si tu obtiens un **accès plus profond que prévu** (RCE, admin, base de données) : arrête-toi.
  Tu n'as pas besoin d'aller plus loin pour prouver l'impact. Documente et rapporte.
- **Journalise tout** : date, heure, cible, requête. En cas de contestation, ton journal te défend
  (`targets/<cible>/notes/journal.md`).

## Divulgation

- Aucune publication (blog, X/Twitter, LinkedIn, write-up, dépôt public) **avant** l'accord écrit du programme.
- Ce dépôt reste **privé**. Une fois l'autorisation obtenue, on caviarde puis on publie.

## En cas de problème

Tu as fait une erreur (test hors scope, indisponibilité provoquée, donnée téléchargée) :

1. **Arrête immédiatement.**
2. Préviens le formateur / le responsable du programme **tout de suite**, sans attendre.
3. Ne supprime rien : ni logs, ni fichiers, ni historique.

Signaler une erreur rapidement est presque toujours sans conséquence. La dissimuler ne l'est jamais.
