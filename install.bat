:<<"::CMDBATCH"
@echo off
setlocal
set "REPO=https://github.com/DanSop/nvim-config.git"
set "CFG=%LOCALAPPDATA%\nvim"

where scoop >nul 2>nul || powershell -NoProfile -ExecutionPolicy Bypass -Command "irm get.scoop.sh | iex"
set "PATH=%USERPROFILE%\scoop\shims;%PATH%"

call scoop install git neovim ripgrep fd tree-sitter gcc make win32yank
call scoop update neovim

if not exist "%CFG%\.git" (
  if exist "%CFG%" (
    for /f %%t in ('powershell -NoProfile -Command "Get-Date -Format yyyyMMddHHmmss"') do move "%CFG%" "%CFG%.bak-%%t"
  )
  git clone "%REPO%" "%CFG%"
)

nvim --headless -c qa
echo Done. Start nvim.
exit /b
::CMDBATCH

set -eu
repo='https://github.com/DanSop/nvim-config.git'
cfg="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"

if command -v apt-get >/dev/null 2>&1; then
  sudo apt-get update
  sudo apt-get install -y git make gcc curl unzip ripgrep fd-find xclip
elif command -v dnf >/dev/null 2>&1; then
  sudo dnf install -y git make gcc curl unzip ripgrep fd-find xclip
elif command -v pacman >/dev/null 2>&1; then
  sudo pacman -S --noconfirm --needed git make gcc curl unzip ripgrep fd xclip
fi

nvim_ok() {
  command -v nvim >/dev/null 2>&1 && nvim --version | head -1 | grep -qE 'v0\.(1[2-9]|[2-9][0-9])'
}

if ! nvim_ok; then
  curl -fsSL https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz -o /tmp/nvim.tar.gz
  sudo rm -rf /opt/nvim-linux-x86_64
  sudo tar -C /opt -xzf /tmp/nvim.tar.gz
  sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
  rm -f /tmp/nvim.tar.gz
fi

if ! command -v tree-sitter >/dev/null 2>&1; then
  curl -fsSL https://github.com/tree-sitter/tree-sitter/releases/latest/download/tree-sitter-linux-x64.gz | gunzip > /tmp/tree-sitter
  sudo install -m 755 /tmp/tree-sitter /usr/local/bin/tree-sitter
  rm -f /tmp/tree-sitter
fi

if [ ! -d "$cfg/.git" ]; then
  if [ -e "$cfg" ]; then
    mv "$cfg" "$cfg.bak-$(date +%Y%m%d%H%M%S)"
  fi
  git clone "$repo" "$cfg"
fi

nvim --headless -c 'qa'
echo 'Done. Start nvim.'
