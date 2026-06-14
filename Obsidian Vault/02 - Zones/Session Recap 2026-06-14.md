---
tags: dev/ai dev/obsidian dev/debug dev/architecture
---
# Session Recap — 14 Juin 2026

## Résumé
Diagnostic et réparation complète d'OpenCode (freeze au démarrage), installation du MCP Obsidian, documentation de l'infrastructure dotfiles.

## Problème : Freeze au démarrage OpenCode

### Cause racine
**`opencode.jsonc` écrasait `opencode.json`** dans la config résolue.

Ordre de chargement OpenCode :
1. `~/.config/opencode/config.json`
2. `~/.config/opencode/opencode.json` ← vrais secrets
3. `~/.config/opencode/opencode.jsonc` ← **override les valeurs !**
4. `.opencode/opencode.json` (local au projet)

Si `opencode.jsonc` contient des serveurs MCP avec `"enabled": true` (même avec fausses clés), OpenCode tente de s'y connecter → timeout → **freeze**.

### Correctif
`opencode.jsonc` ne doit **PAS** contenir de section `mcp` — la config réelle est dans `opencode.json` (gitignoré). Le fichier `.jsonc` sert uniquement pour le `$schema` et les commentaires.

### Fichiers touchés
| Fichier | Action |
|---------|--------|
| `D:\dotfiles\opencode-config\opencode.jsonc` | Supprimé la section MCP (ne garder que `$schema`) |
| `D:\dotfiles\opencode-config\opencode.json` | Inchangé (secrets réels, MCP en `enabled: false`) |
| `D:\dotfiles\opencode-config\opencode.example.json` | Template public de référence (inchangé) |

## Problème : Binaires OpenCode corrompus

### Cause
Les fichiers npm avaient été renommés :
```
opencode.ps1       → .opencode.ps1-3QkDfV7g
opencode.cmd       → .opencode.cmd-GRyDKhBZ
opencode           → .opencode-TWq5lvuQ
```
Et le binaire `bin/opencode.exe` était un placeholder vide (479 octets, `echo "Error..."`).

### Correctif
1. Renommer les fichiers `.opencode.*-*` → `opencode.*`
2. Copier le vrai binaire depuis `node_modules/opencode-windows-x64/bin/opencode.exe` (8 Mo) vers `node_modules/opencode-ai/bin/opencode.exe`
3. `npm install -g opencode-ai` si besoin (attention aux timeouts réseau)

### Versions
| Composant | Version |
|-----------|---------|
| CLI (npm) | 1.15.13 (stable) |
| Desktop | 1.17.6 |

⚠️ La v1.17.6 via npm avait un binaire incompatible avec Windows 10 22H2. Solution : forcer la v1.15.13.

## Infrastructure : Junctions Windows

```
C:\Users\PLY\.config\opencode  ← junction →  D:\dotfiles\opencode-config
C:\Users\PLY\.agents           ← junction →  D:\dotfiles\agents
```

Les modifications dans `D:\dotfiles\opencode-config\` sont automatiquement visibles via `~/.config/opencode/`.

## MCP Obsidian : Activation

### Problème
Le plugin Obsidian Local REST API utilise un **certificat auto-signé** pour le HTTPS (port 27124). OpenCode rejette ce certificat → `SSE error: self signed certificate`.

### Solution retenue
Activer le **port HTTP insecure** (27123) au lieu d'installer le certificat.

### Étapes
1. Modifier `D:\dotfiles\Obsidian Vault\.obsidian\plugins\local-rest-api\data.json` :
   ```json
   "enableInsecureServer": true
   ```
2. Modifier `D:\dotfiles\opencode-config\opencode.json` :
   ```json
   "url": "http://127.0.0.1:27123/mcp/"
   ```
3. Redémarrer Obsidian
4. Vérifier : `opencode mcp list` → `✓ obsidian connected`

### Alternative non retenue
Installer le cert auto-signé dans le store Windows :
```
certutil -addstore Root "%TEMP%\obsidian-local-cert.cer"
```
Nécessite admin, le `certutil` échouait avec `CRYPT_E_NO_MATCH`.

## Agents & Skills

### Fichiers créés
| Fichier | Contenu |
|---------|---------|
| `D:\dotfiles\AGENTS.md` | Documentation des 8 agents, ROUTER.md, structure du projet |
| `D:\admin\AGENTS.md` | Lien vers les agents depuis l'espace admin |

### État
- **39 skills** chargées depuis `~/.agents/skills/` (via junction)
- **8 agents** disponibles (`@agent-architect`, `@agent-qa-test`, etc.)
- **ROUTER.md** → scoring intent → skill (1-4)
- Startup : ~1.6-1.8s

## Scripts PowerShell

Les scripts dans `D:\dotfiles\scripts/` :
| Script | Rôle |
|--------|------|
| `knowledge-startup.ps1` | Session log, auto-fix ROUTER, daily digest |
| `knowledge-watch.ps1` | Veille multi-source (GitHub, HF, Reddit, Dev.to, ArXiv) |
| `git-watch.ps1` | Auto-commit/push sur changements |
| `obsidian-sync-back.ps1` | Détection nouvelles notes → suggestions routes |
| `obsidian-tagger.ps1` | Tags automatiques par contenu |
| `analytics-collect.ps1` | Stats d'usage + archive skills inutilisées |
| `github-issues.ps1` | Surveillance issues des repos trackés |
| `error-log.ps1` | Scan erreurs → note Obsidian |

## Recommandations

1. **Ne pas modifier `opencode.jsonc`** sans vérifier l'ordre de chargement
2. **Redémarrer Obsidian** après tout changement du plugin Local REST API
3. **Pour MCP HTTP** : utiliser le port 27123, pas de certificat nécessaire
4. **Pour le support multi-session** : garder `D:\admin` pour les réparations, `D:\dotfiles` pour le travail normal
5. **Commits** : ne pas oublier de `git push` les changements dans `D:\dotfiles`

