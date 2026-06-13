# 🧠 Mémoire & Leçons Apprises

Extraites de toutes les sessions d'agents. Mise à jour : 2026-06-12.

---

## Bonnes Pratiques Générales

### Workflow Agent
- **Écrire le plan avant le code** — `#blocker #todo` : ne jamais commencer sans validation du plan
- **Séparer les audits du projet** — Dossier indépendant `AUDIT_CORRECTIONS/` pas à l'intérieur du projet
- **Documenter chaque décision** avec `#decision` dans `AGENTS.md`
- **Logguer chaque fix** avec `#fix` pour traçabilité
- **Mémoire partagée** : utiliser `multi-agent-memo` MCP server pour la persistance inter-agents

### Structure de Projet
- **Templates AGENTS.md** : générés via Templater Obsidian avec prompts interactifs (nom, stack, DB, tests)
- **Dossiers catégories** : `projets-dev/`, `trading/`, `admin/`, `musique/`, `perso/`, `archives/`
- **Notes d'index** : un fichier central `00 - Projets.md` avec `[[wikilinks]]` vers chaque projet

### Déploiement Railway
- **Healthcheck** : utiliser `/` pas `/api/status` (nginx peut ne pas servir l'API directe)
- **Port conflict** : `pkill -f novnc_proxy` avant de démarrer nginx (port 6901 conflit)
- **Backtest container** : timeout même en Model=2 si multi-symbol — privilégier backtest local
- **Build remote** : utiliser `railway up` depuis le dossier projet (Docker Desktop cassé fréquent sur WSL2)

---

## Erreurs et Anti-Patterns

### Architecture
| Erreur | Dommage | Leçon |
|--------|---------|-------|
| **23 paires simultanées** | Overfitting, impossible de stabiliser le core | Valider sur 1 paire d'abord |
| **ML/ONNX/ADX/slopes/pivots** sur pipeline non stable | Complexité inutile, résultats non reproductibles | Pipeline pur d'abord (0 ML) |
| **Volume filters** sur Deriv-Demo | Données trop pauvres (ATR≈0 pour 60% trades) | Valider les dataset avant d'ajouter des features |
| **Scope hypertrophié** | Audit verdict : 2/10 | Un prototype, pas un système opérationnel |

### Railway
| Erreur | Dommage | Leçon |
|--------|---------|-------|
| **CDN HFM bloqué au runtime** | MT4 ne s'installe pas | Pré-télécharger les binaires dans l'image Docker |
| **PORT=6901 conflit nginx/noVNC** | nginx ne démarre pas | `pkill` avant restart + ports dédiés |
| **9 déploiements échouent même code** | Bloqué 2h+ | Railway infrastructure instable — script de retry |
| **CI/CD manuel** | `railway up` seulement | Automatiser GitHub → Railway trigger |
| **Multi-symbol backtest en container** | Timeout | Backtest local uniquement |

### Trading SMC
| Erreur | Impact | Leçon |
|--------|--------|-------|
| **Trailing SL ON + TP0 OFF** | -$3,640 | Trailing OFF + TP0 OFF = gain immédiat |
| **ML thr=0.55 trop restrictif** | 2/28 trades passent, WR 0% | Tester plusieurs thresholds |
| **TdMatch bloque ~48% des trades** | Moins d'opportunités | Qualité > quantité, WR plus élevé |
| **Vp inexploitable** sur Deriv-Demo | Feature inutile | Vérifier qualité données avant |
| **MetaQuotes-Demo supprimé** | Données perdues définitivement | Toujours garder un backup |

### Obsidian / Organisation
| Erreur | Leçon |
|--------|-------|
| **Dossiers plats (55 à la racine D:\)** | Catégoriser immédiatement |
| **Doublons de projets** (SMC-Framework ×3) | Archiver + backup structuré |
| **Dossiers vides** (gg, RAIL...) | Nettoyer régulièrement |

---

## Décisions Clés

| Décision | Contexte | Pourquoi |
|----------|----------|----------|
| **Pipeline SMC pur** | v2.06 → v2.12 | 0 ML/ONNX/ADX — meilleur perf que ML filter |
| **TdMatch = filtre primaire** | MATCH 41% vs MISMATCH 27% WR | Delta +14 pts, le meilleur discriminateur |
| **Zone Exemption U3** | 24 trades débloqués, WR 58% | Permet les retracements naturels |
| **U3+s48=DN+BUY → bloquer** | Règle finale | Évite les faux signaux en tendance baissière |
| **s48 (pente 48 bars) = feature #1** | ML pipeline lesson | Détrône tout le reste |
| **AUDIT_CORRECTIONS indépendant** | Pas dans SMC-Framework | Évite la contamination des sources |
| **claude-mem** installé | Mémoire persistante | Chroma disabled (fallback SQLite FTS5) |
| **Dossiers catégories sur D:\** | 55 → 9 dossiers | Navigation + maintenance |

---

## Commands Réutilisables

```bash
# Railway
railway logs --service courageous-consideration -e production --tail 20
railway up --no-gitignore

# SMC Compile
.\compile.bat SMC_H8_M1_v212_RegimeZonePlus.mq5

# SMC Backtest
cd BACKTEST; powershell -File .\run_23f_6m.ps1 -IniName fev2026_v212_regimezoneplus.ini

# Clean logs avant chaque run
del "$env:APPDATA\MetaQuotes\Tester\*\Agent-*\logs\*.log"

# Liste symboles MT5
python -c "import MetaTrader5 as mt5; mt5.initialize(); syms=mt5.symbols_get(); [print(s.name,'|',s.path) for s in syms]"

# claude-mem
curl http://localhost:37777/health

# Obsidian REST API
curl -k -H "Authorization: Bearer KEY" https://127.0.0.1:27124/vault/
```

---

## A Retenir Absolument

1. ✅ **Pipeline pur d'abord** — ML/features complexes seulement après validation baseline
2. ✅ **1 paire pour valider** — multi-paires = overfitting
3. ✅ **Plan avant code** — `#blocker #todo` jamais ignoré
4. ✅ **Backup avant tout** — MetaQuotes-Demo supprimé par erreur = leçon douloureuse
5. ✅ **Catégoriser immédiatement** — un dossier par type de projet
6. ✅ **Mémoire persistante** — `multi-agent-memo` ou `claude-mem` pour éviter de réapprendre
7. ✅ **Healthcheck `/` pas `/api/status`** — nginx sert la racine, pas forcément l'API
8. ✅ **Trailing OFF + TP0 OFF** — meilleur perf sur SMC

---

```dataview
TABLE file.folder AS "Catégorie"
FROM "03 - Ressources"
SORT file.name ASC
```
