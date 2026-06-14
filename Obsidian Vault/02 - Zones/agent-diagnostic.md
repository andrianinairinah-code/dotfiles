---
tags: dev/ai dev/debug dev/infra
---
# agent-diagnostic

**Rôle** : Diagnostic & Dépannage OpenCode
**Description** : Diagnostique et répare les problèmes OpenCode : freeze au démarrage, config corrompue, MCP déconnecté, binaire manquant, junctions cassées.

## Procédure
1. `opencode --version` → vérifier la version
2. `opencode debug startup` → vérifier le démarrage
3. `opencode --pure debug config` → config résolue (vérifier que `.jsonc` n'override pas MCP)
4. Vérifier les junctions `~/.config/opencode` et `~/.agents`
5. Vérifier le binaire CLI (> 1 Mo)
6. `opencode mcp list` → MCP connectés

Voir [[OpenCode — Experience et Lecons Apprises]] pour la checklist complète.
