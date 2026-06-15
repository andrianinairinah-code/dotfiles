---
tags: trading dev/code mt5
---

# SMC — Réinstallation MT5 & Backtest Juin 2026

Date : 2026-06-15
Problème : MT5 désinstallé/réinstallé, profil perdu, backtest bloqué

## Problèmes Rencontrés

### 1. C: plein (0 Go libre)
- npm cache 6.3 Go, pip/uv cache 800 Mo, Downloads 880 Mo, .cache 480 Mo
- Corbeille, Mozilla cache, Tickstory 230 Mo
- → Nettoyage : récupéré ~9.7 Go sur C:

### 2. MT5 fraîchement installé ne crée pas de profil de données
- `D:\trading\MetaQuotes\Terminal\D0E8209F...` supprimé (11 Go)
- La nouvelle install (build 5836) tourne mais aucun répertoire MQL5 créé
- `common.ini` vide, pas de profil en `%APPDATA%`

### 3. Junction APPDATA → D:\ corrompue
- `C:\Users\PLY\AppData\Roaming\MetaQuotes` pointait vers `D:\MetaQuotes` (inexistant)
- Devait pointer vers `D:\trading\MetaQuotes`
- → Toute écriture via APPDATA\MetaQuotes échouait silencieusement

### 4. Backtest terminal64 /config: sort en 10s exit 0 sans logs
- Pas de MetaQuotes-Demo base (historique prix manquant)
- Pas de logs Tester, pas de rapports
- Agent de test enregistré mais sans données
- L'INJ de test était correcte mais rien à tester

### 5. Aucune donnée historique MetaQuotes-Demo
- Le dossier `Bases\MetaQuotes-Demo` n'existait pas
- Perdu définitivement avec la suppression du profil

### 6. Python MetaTrader5 ne s'initialise pas (Authorization failed)
- Le module pip installé dans un venv séparé
- L'authentification refuse après plusieurs tentatives
- Solution : tuer tous les processus terminal64 avant

## Solutions Appliquées

### 1. Nettoyage C:
```powershell
# npm cache
npm cache clean --force
Remove-Item "$env:LOCALAPPDATA\npm-cache\_cacache" -Recurse

# pip + uv
Remove-Item "$env:LOCALAPPDATA\pip" -Recurse
Remove-Item "$env:APPDATA\uv" -Recurse

# Downloads
Remove-Item "$env:USERPROFILE\Downloads\*" -Recurse

# MT5 logs
Remove-Item "D:\trading\MetaQuotes\Terminal\*\logs\*.log"

# Tickstory
Remove-Item "$env:APPDATA\Tickstory\*" -Recurse
```

### 2. Création du profil MT5
```powershell
# 1. Supprimer l'ancienne junction
Remove-Item "$env:APPDATA\MetaQuotes" -Recurse -Force

# 2. Créer la bonne junction
cmd /c "mklink /J `"%APPDATA%\MetaQuotes`" `"D:\trading\MetaQuotes`""

# 3. Créer le répertoire de profil
New-Item -Path "$env:APPDATA\MetaQuotes\Terminal\D0E8209F77C8CF37AD8BF550E51FF075" -ItemType Directory -Force

# 4. Copier les 56 EAs .ex5
Copy-Item "C:\Users\PLY\Desktop\MQL5_BACKUP\MQL5\Experts\*.ex5" "$profileDir\MQL5\Experts\" -Force

# 5. Copier les 61 includes .mqh
Copy-Item "C:\Users\PLY\Desktop\MQL5_BACKUP\MQL5\Include\*.mqh" "$profileDir\MQL5\Include\SMC\" -Force

# 6. Définir origin.txt
"C:\Program Files\MetaTrader 5" | Set-Content "$profileDir\origin.txt" -Force
```

### 3. Restauration de la config
Le backup lancé avant la suppression du profil contenait :
- 57 EAs .ex5
- 61 includes .mqh
- `accounts.dat`, `servers.dat`, `common.ini`

Le `servers.dat` du backup (714 Ko) remplace celui du profil (41 Ko).

### 4. Sync des données de prix via Python
```powershell
# Venv temporaire
python -m venv C:\Users\PLY\AppData\Local\Temp\opencode\mt5_venv
pip install MetaTrader5

# Connexion + sync des taux
mt5.initialize(path=r'C:\Program Files\MetaTrader 5\terminal64.exe',
               login=108372747, password='Dk-5CzEv',
               server='MetaQuotes-Demo')
rates = mt5.copy_rates_range('EURUSD', mt5.TIMEFRAME_M1,
                              datetime(2026,6,1), datetime(2026,6,16))
```
→ Crée le dossier `Bases\MetaQuotes-Demo` avec les données manquantes.

### 5. Arrangements finaux
- AppData\MetaQuotes pointe vers `D:\trading\MetaQuotes` via junction
- `servers.dat` sert aussi pour le Network (données de trading) ET le Tester
- Le backtest nécessite que le terminal ait déjà téléchargé les données au moins une fois
- `ShutdownTerminal=1` dans l'INI ferme le terminal après le backtest

## Backtest Juin 2026 — Résultats

EA : `SMC_H8_M1_v206_RegimeZone` (15 paires, TdMatch, ZoneEx U3, Trailing OFF, Risk 1%)

| Métrique | Valeur |
|----------|--------|
| Trades | 20 |
| Wins | 8 |
| Losses | 12 |
| WR | 40.0% |
| PF | 0.67 |
| Avg RR | 1.50 |
| Net | +$1 200.00 |
| DD | 4.00% |
| Durée | 1-14 juin 2026 |

Comparatif v2.06 :
| Mois | Trades | WR | Net | DD |
|------|--------|----|------|----|
| Fév 2026 | 37 | 40.5% | +$2 300 | 6% |
| Mar 2026 | 18 | 33.3% | +$600 | 5% |
| **Juin 2026** | **20** | **40.0%** | **+$1 200** | **4%** |

15 paires testées, 910 987 ticks générés.

## Fichiers Clés

- Profile MT5 : `D:\trading\MetaQuotes\Terminal\D0E8209F77C8CF37AD8BF550E51FF075`
- Junction : `C:\Users\PLY\AppData\Roaming\MetaQuotes` → `D:\trading\MetaQuotes`
- Backup EAs : `C:\Users\PLY\Desktop\MQL5_BACKUP`
- INI backtest : `D:\projets-dev\SMC-Framework\SMC_M1\BACKTEST\juin2026_v206_regimezone.ini`
- Log Tester : `D:\trading\MetaQuotes\Tester\D0E8209F77C8CF37AD8BF550E51FF075\Agent-127.0.0.1-3000\logs\`

[[MetaQuotes|⬆ MetaQuotes]]
[[Trading|⬆ Retour au Trading]]
