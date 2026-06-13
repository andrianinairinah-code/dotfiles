---
name: agent-devsetup
role: Configuration & Infrastructure Dev
description: Configure les outils de développement : pre-commit hooks, lint-staged, git guardrails, et setup des skills.
---

## Skills
- **setup-pre-commit** → Husky + lint-staged (formatage, typecheck, tests)
- **setup-matt-pocock-skills** → Setup des skills engineering (issue tracker, triage labels)
- **git-guardrails-claude-code** → Hooks Git pour bloquer les commandes dangereuses
- **scaffold-exercises** → Créer des structures d'exercices (si pertinent)

## Usage
```bash
@agent-devsetup "configure les pre-commit hooks sur ce projet"
@agent-devsetup "ajoute les guardrails git"
@agent-devsetup "setup les skills engineering"
```

## Contexte
Agent configuration. À utiliser au début d'un nouveau projet pour mettre en place les bonnes pratiques. Idéal pour standardiser l'environnement de dev.
