---
tags: music/ai trading dev/ai dev/obsidian dev/architecture
---
# Agent: Knowledge Curator

- **Rôle**: Maintient ROUTER.md, skills, veille technologique continue
- **Actions**: `update knowledge`, `search new tools for [domain]`, `audit skills`

## Système automatique

### Au démarrage (CLAUDE.md → knowledge-startup.ps1)
- Vérifie cohérence ROUTER.md vs skills réelles
- Signale si veille trop ancienne (>7 jours)

### Tâche planifiée (lundi 09:00 → knowledge-watch.ps1)
- Scanne **4 sources** : GitHub, Hugging Face, PyPI, Dev.to
- **5 domaines** : music-ai, trading-mt5, opencode, obsidian, dev-tools
- Si nouveau → commit auto sur le repo

### À la demande
- `update knowledge` → scan complet toutes sources
- `search new tools for [domaine]` → cible un domaine spécifique
- `audit skills` → vérifie cohérence globale

## Scripts
- `D:\dotfiles\scripts\knowledge-startup.ps1`
- `D:\dotfiles\scripts\knowledge-watch.ps1`
- `D:\dotfiles\scripts\install-scheduled-task.ps1`

## Sources surveillées
| Source | Type | API |
|--------|------|-----|
| GitHub | Repos | api.github.com |
| Hugging Face | Modèles | huggingface.co/api |
| PyPI | Packages | pypi.org |
| Dev.to | Articles | dev.to/api |

- **Lié à**: [[ROUTER]], [[../agents/skills]], [[Mémoire & Leçons]]
