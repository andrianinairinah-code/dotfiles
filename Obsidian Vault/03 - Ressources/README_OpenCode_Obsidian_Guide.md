---
tags: dev/ai dev/obsidian dev/infra dev/debug dev/architecture dev/code
---
# 🚀 OpenCode + Obsidian — Guide Complet

> Ce guide explique comment exploiter **OpenCode** (agent IA de codage) avec **Obsidian** (vault de connaissances) pour créer un workflow de développement intelligent, 100% gratuit.

---

## 📋 Table des matières

1. [Qu'est-ce qu'OpenCode ?](#-quest-ce-quopencode)
2. [Qu'est-ce qu'Obsidian ?](#-quest-ce-quobsidian)
3. [Pourquoi les combiner ?](#-pourquoi-les-combiner)
4. [Installation](#-installation)
5. [Configuration MCP (communication)](#-configuration-mcp)
6. [Templates AGENTS.md](#-templates-agentsmd)
7. [Workflow quotidien](#-workflow-quotidien)
8. [Chatbots dans Obsidian](#-chatbots-dans-obsidian)
9. [Commandes essentielles](#-commandes-essentielles)
10. [Résolution des problèmes](#-résolution-des-problèmes)

---

## 🤖 Qu'est-ce qu'OpenCode ?

**OpenCode** est un agent de codage IA open-source qui s'exécute dans votre terminal.

| Caractéristique | Description |
|-----------------|-------------|
| **Prix** | 100% gratuit et open-source |
| **Interface** | Terminal (TUI) |
| **Modèles** | Claude, GPT-4, Gemini, ou modèles locaux (Ollama) |
| **IDE** | VS Code, Cursor, Zed, JetBrains |
| **Git** | Automatise les issues et PRs |
| **Modes** | `Plan` (lecture) ↔ `Build` (écriture) via `Tab` |

### Installation

```bash
# Méthode 1 : Script officiel
curl -fsSL https://opencode.ai/install | bash

# Méthode 2 : Homebrew (macOS/Linux)
brew install opencode

# Méthode 3 : npm
npm install -g opencode
```

### Commandes de base

| Commande | Action |
|----------|--------|
| `opencode` | Lancer l'agent |
| `Tab` | Basculer Plan ↔ Build |
| `/undo` | Annuler la dernière modification |
| `/redo` | Refaire |
| `Ctrl+Esc` | Ouvrir dans split view (VS Code) |

---

## 📝 Qu'est-ce qu'Obsidian ?

**Obsidian** est un gestionnaire de notes basé sur des fichiers Markdown locaux, avec un système de liens puissant (`[[...]]`).

| Fonction | Gratuit | Payant (Sync/Publish) |
|----------|---------|----------------------|
| Toutes les notes locales | ✅ | — |
| Liens `[[...]]` et graphique | ✅ | — |
| Plugins communautaires | ✅ | — |
| Thèmes personnalisés | ✅ | — |
| **Sync cloud** | ❌ | $8/mois |
| **Publish web** | ❌ | $16/mois |

### Structure recommandée du vault

```
📦 Mon-Vault/
├── 📁 00 - Inbox/              → Notes rapides, captures
├── 📁 01 - Projets/            → Projets actifs (générés)
├── 📁 02 - Zones/              → Domaines de vie (Dev, Design...)
├── 📁 03 - Ressources/         → Articles, livres, références
├── 📁 04 - Archives/           → Projets terminés
├── 📁 99 - Templates/          → Modèles de notes
│   ├── 🚀 AGENTS Generator.md
│   ├── 📓 Note Quotidienne.md
│   └── 📚 Ressource.md
└── 📄 README.md                → Ce guide
```

---

## 🔗 Pourquoi les combiner ?

| Obsidian | OpenCode | Résultat |
|----------|----------|----------|
| **Planifie** et structure les idées | **Exécute** et génère le code | Workflow intelligent |
| Templates de projets | Création automatique de fichiers | Projets en 30 secondes |
| Documentation vivante | Code auto-généré | Contexte toujours à jour |
| Graphe de connaissances | Architecture de code | Vision globale |

### Workflow idéal

```
┌─────────────────────────────────────────────────────────────┐
│  1. OBSIDIAN — Vous planifiez                                 │
│     ├── Créez une note avec le template AGENTS Generator      │
│     ├── Remplissez les prompts interactifs (stack, langage...)  │
│     └── Générez automatiquement le fichier AGENTS.md            │
├─────────────────────────────────────────────────────────────┤
│  2. TRANSFERT — MCP ou copier/coller                          │
│     ├── MCP : OpenCode lit directement le vault               │
│     └── Manuel : Copiez AGENTS.md dans le dossier projet      │
├─────────────────────────────────────────────────────────────┤
│  3. OPENCODE — L'IA code                                      │
│     ├── Lit AGENTS.md (stack, architecture, conventions)        │
│     ├── Génère tous les fichiers (src/, tests/, config...)      │
│     └── Initialise Git, installe les dépendances              │
├─────────────────────────────────────────────────────────────┤
│  4. RETOUR — OpenCode écrit dans Obsidian (optionnel)         │
│     ├── Met à jour la documentation                           │
│     ├── Ajoute des tâches dans les notes                      │
│     └── Crée un changelog automatique                         │
└─────────────────────────────────────────────────────────────┘
```

---

## ⚙️ Installation

### 1. OpenCode

```bash
curl -fsSL https://opencode.ai/install | bash
opencode --version
```

### 2. Plugins Obsidian requis (gratuits)

| Plugin | Fonction | Installation |
|--------|----------|-------------|
| **Templater** | Templates dynamiques avec variables | Plugins communautaires → Rechercher "Templater" |
| **QuickAdd** | Snippets rapides | Plugins communautaires → Rechercher "QuickAdd" |
| **Obsidian Git** | Sync avec GitHub | Plugins communautaires → Rechercher "Obsidian Git" |
| **Dataview** | Requêtes sur les notes | Plugins communautaires → Rechercher "Dataview" |
| **Periodic Notes** | Notes quotidiennes | Plugins communautaires → Rechercher "Periodic Notes" |
| **Local REST API** | API pour OpenCode | Plugins communautaires → Rechercher "Local REST API" |
| **MCP Tools** | Pont MCP sécurisé | Plugins communautaires → Rechercher "MCP Tools for Obsidian" |

### 3. Activer l'API REST dans Obsidian

```
Paramètres → Plugins communautaires → Local REST API
→ Activer
→ Copier la clé API (affichée dans les paramètres)
→ Notez le port (par défaut : 27124)
```

---

## 🔌 Configuration MCP (communication OpenCode ↔ Obsidian)

### Méthode 1 : MCP Tools for Obsidian (recommandé)

Le plugin **MCP Tools** crée un pont sécurisé entre Obsidian et OpenCode.

#### Étape 1 : Configurer le plugin MCP Tools dans Obsidian

```
Paramètres → MCP Tools for Obsidian
→ Cliquer "Install Server"
→ Le plugin configure automatiquement le serveur MCP local
```

#### Étape 2 : Configurer OpenCode

Créez un fichier `opencode.json` à la racine de votre projet :

```json
{
  "mcp": {
    "obsidian": {
      "type": "local",
      "command": ["npx", "-y", "@oleksandrkucherenko/mcp-obsidian"],
      "environment": {
        "API_KEY": "{env:OBSIDIAN_API_KEY}",
        "API_URLS": ["https://127.0.0.1:27124"]
      },
      "enabled": true
    }
  }
}
```

#### Étape 3 : Définir la clé API

```bash
export OBSIDIAN_API_KEY="votre-cle-api-copiee-dans-obsidian"
```

#### Étape 4 : Tester

```bash
opencode
# Puis demander : "Liste tous les fichiers dans mon vault Obsidian"
```

### Méthode 2 : MCP Server manuel (uvx)

```bash
# Installer le serveur MCP Obsidian
pip install mcp-obsidian

# Ou avec uvx
uvx mcp-obsidian
```

Configuration `opencode.json` :

```json
{
  "mcp": {
    "obsidian": {
      "type": "local",
      "command": ["uvx", "mcp-obsidian"],
      "environment": {
        "OBSIDIAN_API_KEY": "votre-cle-api",
        "OBSIDIAN_HOST": "127.0.0.1",
        "OBSIDIAN_PORT": "27124"
      },
      "enabled": true
    }
  }
}
```

### Ce que OpenCode peut faire via MCP

| Action | Exemple de prompt |
|--------|-------------------|
| **Lire une note** | `"Lis la note [[Mon Projet]] et résume-la"` |
| **Rechercher** | `"Cherche tous les fichiers mentionnant 'authentification'"` |
| **Créer une note** | `"Crée une note dans 01-Projets/ avec le template AGENTS"` |
| **Modifier une section** | `"Ajoute une tâche dans la section 'TODO' de [[Projet]]"` |
| **Lister les tags** | `"Quels sont mes projets [[nodejs]] ?"` |
| **Exécuter un template** | `"Exécute le template 'Nouveau Projet' avec le nom 'mon-api'"` |

---

## 📄 Templates AGENTS.md

### Qu'est-ce que AGENTS.md ?

C'est un **fichier de contexte** que OpenCode lit pour comprendre votre projet : stack, architecture, conventions, commandes.

### Template Templater (génération interactive)

Placez ce fichier dans `99 - Templates/AGENTS Generator.md` :

```markdown
<%*
const projectName = await tp.system.prompt("📛 Nom du projet ?");
const projectType = await tp.system.suggester(
    ["API REST", "Fullstack Web", "CLI Tool", "Library", "Mobile App", "Autre"],
    ["api-rest", "fullstack", "cli", "library", "mobile", "other"]
);
const primaryLang = await tp.system.suggester(
    ["JavaScript", "TypeScript", "Python", "Rust", "Go", "Java"],
    ["javascript", "typescript", "python", "rust", "go", "java"]
);
const backend = await tp.system.suggester(
    ["Express", "Fastify", "NestJS", "Django", "Flask", "FastAPI", "Aucun"],
    ["express", "fastify", "nestjs", "django", "flask", "fastapi", "none"]
);
const database = await tp.system.suggester(
    ["PostgreSQL", "MySQL", "MongoDB", "SQLite", "Redis", "Supabase"],
    ["postgresql", "mysql", "mongodb", "sqlite", "redis", "supabase"]
);
const orm = await tp.system.suggester(
    ["Prisma", "TypeORM", "Sequelize", "Mongoose", "SQLAlchemy", "Aucun"],
    ["prisma", "typeorm", "sequelize", "mongoose", "sqlalchemy", "none"]
);
const testFramework = await tp.system.suggester(
    ["Jest", "Vitest", "Mocha", "Pytest", "Cargo Test", "Go Test"],
    ["jest", "vitest", "mocha", "pytest", "cargo-test", "go-test"]
);
const port = await tp.system.prompt("🔌 Port local ?", "3000");
const author = await tp.system.prompt("👤 Votre nom ?", "Developer");
%>

# 🧠 AGENTS.md — Contexte pour OpenCode

> Ce fichier guide OpenCode pour comprendre et générer le code de ce projet.

---

## 📋 Informations générales

| Champ | Valeur |
|-------|--------|
| **Nom du projet** | <% projectName %> |
| **Type** | <% projectType %> |
| **Date de création** | <% tp.date.now("YYYY-MM-DD") %> |
| **Auteur** | <% author %> |
| **Licence** | MIT |
| **Statut** | 🟡 En développement |

---

## 🛠 Stack technique

- **Langage** : <% primaryLang %>
- **Backend** : <% backend %>
- **Base de données** : <% database %>
- **ORM** : <% orm %>
- **Tests** : <% testFramework %>
- **Port local** : <% port %>

---

## 📁 Architecture

```
<% projectName %>/
├── 📁 src/
│   ├── 📁 routes/          → Endpoints API
│   ├── 📁 controllers/     → Logique métier
│   ├── 📁 models/          → Schémas de données
│   ├── 📁 middleware/      → Auth, validation, logs
│   ├── 📁 services/        → Services réutilisables
│   └── 📁 utils/           → Helpers
├── 📁 tests/
│   ├── 📁 unit/            → Tests unitaires
│   ├── 📁 integration/     → Tests d'intégration
│   └── 📁 e2e/             → Tests end-to-end
├── 📁 docs/                → Documentation
├── 📁 scripts/             → Scripts utilitaires
├── .env.example            → Variables d'environnement
├── .gitignore
├── README.md
└── package.json / Cargo.toml / requirements.txt
```

---

## 🎯 Conventions de code

| Élément | Convention | Exemple |
|---------|------------|---------|
| Fichiers | kebab-case | `user-controller.js` |
| Classes | PascalCase | `UserController` |
| Fonctions | camelCase | `getUserById` |
| Constantes | UPPER_SNAKE_CASE | `MAX_RETRY` |

---

## 🧪 Tests

| Type | Couverture |
|------|------------|
| Unit | 80% |
| Integration | 70% |
| E2E | 50% |

---

## 🚀 Commandes

```bash
# Démarrer
npm run dev

# Build
npm run build

# Tests
npm test

# Lint
npm run lint

# Format
npm run format
```

---

## 🔗 API

Base URL : `http://localhost:<% port %>/api`

| Méthode | Route | Description | Auth |
|---------|-------|-------------|------|
| POST | /auth/register | Créer un compte | ❌ |
| POST | /auth/login | Se connecter | ❌ |
| GET | /users/me | Profil | ✅ |

---

## ⚠️ Points d'attention

1. Ne jamais commit les fichiers `.env`
2. Toujours écrire les tests avant le code (TDD)
3. Respecter les conventions de nommage

---

> 🔄 Généré le <% tp.date.now("YYYY-MM-DD HH:mm") %> depuis Obsidian.
```

### Utilisation du template

1. **Créer une nouvelle note** : `Ctrl + N`
2. **Insérer le template** : `Ctrl + P` → `Templater: Open Insert Template Modal`
3. **Répondre aux prompts** : nom, type, langage, stack...
4. **Le fichier AGENTS.md est généré** automatiquement

---

## 🔄 Workflow quotidien

### Morning (Obsidian)

```
08:00  → Note quotidienne (Periodic Notes)
       → Capturer les idées dans 00 - Inbox

09:00  → Traiter l'Inbox
       → Créer les projets avec Templater (AGENTS Generator)
       → Déplacer les notes vers les bons dossiers
```

### Coding (OpenCode)

```
10:00  → Ouvrir le terminal dans le dossier projet
       → Lancer OpenCode : opencode
       → Demander : "Génère le projet selon AGENTS.md"
       → OpenCode lit le contexte et code tout

12:00  → Vérifier les modifications
       → /undo si nécessaire
       → Commit Git
```

### Documentation (Retour Obsidian)

```
18:00  → Révision du graphe (Ctrl + G)
       → Vérifier les liens inversés
       → Créer des MOC si nécessaire
       → Mettre à jour la documentation du projet
```

---

## 🤖 Chatbots dans Obsidian

| Plugin | Chatbot | MCP | RAG | Prix |
|--------|---------|-----|-----|------|
| **Smart Composer** | Intégré | ✅ | ✅ | Gratuit |
| **Copilot for Obsidian** | Sidebar | ❌ | ✅ | Gratuit |
| **VaultAI** | Flottant | ❌ | ✅ | Gratuit |
| **BMO Chatbot** | Panel | ❌ | ❌ | Gratuit |
| **SystemSculpt** | Workflow | ❌ | ✅ | Gratuit |
| **Obsilo Agent** | Agent autonome | ✅ | ✅ | Gratuit |

### Smart Composer (recommandé)

```
Paramètres → Plugins communautaires → Smart Composer
→ Installer → Activer
→ Configurer votre clé API (OpenAI, Anthropic, etc.)
→ Ouvrir avec Ctrl/Cmd + Shift + O
```

**Fonctionnalités :**
- Chat avec contexte de votre vault (`@nom-de-fichier`)
- RAG (recherche sémantique dans toutes vos notes)
- Apply Edit (appliquer les modifications en un clic)
- **MCP Support** : se connecte à des outils externes

---

## 🎮 Commandes essentielles

### OpenCode

| Commande | Action |
|----------|--------|
| `opencode` | Lancer l'agent |
| `Tab` | Basculer Plan ↔ Build |
| `/undo` | Annuler la dernière modification |
| `/redo` | Refaire |
| `@fichier` | Référencer un fichier spécifique |
| `Ctrl+Esc` | Ouvrir dans split view (VS Code) |

### Obsidian

| Raccourci | Action |
|-----------|--------|
| `Ctrl + N` | Nouvelle note |
| `Ctrl + P` | Palette de commandes |
| `Ctrl + O` | Ouvrir une note |
| `Ctrl + G` | Graphe de connaissances |
| `Ctrl + Shift + F` | Recherche globale |
| `[[` | Créer un lien |
| `$$` | Bloc mathématique |
| `Ctrl + Shift + O` | Ouvrir Smart Composer |

### Templater

| Commande | Action |
|----------|--------|
| `Ctrl + P` → `Templater: Open Insert Template Modal` | Insérer un template |
| `Ctrl + P` → `Templater: Replace templates in the active file` | Remplacer les variables |

---

## 🔧 Résolution des problèmes

### Problème : OpenCode ne voit pas Obsidian

```bash
# Vérifier que l'API REST est active
curl -k https://127.0.0.1:27124/
# Doit retourner : {"status":"OK"}

# Vérifier la clé API
curl -k -H "Authorization: Bearer VOTRE_CLE" https://127.0.0.1:27124/vault/
```

### Problème : MCP ne se connecte pas

```bash
# Vérifier que le serveur MCP est installé
npx -y @oleksandrkucherenko/mcp-obsidian --help

# Vérifier la configuration opencode.json
cat opencode.json
```

### Problème : Templater ne génère pas le template

```
Paramètres → Templater
→ Vérifier que le dossier "Template folder location" est bien configuré
→ Vérifier que le fichier AGENTS Generator.md est dans ce dossier
```

---

## 📚 Ressources

- [OpenCode Documentation](https://opencode.ai)
- [Obsidian Help](https://help.obsidian.md)
- [Templater Documentation](https://silentvoid13.github.io/Templater/)
- [MCP Protocol](https://modelcontextprotocol.io)
- [Quartz (publish gratuit)](https://quartz.jzhao.xyz)

---

## 💡 Astuces avancées

### Synchronisation gratuite (sans Obsidian Sync)

| Outil | Type | Prix |
|-------|------|------|
| **GitHub + Obsidian Git** | Cloud | Gratuit |
| **Syncthing** | P2P local | Gratuit |
| **Dropbox/Google Drive** | Cloud | Gratuit (15 Go) |

### Publier gratuitement (sans Obsidian Publish)

| Outil | Prix | Comment |
|-------|------|---------|
| **GitHub Pages** | Gratuit | Export HTML → push |
| **Netlify** | Gratuit | Glisser-déposer |
| **Quartz** | Gratuit | Générateur de site statique |

### Snippets rapides avec QuickAdd

Configurez des raccourcis `$` dans QuickAdd :

| Raccourci | Action |
|-----------|--------|
| `$node` | Génère structure Node.js |
| `$react` | Génère structure React |
| `$py` | Génère structure Python |
| `$rust` | Génère structure Rust |
| `$git` | Insère `.gitignore` standard |
| `$readme` | Insère template README.md |

---

> **Ce workflow est 100% gratuit.** Aucun abonnement Obsidian Sync, Publish ou OpenCode n'est requis.
> Utilisez GitHub + Obsidian Git pour la synchronisation et MCP pour la communication.

---

*Généré le 2026-06-12 — OpenCode + Obsidian Guide*

