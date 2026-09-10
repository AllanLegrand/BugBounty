# 06 — Bien écrire un rapport

Le triageur passe **quelques minutes** sur ton rapport. S'il ne reproduit pas, il ferme.

## Les 7 sections obligatoires

1. **Titre** — `<type de vuln> sur <endpoint> permettant <impact>`
   ✅ « IDOR sur `/api/v1/invoices/{id}` permettant de lire les factures de tous les clients »
   ❌ « Grosse faille critique !! »
2. **Résumé** — 2 à 3 phrases, compréhensibles par un chef de produit non technique.
3. **Sévérité** — note CVSS + vecteur + justification en une ligne.
4. **Étapes de reproduction** — numérotées, exhaustives, depuis un navigateur vierge.
   Inclure : comptes de test utilisés, valeurs exactes, requêtes complètes.
5. **Preuve** — requête/réponse HTTP, screenshots, vidéo courte si le flux est complexe.
6. **Impact** — ce qu'un attaquant réel obtient, en termes métier.
7. **Remédiation** — une piste concrète et courte. Tu proposes, tu n'imposes pas.

## Règles de rédaction

- Écris pour quelqu'un qui **ne connaît pas** la faille.
- Un rapport = **une** vulnérabilité. Deux IDOR sur deux endpoints différents = deux rapports
  (sauf si la cause racine est unique — dis-le alors explicitement).
- Caviarde : tokens, cookies, e-mails réels, noms de clients.
- Pas d'exagération, pas de menace, pas de mention de la prime dans le rapport initial.
- Relis à voix haute : si tu butes, le triageur bute aussi.

## Test de relecture croisée

Avant de soumettre, un camarade doit pouvoir **reproduire la faille** en suivant uniquement ton
rapport, sans te poser de question. Sinon, le rapport n'est pas fini.

## Réponses aux retours

- Duplicate → note-le dans `findings/3-resolu/`, passe à autre chose, ne discute pas.
- Informative / N/A → demande poliment ce qui manque, ça t'apprend le standard du programme.
- Demande de complément → réponds vite, avec les éléments demandés uniquement.
