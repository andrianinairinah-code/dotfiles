---
tags: dev/ai dev/obsidian dev/debug dev/architecturetags: session-log fix config mcp opencode agent
---

# Session Log — 14 Juin 2026

## Problème initial
OpenCode freeze au démarrage — fenêtre noire, ne répond pas.

## Cause racine
**`opencode.jsonc` chargé APRÈS `opencode.json` et override ses valeurs.**
- `opencode.json` (gitignoré) contenait les vrais secrets MCP avec `enabled: false`
- `opencode.jsonc` (commité) contenait un template MCP avec `enabled: true` et valeurs bidon
- Résultat : OpenCode tentait de connecter Supabase/Obsidian MCP → timeout → freeze

### Correction
1. `opencode.jsonc` → ne contient plus que `$schema`, pas de section MCP
2. `opencode.json` → reste le seul fichier qui définit les serveurs MCP

## Fichiers renommés (npm)

### Problème
Les fichiers `opencode.ps1`, `opencode.cmd`, `opencode` dans `C:\Users\PLY\AppData\Roaming\npm\` avaient été renommés avec préfixe `.` et suffixe aléatoire (`.opencode.ps1-XXXXX`).

### Correction
1. `Rename-Item` pour restaurer les noms originaux
2. Vérifier que `C:\Users\PLY\AppData\Roaming\npm\node_modules\opencode-ai\bin\opencode.exe` est un vrai binaire (8+ MB), pas un placeholder de 479 octets
3. Si placeholder → copier depuis `node_modules\opencode-windows-x64\bin\opencode.exe`

### Versions
- CLI installé : `opencode-ai@1.15.13` (marche), `1.17.6` (binaire incompatible avec Win10 22H2)
- Desktop : `1.17.6` (marche)

## Junctions Windows

```
C:\Users\PLY\.config\opencode  ──junction──►  D:\dotfiles\opencode-config
C:\Users\PLY\.agents           ──junction──►  D:\dotfiles\agents
```

Toute modification dans `D:\dotfiles\opencode-config\` est automatiquement visible via `C:\Users\PLY\.config\opencode\`.

## MCP Obsidian

### Connexion HTTPS (échoué)
- Obsidian Local REST API (v4.1.3) sert sur `https://127.0.0.1:27124/mcp/`
- Certificat auto-signé → OpenCode refuse la connexion ("self signed certificate")
- Tentative d'installer le cert : besoin admin + échec `CRYPT_E_NO_MATCH`

### Solution retenue : Port HTTP
1. Activer `enableInsecureServer: true` dans `.obsidian/plugins/local-rest-api/data.json`
2. Changer URL MCP vers `http://127.0.0.1:27123/mcp/`
3. Redémarrer Obsidian pour prise en compte

### Résultat
```
opencode mcp list
  ○ supabase  → disabled
  ✓ obsidian  → connected
```

### ACLs MCP Obsidian
Le fichier `.obsidian/plugins/local-rest-api/acls.json` contrôle les permissions par adresse IP. Si la connexion MCP est refusée, vérifier que `127.0.0.1` est autorisé.

## Agents & Skills

### Création
- `D:\dotfiles\AGENTS.md` — point d'entrée documentant les 8 agents et 39 skills
- `D:\admin\AGENTS.md` — référence vers le système dotfiles

### Structure
```
D:\dotfiles\agents\
├── ROUTER.md       ← mapping intent → skill (scoring 1-4)
├── agents/          ← 8 agents (.md)
└── skills/          ← 39 skills
```

## Commande utiles

| Commande | Usage |
|----------|-------|
| `opencode debug startup` | Mesure le temps de démarrage |
| `opencode debug config` | Voir la config résolue |
| `opencode debug skill` | Lister toutes les skills chargées |
| `opencode agent list` | Lister les agents disponibles |
| `opencode mcp list` | Voir le statut des MCP |
| `opencode --pure debug startup` | Démarrer sans plugins (debug) |
| `opencode serve --port 3001` | Serveur headless |
| `opencode web D:\dotfiles` | Interface web |

## Scripts PowerShell

Tous dans `D:\dotfiles\scripts\` :
- `knowledge-startup.ps1` — auto au login, log session, auto-fix ROUTER
- `knowledge-watch.ps1` — veille multi-source (GitHub, HuggingFace, Reddit, etc.)
- `git-watch.ps1` — commit/push auto sur détection de changements
- `obsidian-sync-back.ps1` — détecte nouvelles notes Obsidian
- `obsidian-tagger.ps1` — tagge auto les notes selon contenu
- `analytics-collect.ps1` — tracke usage des skills, archive inutilisées
- `github-issues.ps1` — surveille issues GitHub de 4 repos
- `install-*.ps1` — installe les tâches planifiées Windows

## Pour éviter le freeze au prochain démarrage

1. Ne PAS mettre de serveurs MCP `enabled: true` dans `opencode.jsonc`
2. Si freeze : lancer `opencode --pure debug config` pour voir la config résolue
3. Vérifier que `opencode --version` retourne un numéro de version (sinon binaire corrompu)
4. Les fichiers `opencode.*` dans `C:\Users\PLY\AppData\Roaming\npm\` ne doivent PAS être renommés

