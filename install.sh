#!/usr/bin/env bash
# ==========================================
# dotfiles 설치 스크립트 (Linux / macOS)
# ==========================================
# dotfiles 안의 설정들을 올바른 위치로 심볼릭 링크합니다.
# 기존 파일이 있으면 .bak 으로 백업한 뒤 링크합니다.
#
# 사용법:  ./install.sh
# Windows 는 install.ps1 을 사용하세요.

set -euo pipefail

# 이 스크립트가 위치한 디렉토리 = dotfiles 루트
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# XDG config 경로 (기본값 ~/.config)
XDG_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}"

# OS 확인 (Windows 는 별도 스크립트)
case "$(uname -s)" in
  Linux* | Darwin*) ;;
  *)
    echo "지원하지 않는 OS 입니다. Windows 는 install.ps1 을 사용하세요." >&2
    exit 1
    ;;
esac

# link <소스> <대상>
# 대상이 이미 존재하고 심링크가 아니면 백업합니다.
link() {
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"

  if [ -L "$dst" ]; then
    rm "$dst"                      # 기존 심링크는 교체
  elif [ -e "$dst" ]; then
    local backup="${dst}.bak.$(date +%Y%m%d%H%M%S)"
    mv "$dst" "$backup"
    echo "  기존 파일 백업: $backup"
  fi

  ln -s "$src" "$dst"
  echo "  링크 생성: $dst -> $src"
}

echo "dotfiles 설치 시작 (루트: $DOTFILES)"

# ── 링크 매핑 ─────────────────────────────
# 항목을 추가할 때 이 블록에 link 호출을 늘리면 됩니다.
link "$DOTFILES/nvim"          "$XDG_CONFIG/nvim"
link "$DOTFILES/tmux/.tmux.conf" "$HOME/.tmux.conf"
# 예시 (추후):
# link "$DOTFILES/zsh/.zshrc"      "$HOME/.zshrc"
# link "$DOTFILES/git/.gitconfig"  "$HOME/.gitconfig"
# ──────────────────────────────────────────

echo "완료. Neovim 을 처음 실행하면 플러그인이 자동 설치됩니다."
