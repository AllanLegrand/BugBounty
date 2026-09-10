# 04 — Outils

Tableau de référence. **Aucun outil ne remplace la compréhension de l'application.**
Installe au fur et à mesure de tes besoins, pas tout d'un coup.

## Proxy / interception — le cœur du métier

| Outil | Usage |
|---|---|
| Burp Suite (Community) | Proxy, Repeater, Intruder (bridé), Decoder |
| Caido | Alternative moderne, plus légère |
| mitmproxy | Interception en ligne de commande / scriptable Python |

## Recon passive

| Outil | Usage |
|---|---|
| `subfinder` | Sous-domaines via sources passives |
| `amass intel` / `amass enum -passive` | Corrélation d'actifs |
| `crt.sh` (web/API) | Certificats → sous-domaines |
| `waybackurls`, `gau` | URLs historiques |
| `github-search`, `trufflehog` | Secrets dans les dépôts publics |
| Shodan, Censys, FOFA | Services exposés |

## Recon active

| Outil | Usage |
|---|---|
| `dnsx` | Résolution en masse |
| `httpx` | Sondage HTTP, titres, techno, status |
| `naabu` / `nmap` | Ports (attention au débit autorisé) |
| `katana` / `hakrawler` | Crawl |
| `ffuf` / `feroxbuster` | Découverte de contenu |
| `nuclei` | Templates de vulns connues — **vérifier que le programme l'autorise** |
| `gowitness` / `aquatone` | Screenshots en masse |

## Analyse

| Outil | Usage |
|---|---|
| `jwt_tool` | Analyse et attaques JWT |
| `sqlmap` | SQLi — jamais en aveugle sur une cible de prod sans accord |
| `dalfox` | XSS |
| DevTools navigateur | Sources JS, requêtes, storage — sous-estimé, très rentable |

## Installation rapide (Go)

```bash
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
go install -v github.com/projectdiscovery/dnsx/cmd/dnsx@latest
go install -v github.com/projectdiscovery/katana/cmd/katana@latest
go install -v github.com/ffuf/ffuf/v2@latest
export PATH="$PATH:$(go env GOPATH)/bin"
```

## Listes de mots

- SecLists : https://github.com/danielmiessler/SecLists
- Assetnote wordlists : https://wordlists.assetnote.io

## Clés d'API

Elles vont dans `.env` (voir `.env.example`), **jamais** dans un fichier commité.
