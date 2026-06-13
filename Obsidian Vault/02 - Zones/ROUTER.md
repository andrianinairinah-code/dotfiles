# ROUTER — Système de Routage des Skills

**Fichier source** : `D:\dotfiles\agents\ROUTER.md` (backup git)
**Junction** : `C:\Users\PLY\.claude\ROUTER.md`
**Mécanisme** : CLAUDE.md → scan ROUTER.md → `skill` tool

## Mapping intention → skill
Détecte les keywords dans le message utilisateur et charge la skill correspondante via la tool `skill`.

Voir le fichier ROUTER.md pour la liste complète des mappings.

## Auto-maintenance
- `agent-knowledge` met à jour ROUTER.md automatiquement
- Nouveau projet cloné → ajout route
- Nouveau domaine récurrent → création skill dédiée
- Skill inutilisée 30 jours → archivage

**Lié à** : [[agent-knowledge]], [[../agents/skills]]
