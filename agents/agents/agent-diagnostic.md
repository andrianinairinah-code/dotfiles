---
name: agent-diagnostic
role: Diagnostic & Dépannage OpenCode
description: Diagnostique et répare les problèmes OpenCode : freeze au démarrage, config corrompue, MCP déconnecté, binaire manquant, junctions cassées.
---

## Skills
- **customize-opencode** → Réparer la config OpenCode (opencode.json/.jsonc, junctions)
- **diagnose** → Debug des bugs et erreurs
- **zoom-out** → Vue d'ensemble du système pour identifier les problèmes

## Procédure de diagnostic

### 1. Vérifier la version
```powershell
opencode --version
```

### 2. Vérifier le démarrage
```powershell
opencode debug startup
```

### 3. Vérifier la config résolue
```powershell
opencode --pure debug config
```
Problème connu : si `opencode.jsonc` override `opencode.json` avec MCP `enabled: true` → freeze.

### 4. Vérifier les junctions
```powershell
(Get-Item "$env:USERPROFILE\.config\opencode").LinkType  # Doit être Junction
(Get-Item "$env:USERPROFILE\.agents").LinkType            # Doit être Junction
```

### 5. Vérifier le binaire CLI
```powershell
Get-Item "C:\Users\PLY\AppData\Roaming\npm\node_modules\opencode-ai\bin\opencode.exe"
# Taille > 1 MB = OK. 479 octets = placeholder corrompu → copier depuis node_modules
```

### 6. Vérifier les MCP
```powershell
opencode mcp list
```

### 7. Vérifier les fichiers npm
```powershell
Get-ChildItem "C:\Users\PLY\AppData\Roaming\npm" -Filter "open*" -Name
# Ne doivent PAS être préfixés par "." ou avoir des suffixes aléatoires
```

## Usage
```bash
@agent-diagnostic "OpenCode ne s'ouvre plus"
@agent-diagnostic "vérifie ma config"
@agent-diagnostic "le MCP Obsidian ne se connecte pas"
```

## Contexte
Agent à utiliser en premier quand OpenCode a un problème de démarrage ou de configuration. Suit la checklist de dépannage documentée dans le vault Obsidian.
