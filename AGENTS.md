# Dotfiles — Agent System

Hub central d'automatisation et de connaissances. Les agents et skills sont dans `agents/`.

## Agents disponibles

Utilisez `@agent-<nom>` dans OpenCode :

| Agent | Rôle | Quand l'utiliser |
|-------|------|-----------------|
| `@agent-architect` | Architecture & Design | Refactoring, conception API, zoom |
| `@agent-qa-test` | Quality Assurance | Debug, TDD, code review, QA |
| `@agent-strategist` | Stratégie & Planning | Griller un plan, issues, PRD, triage |
| `@agent-writer` | Rédaction & Documentation | Articles, edit, teach, glossary |
| `@agent-devsetup` | Configuration Dev | Pre-commit, guardrails, setup skills |
| `@agent-ops` | Infrastructure | Railway, déploiement |
| `@agent-utility` | Utilitaires | Obsidian vault, handoff, caveman |
| `@agent-knowledge` | Knowledge Curator | Veille technologique, mise à jour ROUTER |
| `@agent-diagnostic` | Diagnostic & Dépannage | OpenCode freeze, config cassée, MCP HS |

## Skills routing

`agents/ROUTER.md` mappe les intentions utilisateur → skills via un système de scoring.
Plus le score est élevé (1-4), plus le match est spécifique et prioritaire.

## Structure

```
D:\dotfiles\
├── AGENTS.md               ← ce fichier
├── agents/
│   ├── ROUTER.md           ← routage intent → skill
│   ├── agents/             ← définitions des 8 agents
│   └── skills/             ← 39 skills OpenCode/Claude
├── opencode-config/        ← config OpenCode (junction → ~/.config/opencode)
├── scripts/                ← automatisation PowerShell
└── Obsidian Vault/         ← notes et connaissances
```

## Règles

1. Toujours charger ROUTER.md avant de répondre à une requête utilisateur
2. Skills dans `agents/skills/` — charger la skill matchée avant d'agir
3. `scripts/knowledge-startup.ps1` s'exécute automatiquement au démarrage
4. Ne pas modifier les fichiers dans `opencode-config/` sans vérifier la junction
