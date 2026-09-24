$ErrorActionPreference = 'Stop'
$repo = 'https://github.com/DanSop/nvim-config.git'
$cfg = Join-Path $env:LOCALAPPDATA 'nvim'

if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
  Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
  Invoke-RestMethod -Uri 'https://get.scoop.sh' | Invoke-Expression
}

scoop install git neovim ripgrep fd tree-sitter gcc make win32yank
scoop update neovim

if (-not (Test-Path (Join-Path $cfg '.git'))) {
  if (Test-Path $cfg) {
    Rename-Item $cfg ('nvim.bak-' + (Get-Date -Format 'yyyyMMddHHmmss'))
  }
  git clone $repo $cfg
}

nvim --headless -c 'qa'
Write-Host 'Done. Start nvim.'
