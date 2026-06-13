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
const testFramework = await tp.system.suggester(
    ["Jest", "Vitest", "Mocha", "Pytest", "Cargo Test", "Go Test"],
    ["jest", "vitest", "mocha", "pytest", "cargo-test", "go-test"]
);
const port = await tp.system.prompt("🔌 Port local ?", "3000");
const author = await tp.system.prompt("👤 Votre nom ?", "Developer");
%>

# Projet : <% projectName %>

**Type** : <% projectType %> | **Langage** : <% primaryLang %> | **Stack** : <% backend %> + <% database %>

## Structure

```
<% projectName %>/
├── src/
│   ├── routes/
│   ├── controllers/
│   ├── models/
│   ├── middleware/
│   └── services/
├── tests/
│   ├── unit/
│   ├── integration/
│   └── e2e/
├── docs/
└── scripts/
```

## Stack

| Élément | Choix |
|---------|-------|
| Langage | <% primaryLang %> |
| Backend | <% backend %> |
| BDD | <% database %> |
| Tests | <% testFramework %> |
| Port | <% port %> |

## Commandes

```bash
npm run dev
npm run build
npm test
npm run lint
```

## Statut

- [ ] Initialisation
- [ ] En développement
- [ ] Terminé

---

_Généré le <% tp.date.now("YYYY-MM-DD HH:mm") %>_
