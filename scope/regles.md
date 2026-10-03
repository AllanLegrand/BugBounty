# Règles du programme — BlaBlaCar

- **Plateforme** : YesWeHack
- **URL de la policy** : https://yeswehack.com/programs/bug-bounty-program-blablacar
- **Safe harbor** : oui — standard YesWeHack
- **Débit maximum** : Non spécifié (interdiction de générer de gros volumes de trafic)
- **En-tête d'identification exigé** : `User-Agent: BBC-YWH-Bugbounty-<ton-pseudo>`
- **Scanners automatisés** : interdits — (Acunetix, Vega, etc.)

## Techniques interdites

- [X] DoS / stress test
- [X] Brute force
- [X] Social engineering / phishing
- [X] Spam (SMS, e-mail)
- [X] Tests sur des comptes tiers
- [X] Autre : Fuite ou destruction de données, rapports liés à la fraude sans vulnérabilité.

## Vulnérabilités hors récompense (known issues)

- Scanners automatiques non vérifiés.
- 0-day récemment divulgués.
- Tabnabbing.
- Self-XSS ou XSS non exploitable contre d'autres utilisateurs.
- CSRF de faible sévérité (Logout, non authentifié).
- XSS "HTTP Host Header".
- Drapeaux de cookies ou en-têtes HTTP de sécurité manquants.
- Mixed content warnings / Clickjacking / UI redressing.
- Déni de service (DoS).
- Problèmes SSL/TLS et enregistrements email manquants (SPF, DKIM, DMARC).
- Fuite de token de reset de mot de passe via l'en-tête Referer.
- Présence de l'attribut autocomplete.
- SSRF en aveugle sans PoC démontrable.
- Divulgation d'informations (stack traces, versions, IP, métadonnées EXIF).
- Problèmes de gestion de session (absence d'expiration).
- Mots de passe faibles et Pre-account takeover.
- Vulnérabilités sur des dépôts Github archivés.
- Applications mobiles : problèmes nécessitant un appareil rooté/jailbreaké, manque d'obfuscation.
- Contournement de la modération des messages.
- Clés API publiques (Google Maps, Firebase).

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
