#!/usr/bin/env bash
# ==========================================
# dotfiles 설치 스크립트 (Linux / macOS)
# ==========================================
# dotfiles 안의 설정들을 올바른 위치로 심볼릭 링크합니다.
# 기존 파일이 있으면 .bak 으로 백업한 뒤 링크합니다.
#
# 사용법:  ./install.sh              # 전체 (셸·도구·tmux·nvim + 터미널 에뮬레이터)
#          ./install.sh --minimal    # 클라이언트 전용 스킵 (헤드리스/SSH 박스: ghostty 제외)
# Windows 는 install.ps1 을 사용하세요.

set -euo pipefail

MINIMAL=0
for arg in "$@"; do
  case "$arg" in
    --minimal) MINIMAL=1 ;;
    *) echo "알 수 없는 옵션: $arg" >&2; exit 1 ;;
  esac
done

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

# ── 서버/이식 (L3·L4·L5): 어디서나 ────────────
link "$DOTFILES/nvim"                "$XDG_CONFIG/nvim"
link "$DOTFILES/tmux/.tmux.conf"     "$HOME/.tmux.conf"
link "$DOTFILES/zsh/.zshrc"          "$HOME/.zshrc"
link "$DOTFILES/zsh/.zshenv"         "$HOME/.zshenv"
link "$DOTFILES/starship/starship.toml" "$XDG_CONFIG/starship.toml"
link "$DOTFILES/bat"                 "$XDG_CONFIG/bat"
link "$DOTFILES/btop"                "$XDG_CONFIG/btop"
link "$DOTFILES/fastfetch/config.jsonc" "$XDG_CONFIG/fastfetch/config.jsonc"
link "$DOTFILES/git/.gitconfig"      "$HOME/.gitconfig"

# ── 클라이언트 전용 (L2): --minimal 이면 스킵 ──
if [ "$MINIMAL" -eq 0 ]; then
  # Ghostty 는 확장자 없는 "config" 만 읽습니다. 기존 오타 파일(config.ghostty)은 그대로 둠.
  link "$DOTFILES/ghostty/config"    "$XDG_CONFIG/ghostty/config"
else
  echo "  (--minimal: ghostty 스킵)"
fi

# ── bat 테마 캐시 (tokyonight tmTheme 반영) ──
if command -v bat >/dev/null 2>&1; then
  bat cache --build >/dev/null 2>&1 && echo "  bat 테마 캐시 빌드 완료"
fi

echo ""
echo "완료. 남은 1회 작업:"
echo "  1) 도구 설치:  ./tools/install-bins.sh        (no-sudo, 선택)"
echo "  2) 셸/클립보드: sudo apt install zsh wl-clipboard"
echo "  3) 기본 셸 변경: chsh -s \$(command -v zsh)     (재로그인 후 적용)"
echo "  4) tmux 플러그인: tmux 안에서 prefix(C-Space) + I"
echo "     └ 세션 영속(resurrect/continuum)과 C-h/j/k/l pane 이동이 여기 달려 있음"
echo "  * Neovim 첫 실행 시 플러그인 자동 설치."
echo "  * nvim 의 Claude Code 연동(<leader>c*)은 claude CLI 가 PATH 에 있을 때만 동작."
echo "  * 키맵 전체: docs/keymaps.md"
