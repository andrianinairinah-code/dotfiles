# 🤖 Index des Agents

Tous les agents, skills et configurations d'agents IA.

---

## Agents par Rôle (~/.agents/agents/)

| Agent | Rôle | Skills incluses |
|-------|------|-----------------|
| [[agent-architect]] | Architecture & Design | design, refactoring, zoom, prototype |
| [[agent-qa-test]] | Quality Assurance | diagnose, tdd, review, qa, shoehorn |
| [[agent-strategist]] | Stratégie & Planning | grill, issues, prd, triage, refactor plan |
| [[agent-writer]] | Rédaction & Documentation | edit, beats, fragments, teach, ubiquitous |
| [[agent-devsetup]] | Configuration Dev | pre-commit, guardrails, skills setup |
| [[agent-ops]] | Infrastructure & Déploiement | railway, prototype |
| [[agent-utility]] | Utilitaires | caveman, handoff, obsidian, skills |

## Projets Agents

| Agent | Projet | Type | Fichier |
|-------|--------|------|---------|
| [[opencode-agent-free]] | opencode-agent-free | Agent principal | `AGENTS.md` + `CLAUDE.md` |
| [[deep-research-agent]] | opencode-agent-free/skills-extras | Skill recherche | `AGENTS.md` + `CLAUDE.md` |
| [[SMC-Framework-Coach]] | SMC-Framework/SMC_M1 | Framework Coach | `AGENTS.md` (15KB) |
| [[nysoabtp-agent]] | Mandimby + CORRECTIONS | Dev Web BTP | `AGENTS.md` (×5 versions) |
| [[BootN8n-agent]] | BootN8N | Trading + n8n-MCP | `CLAUDE.md` (25KB) |

## Skills Globales (~/.agents/skills/)

| Catégorie | Skills |
|-----------|--------|
| **Communication** | caveman, handoff |
| **Design/Architecture** | design-an-interface, improve-codebase-architecture, zoom-out |
| **Debug/Tests** | diagnose, tdd, qa, migrate-to-shoehorn |
| **Git/Setup** | git-guardrails-claude-code, setup-pre-commit, setup-matt-pocock-skills |
| **Planning** | grill-me, grill-with-docs, to-issues, to-prd, triage, request-refactor-plan |
| **Review** | review, scaffold-exercises |
| **Writing** | edit-article, writing-beats, writing-fragments, writing-shape, ubiquitous-language, teach |
| **Infra** | use-railway, prototype |
| **Obsidian** | obsidian-vault |
| **Agents** | write-a-skill |

## Configs Globales

| Type | Emplacement | Contenu |
|------|-------------|---------|
| **OpenCode Config** | `~/.config/opencode/opencode.json` | MCP: Supabase + Obsidian |
| **OpenCode Config** | `~/.config/opencode/opencode.jsonc` | Configuration alternative |
| **Claude Config** | `~/.claude/CLAUDE.md` | Contexte Claude |
| **Claude-Mem** | `~/.claude-mem/` | Mémoire persistante |
| **cagent** | `~/.cagent/` | Agent store |

---

```dataview
TABLE type AS "Type", projet AS "Projet", status AS "Statut"
FROM "02 - Zones"
WHERE type
SORT file.name ASC
```
