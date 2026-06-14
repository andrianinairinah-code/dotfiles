# _config.ps1 — résolution relative du root dotfiles
# Sourcer avec : . "$PSScriptRoot\_config.ps1"
$script:root = Resolve-Path "$PSScriptRoot\.."
