# Règles du programme — BlaBlaCar

- **Plateforme** : YesWeHack
- **URL de la policy** : https://yeswehack.com/programs/bug-bounty-program-blablacar
- **Safe harbor** : oui — standard YesWeHack
- **Débit maximum** : Non spécifié (interdiction de générer de gros volumes de trafic)
- **En-tête d'identification exigé** : `User-Agent: BBC-YWH-Bugbounty-<ton-pseudo>`
- **Scanners automatisés** : interdits — (Acunetix, Vega, etc. non validés)
- **Scope & exceptions** : Tout site non listé explicitement est hors scope. Exception : un bug hors scope ayant un impact majeur et accompagné d'un PoC convaincant menant à une modification du code.
- **Vulnérabilités éligibles** : SQLi, XSS, RCE, IDOR, Élévation de privilèges, Contournement/faille d'authentification, Erreurs de logique métier (avec impact), LFI/RFI/XXE/SSRF/XSPA, CORS (avec impact), CSRF (avec impact), Open Redirect, Secrets/identifiants exposés sur un actif contrôlé affectant un scope.
- **Fuites & identifiants (Leaks)** : Éligible uniquement si l'impact concerne un actif du scope OU si la source de la fuite provient du scope.

## Techniques interdites

- [X] DoS / stress test / crasher sa propre application
- [X] Brute force (ou exploitation de l'absence de rate-limiting / captcha)
- [X] Social engineering / phishing
- [X] Spam (flooding par SMS, e-mail ou messages directs)
- [X] Tests sur des comptes tiers, utilisation d'identifiants volés
- [X] Attaques nécessitant un accès physique à l'appareil de la victime ou un Man-in-the-Middle (MITM)
- [X] Autre : Fuite ou destruction de données, rapports liés à la fraude sans vulnérabilité technique (ex: contournement de règles métier).

## Vulnérabilités hors récompense (known issues)

- Rapports sans Proof-of-Concept (PoC) démontrant la vulnérabilité et l'impact.
- Problèmes purement théoriques sans exploit tangible ni vecteur d'attaque.
- Bonnes pratiques de sécurité sans impact réel.
- Scanners automatiques non vérifiés.
- 0-day récemment divulgués.
- CVEs, logiciels obsolètes ou ports/services ouverts sans vulnérabilité exploitable ni PoC.
- Tabnabbing.
- Self-XSS ou XSS non exploitable contre d'autres utilisateurs.
- CSRF de faible sévérité (Logout, non authentifié).
- XSS "HTTP Host Header".
- Content spoofing sans intégration de lien externe ou de JavaScript.
- Drapeaux de cookies manquants.
- En-têtes HTTP de sécurité manquants (ex: HSTS) ne menant pas directement à une vulnérabilité.
- Mixed content warnings / Clickjacking / UI redressing / Protocol mismatch.
- Problèmes SSL/TLS (certificats expirés, bonnes pratiques).
- Enregistrements de sécurité email manquants ou invalides (SPF, DKIM, DMARC).
- SSRF en aveugle sans PoC démontrable (ex: DNS & HTTP pingback, Wordpress XMLRPC).
- Divulgation d'informations sans vulnérabilité exploitable (stack traces, path disclosure, directory listings, versions, IP d'origine, métadonnées EXIF, secrets tiers).
- Fuite de token de reset de mot de passe via l'en-tête Referer (Google Analytics, Facebook…).
- Présence de l'attribut autocomplete sur les formulaires.
- Découverte de l'ID utilisateur au format numérique (entier) au lieu du format UUID4.
- Problèmes de gestion de session (absence d'expiration, sessions concurrentes, pas de déconnexion au changement de mot de passe).
- Politiques de mots de passe faibles (longueur, complexité, réutilisation).
- Pre-account takeover (ex: via OAuth).
- Validation d'email non obligatoire à l'inscription.
- Vulnérabilités sur des dépôts Github archivés.
- Contournement de la modération des messages.
- Clés API publiques ou mal configurées (Google Maps, Firebase, outils d'analytics...).
- Vulnérabilités affectant des navigateurs obsolètes (seules les dernières versions sont acceptées).
- Applications mobiles : problèmes nécessitant un appareil rooté/jailbreaké ou des backups (usage non standard).
- Applications mobiles : manque de protections binaires (obfuscation, SSL Pinning, anti-débogage, détection root).
- Applications mobiles : absence de chiffrement sur les bases de données internes ou fichiers de préférences.
- Applications mobiles : exploitation d'une vulnérabilité générique Android ou iOS.
- Applications mobiles : API client ID/Secret embarqué dans l'application (Web, Android, iOS).

## Récompenses

| Sévérité | Montant |
|---|---|
| Critique | €3,000 |
| Élevé | €1,000 |
| Moyen | €200 |
| Faible | €100 |

## Contact

- Sécurité : Via la plateforme YesWeHack
- Délai de réponse annoncé : Moins de 1 jour (< 1 day)