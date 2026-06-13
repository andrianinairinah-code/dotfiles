# Skill Router — Intent → Skill Mapping

## Rules
- Scan user message for keywords in order (most specific first)
- Load **only** the best-matching skill via `skill` tool
- If none match, proceed without loading any skill

## Mapping
| Keywords / Intents | Skill(s) |
|---|---|
| *backtest, compile, .mq5, trading strategy, SMC, MT5, MetaTrader* | *(AGENTS.md)* |
| debug, bug, error, crash, regression, broken, failing | diagnose |
| test, tdd, unit test, integration test, red-green | tdd |
| design, interface, API, module shape, design it twice | design-an-interface |
| git push, git reset, dangerous git, git safety | git-guardrails-claude-code |
| Obsidian, vault, note, .md | obsidian-vault |
| Railway, deploy, service, deployment, app | use-railway |
| refactor, architecture, restructure, decouple | improve-codebase-architecture |
| code review, PR review, review since | review |
| issue, triage, bug report, feature request | triage |
| PRD, spec, plan, feature spec | to-prd / to-issues |
| teach, learn, tutorial, explain concept | teach |
| exercise, course, scaffold, problem set | scaffold-exercises |
| article, writing, edit, revise, draft | edit-article / writing-beats / writing-shape |
| ubiquitous, domain, glossary, DDD, terminology | ubiquitous-language |
| skill, new skill, write skill | write-a-skill |
| handoff, hand off, transfer, resume | handoff |
| caveman, less tokens, be brief, short | caveman |
| prototype, mock up, throwaway | prototype |
| pre-commit, husky, lint-staged, git hooks | setup-pre-commit |
| shoehorn, migrate as, type assertion | migrate-to-shoehorn |
| QA session, report, bug report | qa |
| grill, stress-test, challenge my plan | grill-me / grill-with-docs |
| plan refactor, refactor RFC, incremental | request-refactor-plan |
| zoom out, context, bigger picture | zoom-out |
| setup matt, agent skills, issue tracker | setup-matt-pocock-skills |
| music, MIDI, DAW, audio, song, génération musicale, ACE-Step, Midra | *(repos in D:\musique\MUSIC IA\ — Midra, YaO, K.G.One, ACE-Step)* |
