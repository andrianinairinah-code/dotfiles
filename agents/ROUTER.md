# Skill Router — Intent → Skill Mapping (v2 avec scoring)

## Règles de résolution
1. **Ordre de priorité** : lignes du bas = plus spécifiques → testées en premier
2. **Score de pertinence** : chaque keyword matché ajoute +1 au score de la skill
3. **Conflit** : si 2+ skills ont le même score → charger la skill listée en premier dans le fichier
4. **Faux positif** : si le message est très court (1-2 mots), exiger match exact
5. Si aucun match → procéder sans skill

## Mapping (ordonné du + général au + spécifique)
| Score | Keywords / Intents | Skill(s) |
|---|---|---|
| 1 | *trading, backtest, SMC, MT5, MetaTrader, forex, MQL5, .mq5, compile, strategy* | *(AGENTS.md SMC)* |
| 1 | *obsidian, vault, note, .md, plugin* | obsidian-vault |
| 1 | *deploy, railway, service, app, déploiement* | use-railway |
| 3 | **debug, bug, error, crash, regression, broken, failing** | diagnose |
| 3 | **test, tdd, unit test, integration test, red-green, pytest** | tdd |
| 2 | *design, interface, API, module, shape* | design-an-interface |
| 2 | *git push, git reset, dangereux, git safety, git hook* | git-guardrails-claude-code |
| 3 | **refactor, architecture, restructure, decouple, tight coupling** | improve-codebase-architecture |
| 2 | *code review, PR review, review changes, review since* | review |
| 2 | *issue, triage, bug report, feature request, ticket* | triage |
| 2 | *PRD, spec, plan, feature spec, product requirement* | to-prd / to-issues |
| 2 | *teach, learn, tutorial, explain, concept* | teach |
| 2 | *exercise, course, scaffold, problem, exercice* | scaffold-exercises |
| 2 | *article, writing, edit, revise, draft, rédaction* | edit-article / writing-beats / writing-shape |
| 2 | *ubiquitous, domain, glossary, DDD, terminologie, ubiquitous language* | ubiquitous-language |
| 2 | *skill, new skill, write skill, créer skill* | write-a-skill |
| 3 | **handoff, hand off, transfer, resume, reprendre** | handoff |
| 4 | **caveman, less tokens, be brief, court, concis** | caveman |
| 2 | *prototype, mock up, throwaway, maquette* | prototype |
| 2 | *pre-commit, husky, lint-staged, git hooks* | setup-pre-commit |
| 2 | *shoehorn, migrate as, type assertion, @total-typescript* | migrate-to-shoehorn |
| 2 | *QA, quality, bug report, rapport bug* | qa |
| 3 | **grill, stress-test, challenge my plan, défi** | grill-me / grill-with-docs |
| 3 | **plan refactor, refactor RFC, refactoring plan** | request-refactor-plan |
| 2 | *zoom out, context, bigger picture, vue d'ensemble* | zoom-out |
| 2 | *setup matt, agent skills, issue tracker, triage labels* | setup-matt-pocock-skills |
| 3 | **music, MIDI, DAW, audio, song, génération musicale, ACE-Step, Midra** | music-ai-dev |
| 4 | **understand, codebase, knowledge graph, comprendre, analyser code** | understand / understand-chat / understand-dashboard |
| 4 | **understand-diff, understand-explain, understand-domain, understand-knowledge, understand-onboard** | understand-diff / understand-explain / understand-domain / understand-knowledge / understand-onboard |
| 4 | **update knowledge, search tools, audit skills, amélioration continue, veille** | *(agent-knowledge)* |

## Notes
- `*` = score 1 (général, peut matcher partout) — priorité basse
- `**` = score 3-4 (spécifique, match fort) — priorité haute
- Les scores sont cumulatifs : "debug broken test" → diagnose(1) + tdd(1) → conflit → résolu par ordre de fichier (diagnose gagne)
