---
tags: dev/ai dev/obsidian dev/debug dev/architecturetags: opencode guide configuration lessons learned
---

# OpenCode — Expérience et Leçons Apprises

## Installation sur un nouvel ordinateur

### 1. Installer OpenCode CLI
```powershell
npm install -g opencode-ai
```

⚠️ **Problème connu** : la version `1.17.6` peut planter sur Windows 10 22H2 (binaire incompatible). Si ça arrive :
```powershell
npm install -g opencode-ai@1.15.13
```

**Vérifier** :
```powershell
opencode --version
# Doit retourner un numéro de version (ex: 1.15.13)
```

Si l'erreur `"n'est pas une application Win32 valide"` apparaît :
```powershell
# 1. Vérifier le fichier
Get-Item "C:\Users\PLY\AppData\Roaming\npm\node_modules\opencode-ai\bin\opencode.exe"
# Si < 1 MB → placeholder corrompu

# 2. Copier le vrai binaire depuis les dépendances
Copy-Item "C:\Users\PLY\AppData\Roaming\npm\node_modules\opencode-ai\node_modules\opencode-windows-x64\bin\opencode.exe" `
          "C:\Users\PLY\AppData\Roaming\npm\node_modules\opencode-ai\bin\opencode.exe" -Force
```

### 2. Junctions (liens symboliques Windows)

Les deux dossiers suivants doivent être des **junctions** pointant vers le repo dotfiles :

```
# Config OpenCode
New-Item -ItemType Junction -Path "$env:USERPROFILE\.config\opencode" `
         -Target "D:\dotfiles\opencode-config" -Force

# Agents / Skills
New-Item -ItemType Junction -Path "$env:USERPROFILE\.agents" `
         -Target "D:\dotfiles\agents" -Force
```

**Vérifier** :
```powershell
(Get-Item "$env:USERPROFILE\.config\opencode").LinkType   # Doit afficher "Junction"
(Get-Item "$env:USERPROFILE\.agents").LinkType             # Doit afficher "Junction"
```

## Configuration du projet

### 3. Fichiers de config OpenCode

| Fichier | Rôle | Git ? |
|---------|------|-------|
| `opencode.json` | Config RÉELLE (secrets API, MCP, etc.) | **Ignoré** (`.gitignore`) |
| `opencode.jsonc` | Template public (juste `$schema`) | Commité |
| `opencode.example.json` | Référence template complet | Commité |

**⚠️ RÈGLE CRITIQUE** : `opencode.jsonc` est chargé APRÈS `opencode.json` et **override** ses valeurs.
- Ne JAMAIS mettre de serveurs MCP `enabled: true` dans `opencode.jsonc`
- Si le démarrage freeze → `opencode --pure debug config` pour voir la config résolue

### 4. Format `opencode.json`
```json
{
  "$schema": "https://opencode.ai/config.json",
  "mcp": {
    "obsidian": {
      "type": "remote",
      "url": "http://127.0.0.1:27123/mcp/",
      "headers": {
        "Authorization": "Bearer VOTRE_API_KEY"
      },
      "enabled": true
    }
  }
}
```

### 5. AGENTS.md
Créer `AGENTS.md` à la racine du projet pour activer les agents OpenCode :
```markdown
# Agent System

Agents et skills dans `D:\dotfiles\agents` (lié via `~/.agents`).

## Agents disponibles
architect, qa-test, strategist, writer, devsetup, ops, utility, knowledge

## Skills
39 skills via `agents/ROUTER.md` (scoring intent → skill)
```

## MCP Obsidian — Guide de connexion

### Méthode recommandée : HTTP (sans certificat)
```json
"mcp": {
  "obsidian": {
    "url": "http://127.0.0.1:27123/mcp/"
  }
}
```

**Étapes :**
1. Installer le plugin **Local REST API** dans Obsidian
2. Activer le port HTTP dans `.obsidian/plugins/local-rest-api/data.json` :
   ```json
   { "enableInsecureServer": true, "insecurePort": 27123 }
   ```
3. Redémarrer Obsidian
4. Copier la clé API dans `opencode.json`

**Vérification :**
```powershell
opencode mcp list
# ✓ obsidian → connected
```

### Méthode HTTPS (certificat auto-signé) — DÉCONSEILLÉE
Nécessite d'installer le certificat dans le store Windows **en admin** :
```powershell
# PowerShell en Administrateur
certutil -addstore Root "C:\Users\PLY\AppData\Local\Temp\obsidian-local-cert.cer"
```
⚠️ Problème connu : `CRYPT_E_NO_MATCH` peut échouer. Préférer HTTP.

## Dépannage

### Symptôme : OpenCode freeze au démarrage
```powershell
# 1. Vérifier la version
opencode --version

