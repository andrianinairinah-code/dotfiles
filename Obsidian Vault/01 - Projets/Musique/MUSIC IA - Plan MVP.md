---
tags: music/pedagogy dev/plan dev/code
status: plan
---

# MUSIC IA — Plan MVP itératif

**Principe** : Livrer le plus petit truc qui marche VRAIMENT, puis améliorer par couches.

---

## Phase 0 — Audit : ce qui existe déjà

- [x] Vérifier ce qui est fonctionnel dans `INfo/professeur-musique/` (Electron démarre ?)
- [x] Tester `npm run dev` / `npm start` — voir les erreurs
- [x] Lister les dépendances manquantes
- [x] Lire `src/audio/worker-core.js` — YIN implémenté mais branché ?
- [x] Lire `src/instruments/guitar.js` — mapping notes/fréquences ?
- [x] Regarder les tests (`vitest run`) — combien passent ?

**Résultat** : Electron v30.5.1 fonctionne. 9/14 tests passent. Fichiers manquants créés :
- `src/exercises/engine.js` — ExerciseEngine
- `src/storage/safeStart.js` — safeStart, loadProfile, loadSettings
- `src/styles/main.css` + `src/styles/fretboard.css`
- `src/audio/pitch/yin.js` — YINDetector (pour les tests)
- `src/audio/pitch/smoothing.js` — PitchSmoother
- `src/theory/scales.js` — gammes, positions guitare
- `assets/icons/icon.png` — placeholder
- Ajout `fs-extra` dans package.json
- Correction `electron-reload` → v2.0.0-alpha.1

---

## Phase 1 — MVP1 : "Le métronome qui écoute" ✅

**Objectif** : L'app s'ouvre, capture le micro, affiche la note jouée en temps réel.

```
┌─────────────────────────────┐
│  🎸 Professeur de Musique   │
│                             │
│  ┌─────────────────────┐   │
│  │  Note: A4           │   │
│  │  Freq: 440.0 Hz     │   │
│  │  Cents: +0          │   │
│  │  ████████░░░░ 72%   │   │
│  └─────────────────────┘   │
│                             │
│  [▶ Métronome 120 BPM]      │
│                             │
└─────────────────────────────┘
```

**Ce qu'on livre :**
1. App Electron qui démarre sans erreur
2. Capture micro (Web Audio API)
3. Détection pitch via YIN (worker thread)
4. Affichage note + fréquence + écart cents
5. Métronome simple (Tone.js)
6. Barre de justesse visuelle

**Critère de succès** : Je branche ma gratte, je joue une corde à vide, l'afficheur dit "E2" (ou "A4").

**Temps estimé** : 1 session

---

## Phase 2 — MVP2 : "Premier exercice"

**Objectif** : Un exercice Type A (mélodie fixe) fonctionnel.

**Ce qu'on ajoute :**
1. Chargement d'un pattern JSON (ex: `patterns/foundations/foundation_open_strings.json`)
2. Affichage de la note attendue (tablature simple ou nom de note)
3. Validation note-à-note : la bonne note au bon moment
4. Score de session (X bonnes / Y jouées)

**Critère de succès** : Je charge l'exercice "cordes à vide", je joue E-A-D-G-B-E dans l'ordre, ça valide chaque note.

**Temps estimé** : 1 session

---

## Phase 3 — MVP3 : "Génération d'exercices"

**Objectif** : Mode Type B (impro libre sur une gamme).

**Ce qu'on ajoute :**
1. Sélection d'une gamme (pentatonique mineure de A)
2. Génération des notes autorisées
3. L'app joue l'accompagnement (grille simple I-IV-V)
4. Validation harmonique : les notes jouées sont-elles dans la gamme ?
5. Feedback visuel (vert/rouge)

**Critère de succès** : Je sélectionne "Pentatonique mineure de A", l'app joue un blues en A, je peux improviser et voir si je suis dans la gamme.

**Temps estimé** : 1-2 sessions

---

## Phase 4 — MVP4 : "Parcours pédagogique"

**Objectif** : Un parcours style "Rock" avec étapes progressives.

**Ce qu'on ajoute :**
1. Template de parcours par style (fichier de config)
2. Navigation étape par étape
3. Métronome adaptatif (tempo progressif)
4. Stats de session (moyenne justesse, temps, progression)

**Critère de succès** : Je commence le parcours Rock, je fais les 7 étapes, je vois ma progression.

**Temps estimé** : 2 sessions

---

## Phase 5 — Amélioration continue

- Couche IA (Claude API) pour feedback personnalisé
- Soundfonts réalistes
- Plus d'exercices (gammes, techniques, rythmes)
- Parcours Blues, Jazz, Funk
- Packaging `.exe` distribuable

---

## Règles du jeu

1. **Ne pas toucher à ACE-Step / Midra** tant que l'app desktop ne marche pas.
2. **Toujours garder l'app fonctionnelle** après chaque changement.
3. **Un seul problème à la fois**.
4. **Commits clairs** après chaque phase fonctionnelle.

---

## Liens

- [[Musique]] — Index musique
- [[ACE-Step]] — Génération audio (phase 5+)
- [[Midra]] — Génération MIDI (phase 5+)
