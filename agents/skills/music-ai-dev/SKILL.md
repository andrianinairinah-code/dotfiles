# Skill: Music AI Development

## Repos disponibles (clonés localement)
| Repo | Path | Utilité |
|------|------|---------|
| ACE-Step | `D:\musique\MUSIC IA\ACE-Step\` | Génération audio rapide (Apache 2.0) |
| Midra | `D:\musique\MUSIC IA\Midra\` | Prompt → MIDI éditable (Apache 2.0) |
| YouAndOrchestra | `D:\musique\MUSIC IA\YouAndOrchestra\` | Composition agentique (MIT) |
| K.G.One | `D:\musique\MUSIC IA\K.G.One\` | Studio IA local clé en main |

## Projet existant
- **Path**: `D:\musique\MUSIC IA\`
- **Type**: Professeur de Musique IA — bibliothèque pédagogique (patterns, riffs, exercices)
- **Stack**: Python, docs markdown, générateurs algorithmiques

## Recommandations par besoin
| Besoin | Solution |
|--------|----------|
| Générer un exercice audio (démo sonore) | ACE-Step |
| Générer un pattern MIDI (gamme, arpège, rythme) | Midra |
| Adapter exercices niveau élève | YaO (agentique, 7 sous-agents) |
| Plateforme studio IA complète | K.G.One (DAW browser + API) |
| Séparation de pistes audio | K.G.One (intègre python-audio-separator) |

## Commandes utiles
```powershell
# Midra: générer un pattern
cd D:\musique\MUSIC IA\Midra
python -m music_agent --prompt "pentatonic blues in A" --mode midi

# ACE-Step: générer audio
cd D:\musique\MUSIC IA\ACE-Step
ace-step --prompt "jazz piano exercise" --output exercise.wav
```