# 2. Voir la config résolue
opencode --pure debug config

# 3. Tester le démarrage sans plugins
opencode --pure debug startup
```

**Causes possibles :**
1. `opencode.jsonc` override `opencode.json` avec MCP `enabled: true` → retirer MCP de `.jsonc`
2. Binaire CLI corrompu → réinstaller ou copier depuis `node_modules`
3. Fichiers npm renommés → `Rename-Item`

### Symptôme : Fichiers npm renommés
Les fichiers `C:\Users\PLY\AppData\Roaming\npm\opencode.*` ont été renommés en `.opencode.*-XXXX` :
```powershell
Rename-Item -LiteralPath "C:\Users\PLY\AppData\Roaming\npm\.opencode.ps1-XXXX" "opencode.ps1" -Force
Rename-Item -LiteralPath "C:\Users\PLY\AppData\Roaming\npm\.opencode.cmd-XXXX" "opencode.cmd" -Force
```
Causé par une désinstallation npm ou un conflit de version.

### Symptôme : MCP Obsidian refuse la connexion
- Vérifier qu'Obsidian est lancé
- Vérifier le port : `Get-NetTCPConnection -LocalPort 27123`
- Vérifier l'API key dans `opencode.json`
- Vérifier le fichier `.obsidian/plugins/local-rest-api/acls.json` (autoriser `127.0.0.1`)

## Scripts d'automatisation

Tous les scripts sont dans `D:\dotfiles\scripts\` :

| Script | Déclencheur | Fonction |
|--------|-------------|----------|
| `knowledge-startup.ps1` | Login | Log session, auto-fix ROUTER, daily digest |
| `knowledge-watch.ps1` | Lundi 9h (planifié) | Veille multi-source → rapport dans Obsidian |
| `git-watch.ps1` | Arrière-plan (login) | Commit/push auto des changements |
| `obsidian-sync-back.ps1` | Login + veille hebdo | Détecte nouvelles notes, suggère routes |
| `obsidian-tagger.ps1` | Login + veille hebdo | Tagge auto les notes selon contenu |
| `analytics-collect.ps1` | Automatique | Archive skills inutilisées >30j |
| `github-issues.ps1` | Automatique | Surveille issues de 4 repos GitHub |
| `error-log.ps1` | Automatique | Scanne logs d'erreur → note Obsidian |

### Installer les tâches planifiées
```powershell
# Administrateur requis
powershell -File "D:\dotfiles\scripts\install-scheduled-task.ps1"
powershell -File "D:\dotfiles\scripts\install-git-watcher.ps1"
```

## Objectif de cette configuration

1. **Reproductibilité totale** — tout l'environnement tient dans `D:\dotfiles\`, un `git clone` + 3 commandes suffisent
2. **Automatisation maximale** — startup, veille, git push, tagging notes : tout tourne sans intervention
3. **Résilience** — guide + checklist + agent diagnostic pour ne jamais refaire les mêmes erreurs
4. **Centralisation** — les junctions Windows font le lien, on ne touche jamais à `C:\Users\...` directement

## Liste de vérification pour nouvel ordi

- [ ] `npm install -g opencode-ai@1.15.13`
- [ ] `opencode --version` → OK
- [ ] Junction `~/.config/opencode` → `D:\dotfiles\opencode-config`
- [ ] Junction `~/.agents` → `D:\dotfiles\agents`
- [ ] `opencode debug startup` → < 3 secondes
- [ ] `opencode mcp list` → Obsidian connected
- [ ] `opencode agent list` → agents disponibles
- [ ] `opencode debug skill` → 39 skills chargées
- [ ] Ajouter `DOTFILES_GH_TOKEN` dans les variables d'environnement
- [ ] Installer les tâches planifiées (admin)
- [ ] Lancer `knowledge-startup.ps1` au premier démarrage

