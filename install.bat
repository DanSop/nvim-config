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
